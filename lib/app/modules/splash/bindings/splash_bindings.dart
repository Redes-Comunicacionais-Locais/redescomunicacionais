import 'package:get/get.dart';
import 'package:redescomunicacionais/app/modules/splash/controller/splash_controller.dart';

class SplashBindings implements Bindings {
  @override
  void dependencies() {
    Get.put<SplashController>(
      SplashController(),
    );
  }
}
