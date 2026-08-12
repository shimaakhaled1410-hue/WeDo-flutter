const { onSchedule } = require("firebase-functions/v2/scheduler");
const { onDocumentWritten, onDocumentUpdated } = require("firebase-functions/v2/firestore");
const admin = require("firebase-admin");

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

        const fcmToken = userDoc.data()?.fcmToken;
        const title = "⏰ Task Alert!";
        const body = `Don't forget: ${task.title}`;

        await admin.firestore().collection("users").doc(assignedUserId).collection("notifications").add({
          title,
          body,
          taskId: doc.id,
          projectId: task.projectId || "",
          projectName: task.projectName || "Project",
          createdAt: admin.firestore.FieldValue.serverTimestamp(),
          isRead: false,
        });

        if (fcmToken) {
          await admin.messaging().send({
            notification: { title, body },
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

  let assignerName = "Someone";
  if (creatorId) {
    try {
      const creatorDoc = await admin.firestore().collection("users").doc(creatorId).get();
      if (creatorDoc.exists) {
        assignerName = creatorDoc.data()?.name || "Someone";
      }
    } catch (e) {
      console.error("Error fetching creator name:", e);
    }
  }

  try {
    const userDoc = await admin.firestore().collection("users").doc(assignedUserId).get();
    if (!userDoc.exists) return;

    const fcmToken = userDoc.data()?.fcmToken;
    const title = "📌 New Task Assigned!";
    const body = `${assignerName} assigned you a new task: "${newTask.title}"`;

    await admin.firestore().collection("users").doc(assignedUserId).collection("notifications").add({
      title,
      body,
      taskId: event.params.taskId,
      projectId: newTask.projectId || "",
      projectName: newTask.projectName || "Project",
      createdAt: admin.firestore.FieldValue.serverTimestamp(),
      isRead: false,
    });

    if (fcmToken) {
      await admin.messaging().send({
        notification: { title, body },
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

      const joinedUserName = joinedUserDoc.data()?.name || "A new member";
      const ownerFcmToken = ownerDoc.data()?.fcmToken;

      const projectName = newData.name || newData.title || "Project";
      const title = "🎉 New Member Joined!";
      const body = `${joinedUserName} joined your project "${projectName}"`;

      await admin.firestore().collection("users").doc(ownerId).collection("notifications").add({
        title,
        body,
        projectId: event.params.projectId,
        createdAt: admin.firestore.FieldValue.serverTimestamp(),
        isRead: false,
      });

      if (ownerFcmToken) {
        await admin.messaging().send({
          notification: { title, body },
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

