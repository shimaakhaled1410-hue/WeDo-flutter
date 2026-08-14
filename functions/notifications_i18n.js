const messages = {
  en: {
    taskAlertTitle: "⏰ Task Alert!",
    taskAlertBody: (taskTitle) => `Don't forget: ${taskTitle}`,
    taskAssignedTitle: "📌 New Task Assigned!",
    taskAssignedBody: (assignerName, taskTitle) =>
      `${assignerName} assigned you a new task: "${taskTitle}"`,
    memberJoinedTitle: "🎉 New Member Joined!",
    memberJoinedBody: (userName, projectName) =>
      `${userName} joined your project "${projectName}"`,
    defaultProjectName: "Project",
    defaultAssignerName: "Someone",
    defaultJoinedUserName: "A new member",
  },
  ar: {
    taskAlertTitle: "⏰ تذكير بمهمة!",
    taskAlertBody: (taskTitle) => `لا تنسَ: ${taskTitle}`,
    taskAssignedTitle: "📌 تم إسناد مهمة جديدة إليك!",
    taskAssignedBody: (assignerName, taskTitle) =>
      `أسند إليك ${assignerName} مهمة جديدة: "${taskTitle}"`,
    memberJoinedTitle: "🎉 انضم عضو جديد!",
    memberJoinedBody: (userName, projectName) =>
      `انضم ${userName} إلى مشروعك "${projectName}"`,
    defaultProjectName: "مشروع",
    defaultAssignerName: "أحد المستخدمين",
    defaultJoinedUserName: "عضو جديد",
  },
};

function t(locale) {
  return messages[locale] || messages.en;
}

module.exports = { t };