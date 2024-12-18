import 'package:get/get.dart';
import 'package:redescomunicacionais/app/data/model/user_model.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
class HomeController extends GetxController {
  final UserModel user = Get.arguments;


   void goDoc(){
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki',
          'title': 'RCL'});
  }
}