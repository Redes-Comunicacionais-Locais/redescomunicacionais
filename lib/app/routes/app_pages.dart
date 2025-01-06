import 'package:get/get.dart';
import 'package:redescomunicacionais/app/bindings/home_bindings.dart';
import 'package:redescomunicacionais/app/bindings/login_bindings.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/ui/device/create_news_page.dart';
import 'package:redescomunicacionais/app/ui/device/home_page.dart';
import 'package:redescomunicacionais/app/ui/device/initial_page.dart';
import 'package:redescomunicacionais/app/ui/device/login_page.dart';
import 'package:redescomunicacionais/app/data/components/news.dart';
import 'package:redescomunicacionais/app/ui/device/news_page.dart';
import 'package:redescomunicacionais/app/web_view/webview_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => InitialPage(),
    ),
    GetPage(
        name: Routes.LOGIN, page: () => LoginPage(), binding: LoginBinding()),
    GetPage(name: Routes.HOME, page: () => HomePage(), binding: HomeBinding()),
    GetPage(
      name: Routes.NEWS,
      page: () => News(),
    ),
    GetPage(
      name: Routes.NEWS_PAGE,
      page: () => NewsPage(),
    ),
    GetPage(
      name: Routes.CREATE_NEWS,
      page: () => CreateNewsPage(),
    ),
    GetPage(name: Routes.WEB_VIEW, page: () => WebViewPage()),
  ];
}
