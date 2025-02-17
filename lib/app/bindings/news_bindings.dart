import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';

class NewsBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<NewsController>(() => NewsController());
  }
}
