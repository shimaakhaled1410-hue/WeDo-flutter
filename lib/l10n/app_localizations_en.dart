// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'WeDo';

  @override
  String get welcomeBack => 'Welcome Back!';

  @override
  String get loginSubtitle => 'Log in to continue your tasks';

  @override
  String get createAccount => 'Create an Account';

  @override
  String get registerSubtitle => 'Join WeDo to collaborate on tasks';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get fullName => 'Full Name';

  @override
  String get login => 'Login';

  @override
  String get signUp => 'Sign Up';

  @override
  String get dontHaveAccount => 'Don\'t have an account? ';

  @override
  String get alreadyHaveAccount => 'Already have an account? ';

  @override
  String get myLists => 'My Lists';

  @override
  String activeProjectsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'You have $count active project$_temp0';
  }

  @override
  String get noProjectsYet => 'No projects yet';

  @override
  String get tapAddToCreate =>
      'Tap \"add\" below to create your first project.';

  @override
  String get notifications => 'Notifications';

  @override
  String unreadNotifications(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return '$count unread notification$_temp0';
  }

  @override
  String get allCaughtUp => 'You\'re all caught up';

  @override
  String get noNotificationsYet => 'No notifications yet';

  @override
  String get notificationsEmptyHint =>
      'When something new comes in, you\'ll see it here.';

  @override
  String get somethingWentWrong => 'Something went wrong';

  @override
  String get tryAgain => 'Try again';

  @override
  String get myProfile => 'My Profile';

  @override
  String get projects => 'Projects';

  @override
  String get doneTasks => 'Done Tasks';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get themeMode => 'Theme Mode';

  @override
  String get signOut => 'Sign Out';

  @override
  String get signOutConfirm =>
      'Are you sure you want to sign out\nof your account?';

  @override
  String get cancel => 'Cancel';

  @override
  String get themeModeLight => 'Light';

  @override
  String get themeModeDark => 'Dark';

  @override
  String get themeModeSystem => 'System';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageArabic => 'Arabic';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordHint => '••••••••';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get accountCreatedSuccess => 'Account Created Successfully!';

  @override
  String get nameRequired => 'Please enter your name';

  @override
  String get createProject => 'Create New Project';

  @override
  String get editProject => 'Edit Project';

  @override
  String get projectNameLabel => 'Project Name';

  @override
  String get projectNameHint => 'Project Name (e.g. Groceries)';

  @override
  String get projectNameRequired => 'Please enter a project name';

  @override
  String get chooseIcon => 'Choose Icon';

  @override
  String get createProjectSubtitle =>
      'Give your project a name and pick an icon.';

  @override
  String get editProjectSubtitle => 'Update the name or icon of your project.';

  @override
  String get createProjectButton => 'Create Project';

  @override
  String get saveChanges => 'Save Changes';

  @override
  String get projectCreatedSuccess => 'Project created successfully!';

  @override
  String get projectUpdatedSuccess => 'Project updated successfully';

  @override
  String tasksCount(int completed, int total) {
    return '$completed/$total tasks';
  }

  @override
  String get notStarted => 'Not started';

  @override
  String get deleteProjectTitle => 'Delete Project';

  @override
  String deleteProjectConfirm(String name) {
    return 'Are you sure you want to delete \"$name\"?\nThis cannot be undone.';
  }

  @override
  String projectDeleted(String name) {
    return 'Project \"$name\" deleted';
  }

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get inviteCollaborator => 'Invite Collaborator';

  @override
  String get inviteLinkCopied => 'Invite link copied to clipboard!';

  @override
  String get filterAll => 'All';

  @override
  String get filterMyTasks => 'My Tasks';

  @override
  String get filterPending => 'Pending';

  @override
  String get filterDone => 'Done';

  @override
  String get noTasksFound => 'No tasks found';

  @override
  String get addNewTask => 'Add New Task';

  @override
  String get whatNeedsToBeDone => 'What needs to be done?';

  @override
  String get taskTitleRequired => 'Please enter task title';

  @override
  String get assignTo => 'Assign to';

  @override
  String get assignedMember => 'Assigned Member';

  @override
  String get member => 'Member';

  @override
  String get setAlertTime => 'Set Alert Time';

  @override
  String alertLabel(String date, String time) {
    return 'Alert: $date · $time';
  }

  @override
  String get addTask => 'Add Task';

  @override
  String taskDeleted(String title) {
    return 'Task \"$title\" deleted';
  }

  @override
  String get editTask => 'Edit Task';

  @override
  String get enterNewTaskTitle => 'Enter new task title';

  @override
  String get save => 'Save';

  @override
  String get taskUpdatedSuccess => 'Task updated successfully';

  @override
  String get profileImageUpdatedSuccess =>
      'Profile image updated successfully!';

  @override
  String get justNow => 'Just now';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get yesterday => 'Yesterday';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }
}
