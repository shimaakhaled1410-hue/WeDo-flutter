const functions = require("firebase-functions");
const admin = require("firebase-admin");
admin.initializeApp();

exports.sendTaskAlerts = functions.pubsub.schedule('every 1 minutes').onRun(async (context) => {
    const now = admin.firestore.Timestamp.now();

    const tasksSnapshot = await admin.firestore().collection('tasks')
        .where('alertTime', '<=', now)
        .where('isCompleted', '==', false)
        .get();

    if (tasksSnapshot.empty) {
        console.log("No alerts to send.");
        return null;
    }

    const promises = [];

    tasksSnapshot.forEach((doc) => {
        const task = doc.data();

        if (task.alertSent === true) return;

        const targetUserId = task.assignedToUserId || task.creatorId;

        if (targetUserId) {
            const p = admin.firestore().collection('users').doc(targetUserId).get().then(async (userDoc) => {
                if (userDoc.exists) {
                    const fcmToken = userDoc.data().fcmToken;
                    if (fcmToken) {
                        const message = {
                            notification: {
                                title: "Task Reminder ⏰",
                                body: `Don't forget your task: ${task.title}`
                            },
                            token: fcmToken
                        };
                        
                        await admin.messaging().send(message);
                        
                        await doc.ref.update({ alertSent: true });
                        console.log(`Alert sent successfully for task: ${task.title}`);
                    }
                }
            });
            promises.push(p);
        }
    });

    await Promise.all(promises);
    return null;
});