import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/routes/app_pages.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/services/hive_service.dart';
import 'package:redescomunicacionais/app/utils/theme/app_theme.dart';
import 'package:redescomunicacionais/app/utils/theme/theme_controller.dart';
import 'package:redescomunicacionais/app/utils/translations/app_translations.dart';
import 'package:redescomunicacionais/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await HiveInitializer.initialize();

  Get.put(ThemeController());

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = Get.find<ThemeController>();

    return Obx(
          () => GetMaterialApp(
        title: 'Redes Comunicacionais',
        debugShowCheckedModeBanner: true,
        getPages: AppPages.routes,
        initialRoute: Routes.INITIAL,

        theme: appThemeDataLight,
        darkTheme: appThemeDataClassic,
        themeMode: themeController.themeMode.value,

        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
        ],

        translations: AppTranslation(),
        supportedLocales: AppTranslation.supportedLocales,
        locale: AppTranslation.normalizeLocale(Get.deviceLocale),
        fallbackLocale: AppTranslation.fallback,
      ),
    );
  }
}