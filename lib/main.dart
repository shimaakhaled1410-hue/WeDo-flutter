import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wedo_flutter/core/router/app_router.dart';
import 'package:wedo_flutter/core/services/notification_service.dart';
import 'package:wedo_flutter/core/services/service_locator.dart' as di;
import 'package:wedo_flutter/core/theme/app_theme.dart';
import 'package:wedo_flutter/firebase_options.dart';
import 'package:wedo_flutter/l10n/app_localizations.dart';
import 'package:wedo_flutter/presentation/manager/locale/locale_cubit.dart';
import 'package:wedo_flutter/presentation/manager/locale/locale_state.dart';
import 'package:wedo_flutter/presentation/manager/locale/locale_x.dart';
import 'package:wedo_flutter/presentation/manager/theme/theme_cubit.dart';
import 'package:wedo_flutter/presentation/manager/theme/theme_mode_x.dart';
import 'package:wedo_flutter/presentation/manager/theme/theme_state.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

const bool isDevicePreviewEnabled = kIsWeb && !kReleaseMode;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  if (!kIsWeb) {
    await NotificationService().initNotification();
  }

  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => di.sl<ThemeCubit>()),
          BlocProvider(create: (_) => di.sl<LocaleCubit>()),
        ],
        child: const WeDoApp(),
      ),
    ),
  );
}

class WeDoApp extends StatelessWidget {
  const WeDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return BlocBuilder<LocaleCubit, LocaleState>(
          builder: (context, localeState) {
            return MaterialApp.router(
              debugShowCheckedModeBanner: false,
              title: 'WeDo',
              locale: localeState.locale.toFlutterLocale,
              builder: isDevicePreviewEnabled ? DevicePreview.appBuilder : null,
              // Localization setup — RTL is handled automatically by
              // Flutter when locale is Arabic, no manual config needed.
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,

              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeState.mode.toFlutterThemeMode,
              routerConfig: AppRouter.router,
            );
          },
        );
      },
    );
  }
}
