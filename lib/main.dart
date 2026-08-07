import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:wedo_flutter/core/router/app_router.dart';
import 'package:wedo_flutter/core/service_locator.dart' as di;
import 'package:wedo_flutter/firebase_options.dart';
import 'core/theme/app_colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await di.init();
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => const WeDoApp(),
    ),
  );
}

class WeDoApp extends StatelessWidget {
  const WeDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'WeDo',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,

      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.accent,
        ),
        useMaterial3: true,
      ),
      routerConfig: AppRouter.router,
    );
  }
}
