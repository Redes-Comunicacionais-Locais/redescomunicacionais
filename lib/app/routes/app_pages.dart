
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/bindings/home_bindings.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/ui/device/home_page.dart';
import 'package:redescomunicacionais/app/ui/device/initial_page.dart';
import 'package:redescomunicacionais/app/ui/device/login_page.dart';

class AppPages {
  static final routes = [
    GetPage(name: Routes.INITIAL, page: () => InitialPage(),),
    GetPage(name: Routes.LOGIN, page: () => LoginPage(),),
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding())
  ];
}