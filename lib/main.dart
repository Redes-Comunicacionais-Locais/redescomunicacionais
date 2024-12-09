import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:redescomunicacionais/app/routes/app_pages.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/ui/theme/app_theme.dart';
import 'package:redescomunicacionais/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    GetMaterialApp(
      title: 'Redes Comunicacionais',
      debugShowCheckedModeBanner: false, //Etiqueta de Debug
      getPages: AppPages.routes,
      initialRoute: Routes.INITIAL,
      theme: appThemeData,
    ),
  );
}
