const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onDocumentWritten, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");
const { t } = require("./notifications_i18n");

if (!admin.apps.length) {
  admin.initializeApp();
}

exports.sendTaskAlerts = onSchedule("every 1 minutes", async (event) => {
  const now = new Date();
  try {
    const tasksSnapshot = await admin.firestore().collection("tasks").get();

    for (const doc of tasksSnapshot.docs) {
      const task = doc.data();

      if (task.alertSent === true) continue;
      if (!task.alertTime || !task.assignedToUserId) continue;

      const alertTime = task.alertTime.toDate();
      if (alertTime <= now) {
        const assignedUserId = task.assignedToUserId;

        const userDoc = await admin.firestore().collection("users").doc(assignedUserId).get();
        if (!userDoc.exists) continue;

        const userData = userDoc.data();
        const fcmToken = userData?.fcmToken;
        const pushLocale = userData?.locale || "en";

        const msgEn = t("en");
        const msgAr = t("ar");

        const titleEn = msgEn.taskAlertTitle;
        const titleAr = msgAr.taskAlertTitle;
        const bodyEn = msgEn.taskAlertBody(task.title);
        const bodyAr = msgAr.taskAlertBody(task.title);

        await admin.firestore().collection("users").doc(assignedUserId).collection("notifications").add({
          titleEn,
          titleAr,
          bodyEn,
          bodyAr,
          taskId: doc.id,
          projectId: task.projectId || "",
          projectName: task.projectName || "Project",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          isRead: false,
        });

        if (fcmToken) {
          const pushMsg = t(pushLocale);
          await admin.messaging().send({
            notification: {
              title: pushMsg.taskAlertTitle,
              body: pushMsg.taskAlertBody(task.title),
            },
            data: {
              taskId: doc.id,
              projectId: task.projectId || "",
              click_action: "FLUTTER_NOTIFICATION_CLICK",
            },
            token: fcmToken,
          });
        }

        await doc.ref.update({ alertSent: true });
      }
    }
  } catch (error) {
    console.error("Error in sendTaskAlerts:", error);
  }
});

exports.onTaskAssigned = onDocumentWritten("tasks/{taskId}", async (event) => {
  if (!event.data || !event.data.after.exists) return;

  const oldTask = event.data.before.exists ? event.data.before.data() : null;
  const newTask = event.data.after.data();

  if (!newTask || !newTask.assignedToUserId) return;

  const assignedUserId = newTask.assignedToUserId;
  const creatorId = newTask.creatorId;

  if (creatorId && assignedUserId === creatorId) {
    console.log("ℹ️ User assigned a task to himself. Skipping notification.");
    return;
  }

  const isNewlyAssigned = !oldTask || oldTask.assignedToUserId !== assignedUserId;

  if (!isNewlyAssigned) {
    console.log("ℹ️ Task updated, but assignedToUserId did not change.");
    return;
  }

  const msgEn = t("en");
  const msgAr = t("ar");

  let assignerName = msgEn.defaultAssignerName; // same value used for both locales unless overwritten
  let assignerNameAr = msgAr.defaultAssignerName;

  if (creatorId) {
    try {
      const creatorDoc = await admin.firestore().collection("users").doc(creatorId).get();
      if (creatorDoc.exists) {
        const creatorName = creatorDoc.data()?.name;
        if (creatorName) {
          assignerName = creatorName;
          assignerNameAr = creatorName;
        }
      }
    } catch (e) {
      console.error("Error fetching creator name:", e);
    }
  }

  try {
    const userDoc = await admin.firestore().collection("users").doc(assignedUserId).get();
    if (!userDoc.exists) return;

    const userData = userDoc.data();
    const fcmToken = userData?.fcmToken;
    const pushLocale = userData?.locale || "en";

    const titleEn = msgEn.taskAssignedTitle;
    const titleAr = msgAr.taskAssignedTitle;
    const bodyEn = msgEn.taskAssignedBody(assignerName, newTask.title);
    const bodyAr = msgAr.taskAssignedBody(assignerNameAr, newTask.title);

    await admin.firestore().collection("users").doc(assignedUserId).collection("notifications").add({
      titleEn,
      titleAr,
      bodyEn,
      bodyAr,
      taskId: event.params.taskId,
      projectId: newTask.projectId || "",
      projectName: newTask.projectName || "Project",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isRead: false,
    });

    if (fcmToken) {
      const pushMsg = t(pushLocale);
      const pushAssignerName = pushLocale === "ar" ? assignerNameAr : assignerName;
      await admin.messaging().send({
        notification: {
          title: pushMsg.taskAssignedTitle,
          body: pushMsg.taskAssignedBody(pushAssignerName, newTask.title),
        },
        data: {
          projectId: newTask.projectId || "",
          taskId: event.params.taskId,
          click_action: "FLUTTER_NOTIFICATION_CLICK",
        },
        token: fcmToken,
      });
      console.log("🚀 FCM Notification sent to assigned user:", assignedUserId);
    }
  } catch (error) {
    console.error("Error sending Task Assigned notification:", error);
  }
});

exports.onProjectMemberJoined = onDocumentUpdated("projects/{projectId}", async (event) => {
  console.log("🔔 [TRIGGER] Project document updated. Project ID:", event.params.projectId);

  if (!event.data) return;

  const oldData = event.data.before.data() || {};
  const newData = event.data.after.data() || {};

  const oldMembers = oldData.collaboratorsIds || [];
  const newMembers = newData.collaboratorsIds || [];

  console.log(`📊 Old members count: ${oldMembers.length}, New members count: ${newMembers.length}`);

  if (newMembers.length > oldMembers.length) {
    const joinedUserId = newMembers.find((m) => !oldMembers.includes(m));
    console.log("👤 Joined User ID:", joinedUserId);

    if (!joinedUserId) return;

    const ownerId = newData.ownerId;
    if (!ownerId || joinedUserId === ownerId) return;

    try {
      const joinedUserDoc = await admin.firestore().collection("users").doc(joinedUserId).get();
      const ownerDoc = await admin.firestore().collection("users").doc(ownerId).get();

      const msgEn = t("en");
      const msgAr = t("ar");

      const joinedUserNameRaw = joinedUserDoc.data()?.name;
      const joinedUserName = joinedUserNameRaw || msgEn.defaultJoinedUserName;
      const joinedUserNameAr = joinedUserNameRaw || msgAr.defaultJoinedUserName;

      const ownerData = ownerDoc.data();
      const ownerFcmToken = ownerData?.fcmToken;
      const pushLocale = ownerData?.locale || "en";

      const projectName = newData.name || newData.title || "Project";

      const titleEn = msgEn.memberJoinedTitle;
      const titleAr = msgAr.memberJoinedTitle;
      const bodyEn = msgEn.memberJoinedBody(joinedUserName, projectName);
      const bodyAr = msgAr.memberJoinedBody(joinedUserNameAr, projectName);

      await admin.firestore().collection("users").doc(ownerId).collection("notifications").add({
        titleEn,
        titleAr,
        bodyEn,
        bodyAr,
        projectId: event.params.projectId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isRead: false,
      });

      if (ownerFcmToken) {
        const pushMsg = t(pushLocale);
        const pushJoinedUserName = pushLocale === "ar" ? joinedUserNameAr : joinedUserName;
        await admin.messaging().send({
          notification: {
            title: pushMsg.memberJoinedTitle,
            body: pushMsg.memberJoinedBody(pushJoinedUserName, projectName),
          },
          data: {
            projectId: event.params.projectId,
            click_action: "FLUTTER_NOTIFICATION_CLICK",
          },
          token: ownerFcmToken,
        });
        console.log("🚀 FCM Push Notification sent successfully to owner!");
      }
    } catch (error) {
      console.error("❌ Error processing onProjectMemberJoined:", error);
    }
  }
});