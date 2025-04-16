import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/user_controller.dart';

class UserBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserController>(() => UserController());
  }
}
