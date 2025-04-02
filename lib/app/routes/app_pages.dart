import 'package:get/get.dart';
import 'package:redescomunicacionais/app/bindings/home_bindings.dart';
import 'package:redescomunicacionais/app/bindings/image_bindings.dart';
import 'package:redescomunicacionais/app/bindings/login_bindings.dart';
import 'package:redescomunicacionais/app/bindings/news_bindings.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/ui/device/forms/create_news_form.dart';
import 'package:redescomunicacionais/app/ui/device/pages/home_page.dart';
import 'package:redescomunicacionais/app/ui/device/pages/initial_page.dart';
import 'package:redescomunicacionais/app/ui/device/pages/login_page.dart';
import 'package:redescomunicacionais/app/data/components/news.dart';
import 'package:redescomunicacionais/app/ui/device/pages/news_page.dart';
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
      binding: NewsBinding(),
    ),
    GetPage(
      name: Routes.NEWS_PAGE,
      page: () => NewsPage(),
    ),
    GetPage(
        name: Routes.CREATE_NEWS,
        page: () => CreateNewsPage(),
        bindings: [NewsBinding(), HomeBinding(), ImageBinding()]),
    GetPage(name: Routes.WEB_VIEW, page: () => WebViewPage()),
  ];
}
