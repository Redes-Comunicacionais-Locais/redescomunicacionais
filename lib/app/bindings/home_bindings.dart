import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/home_controller.dart';

class HomeBinding implements Bindings {
@override
void dependencies() {
  Get.lazyPut<HomeController>(() => HomeController());
     
  }
}