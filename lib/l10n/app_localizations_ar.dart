// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'WeDo';

  @override
  String get welcomeBack => 'أهلاً بعودتك!';

  @override
  String get loginSubtitle => 'سجّل الدخول لمتابعة مهامك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'انضم إلى WeDo للتعاون في المهام';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟ ';

  @override
  String get alreadyHaveAccount => 'لديك حساب بالفعل؟ ';

  @override
  String get myLists => 'قوائمي';

  @override
  String activeProjectsCount(int count) {
    return 'لديك $count مشروع نشط';
  }

  @override
  String get noProjectsYet => 'لا توجد مشاريع بعد';

  @override
  String get tapAddToCreate => 'اضغط على \"إضافة\" أدناه لإنشاء أول مشروع لك.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String unreadNotifications(int count) {
    return '$count إشعار غير مقروء';
  }

  @override
  String get allCaughtUp => 'لا توجد إشعارات جديدة';

  @override
  String get noNotificationsYet => 'لا توجد إشعارات بعد';

  @override
  String get notificationsEmptyHint => 'عند وصول أي جديد، ستجده هنا.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get tryAgain => 'حاول مرة أخرى';

  @override
  String get myProfile => 'الملف الشخصي';

  @override
  String get projects => 'المشاريع';

  @override
  String get doneTasks => 'المهام المنجزة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get themeMode => 'وضع المظهر';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirm =>
      'هل أنت متأكد من رغبتك في تسجيل الخروج\nمن حسابك؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get themeModeLight => 'فاتح';

  @override
  String get themeModeDark => 'داكن';

  @override
  String get themeModeSystem => 'حسب النظام';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';

  @override
  String get emailHint => 'you@example.com';

  @override
  String get passwordHint => '••••••••';

  @override
  String get emailRequired => 'الرجاء إدخال البريد الإلكتروني';

  @override
  String get passwordRequired => 'الرجاء إدخال كلمة المرور';

  @override
  String get chooseLanguage => 'اختر اللغة';

  @override
  String get passwordMinLength =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get accountCreatedSuccess => 'تم إنشاء الحساب بنجاح!';

  @override
  String get nameRequired => 'الرجاء إدخال الاسم';

  @override
  String get createProject => 'إنشاء مشروع جديد';

  @override
  String get editProject => 'تعديل المشروع';

  @override
  String get projectNameLabel => 'اسم المشروع';

  @override
  String get projectNameHint => 'اسم المشروع (مثال: مشتريات)';

  @override
  String get projectNameRequired => 'الرجاء إدخال اسم المشروع';

  @override
  String get chooseIcon => 'اختر أيقونة';

  @override
  String get createProjectSubtitle => 'أعطِ مشروعك اسمًا واختر أيقونة مناسبة.';

  @override
  String get editProjectSubtitle => 'قم بتحديث اسم المشروع أو أيقونته.';

  @override
  String get createProjectButton => 'إنشاء المشروع';

  @override
  String get saveChanges => 'حفظ التغييرات';

  @override
  String get projectCreatedSuccess => 'تم إنشاء المشروع بنجاح!';

  @override
  String get projectUpdatedSuccess => 'تم تحديث المشروع بنجاح';

  @override
  String tasksCount(int completed, int total) {
    return '$completed/$total مهمة';
  }

  @override
  String get notStarted => 'لم يبدأ بعد';

  @override
  String get deleteProjectTitle => 'حذف المشروع';

  @override
  String deleteProjectConfirm(String name) {
    return 'هل أنت متأكد من رغبتك في حذف \"$name\"؟\nلا يمكن التراجع عن هذا الإجراء.';
  }

  @override
  String projectDeleted(String name) {
    return 'تم حذف \"$name\"';
  }

  @override
  String get delete => 'حذف';

  @override
  String get edit => 'تعديل';

  @override
  String get inviteCollaborator => 'دعوة عضو';

  @override
  String get inviteLinkCopied => 'تم نسخ رابط الدعوة!';

  @override
  String get filterAll => 'الكل';

  @override
  String get filterMyTasks => 'مهامي';

  @override
  String get filterPending => 'قيد الانتظار';

  @override
  String get filterDone => 'منجزة';

  @override
  String get noTasksFound => 'لا توجد مهام';

  @override
  String get addNewTask => 'إضافة مهمة جديدة';

  @override
  String get whatNeedsToBeDone => 'ما الذي يجب إنجازه؟';

  @override
  String get taskTitleRequired => 'الرجاء إدخال عنوان المهمة';

  @override
  String get assignTo => 'إسناد إلى';

  @override
  String get assignedMember => 'العضو المسند إليه';

  @override
  String get member => 'عضو';

  @override
  String get setAlertTime => 'تحديد وقت التنبيه';

  @override
  String alertLabel(String date, String time) {
    return 'تنبيه: $date · $time';
  }

  @override
  String get addTask => 'إضافة المهمة';

  @override
  String taskDeleted(String title) {
    return 'تم حذف \"$title\"';
  }

  @override
  String get editTask => 'تعديل المهمة';

  @override
  String get enterNewTaskTitle => 'أدخل عنوان المهمة الجديد';

  @override
  String get save => 'حفظ';

  @override
  String get taskUpdatedSuccess => 'تم تحديث المهمة بنجاح';

  @override
  String get profileImageUpdatedSuccess => 'تم تحديث الصورة الشخصية بنجاح!';

  @override
  String get justNow => 'الآن';

  @override
  String minutesAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count دقيقة',
      few: 'منذ $count دقائق',
      two: 'منذ دقيقتين',
      one: 'منذ دقيقة',
    );
    return '$_temp0';
  }

  @override
  String hoursAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count ساعة',
      few: 'منذ $count ساعات',
      two: 'منذ ساعتين',
      one: 'منذ ساعة',
    );
    return '$_temp0';
  }

  @override
  String get yesterday => 'أمس';

  @override
  String daysAgo(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 'منذ $count يومًا',
      few: 'منذ $count أيام',
      two: 'منذ يومين',
      one: 'منذ يوم',
    );
    return '$_temp0';
  }
}
