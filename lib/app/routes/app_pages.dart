import 'package:get/get.dart';
import 'package:redescomunicacionais/app/bindings/home_bindings.dart';
import 'package:redescomunicacionais/app/bindings/image_bindings.dart';
import 'package:redescomunicacionais/app/bindings/login_bindings.dart';
import 'package:redescomunicacionais/app/bindings/news_bindings.dart';
import 'package:redescomunicacionais/app/bindings/user_bindings.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/ui/device/forms/create_news_form.dart';
import 'package:redescomunicacionais/app/ui/device/pages/home_page.dart';
import 'package:redescomunicacionais/app/ui/device/pages/initial_page.dart';
import 'package:redescomunicacionais/app/ui/device/pages/login_page.dart';
import 'package:redescomunicacionais/app/ui/theme/news_widget.dart';
import 'package:redescomunicacionais/app/ui/device/pages/news_page.dart';
import 'package:redescomunicacionais/app/web_view/webview_page.dart';

class AppPages {
  static final routes = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const InitialPage(),
    ),
    GetPage(name: Routes.LOGIN, page: () => const LoginPage(), binding: LoginBinding()),
    
    GetPage(name: Routes.HOME, page: () => HomePage(), bindings: [HomeBinding(), UserBinding()]),

    GetPage(
      name: Routes.NEWS,
      page: () => NewsWidget(),
      binding: NewsBinding(),
    ),
    GetPage(
      name: Routes.NEWS_PAGE,
      page: () => const NewsPage(),
    ),
    GetPage(
        name: Routes.CREATE_NEWS,
        page: () => const CreateNewsPage(),
        bindings: [NewsBinding(), HomeBinding(), ImageBinding()]),
    GetPage(name: Routes.WEB_VIEW, page: () => const WebViewPage()),
  ];
}
