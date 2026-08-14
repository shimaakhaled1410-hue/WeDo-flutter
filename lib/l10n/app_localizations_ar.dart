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
  String get loginSubtitle => 'سجّل الدخول عشان تكمل مهامك';

  @override
  String get createAccount => 'إنشاء حساب';

  @override
  String get registerSubtitle => 'انضم لـ WeDo عشان تتعاون في المهام';

  @override
  String get email => 'البريد الإلكتروني';

  @override
  String get password => 'كلمة المرور';

  @override
  String get fullName => 'الاسم بالكامل';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get dontHaveAccount => 'معندكش حساب؟ ';

  @override
  String get alreadyHaveAccount => 'عندك حساب بالفعل؟ ';

  @override
  String get myLists => 'قوائمي';

  @override
  String activeProjectsCount(int count) {
    return 'عندك $count مشروع نشط';
  }

  @override
  String get noProjectsYet => 'لسه معملتش أي مشروع';

  @override
  String get tapAddToCreate => 'دوسي على \"إضافة\" تحت عشان تعملي أول مشروع.';

  @override
  String get notifications => 'الإشعارات';

  @override
  String unreadNotifications(int count) {
    return '$count إشعار غير مقروء';
  }

  @override
  String get allCaughtUp => 'مفيش حاجة جديدة';

  @override
  String get noNotificationsYet => 'لسه مفيش إشعارات';

  @override
  String get notificationsEmptyHint => 'لما يجيلك حاجة جديدة، هتلاقيها هنا.';

  @override
  String get somethingWentWrong => 'حصلت مشكلة';

  @override
  String get tryAgain => 'حاول تاني';

  @override
  String get myProfile => 'بروفايلي';

  @override
  String get projects => 'المشاريع';

  @override
  String get doneTasks => 'المهام المخلصة';

  @override
  String get settings => 'الإعدادات';

  @override
  String get language => 'اللغة';

  @override
  String get themeMode => 'وضع الثيم';

  @override
  String get signOut => 'تسجيل الخروج';

  @override
  String get signOutConfirm => 'متأكدة إنك عايزة تسجلي خروج\nمن حسابك؟';

  @override
  String get cancel => 'إلغاء';

  @override
  String get themeModeLight => 'فاتح';

  @override
  String get themeModeDark => 'غامق';

  @override
  String get themeModeSystem => 'حسب النظام';

  @override
  String get languageEnglish => 'الإنجليزية';

  @override
  String get languageArabic => 'العربية';
}
