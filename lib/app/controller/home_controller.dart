import 'package:get/get.dart';
import 'package:redescomunicacionais/app/data/model/user_model.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
class HomeController extends GetxController {
  final UserModel user = Get.arguments;


   void goInfo(){
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki',
          'title': 'RCL'});
  }

  void goInfoTeam(){
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Equipe',
          'title': 'RCL'});
  }
   void goProjectStructure(){
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Estrutura-do-Projeto',
          'title': 'RCL'});
  }

   void goUserGuide(){
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Guia-do-Usu%C3%A1rio',
          'title': 'RCL'});
  }

   void goInstallationConfig(){
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Instala%C3%A7%C3%A3o-e-Configura%C3%A7%C3%A3o',
          'title': 'RCL'});
  }

   void goFAQ(){
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Perguntas-Frequentes',
          'title': 'RCL'});
  }
}