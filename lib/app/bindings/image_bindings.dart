import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/image_controller.dart';

class ImageBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ImageController>(() => ImageController());
  }
}
