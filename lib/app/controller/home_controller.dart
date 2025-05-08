import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:redescomunicacionais/app/data/model/user_model.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';

class HomeController extends GetxController {
  final UserModel user = Get.arguments;

  var city = "Carregando...".obs;

  @override
  void onInit() {
    super.onInit();
    getUserLocation();
  }

  Future<void> getUserLocation() async {
    try {
      // Solicita permissão de localização
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        city.value = "Permissão negada";
        return;
      }

      // Obtém a posição atual
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Converte coordenadas em cidade
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        city.value = placemarks.first.subAdministrativeArea ?? "Cidade não encontrada";
      }
    } catch (e) {
      print("Erro ao obter localização: $e");
      city.value = "Erro ao obter localização";
    }
  }

  void goInfo() {
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {
          'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki',
          'title': 'RCL'
        });
  }

  void goInfoTeam() {
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {
          'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Equipe',
          'title': 'RCL'
        });
  }

  void goProjectStructure() {
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {
          'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Estrutura-do-Projeto',
          'title': 'RCL'
        });
  }

  void goUserGuide() {
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {
          'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Guia-do-Usu%C3%A1rio',
          'title': 'RCL'
        });
  }

  void goInstallationConfig() {
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {
          'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Instala%C3%A7%C3%A3o-e-Configura%C3%A7%C3%A3o',
          'title': 'RCL'
        });
  }

  void goFAQ() {
    Get.toNamed(Routes.WEB_VIEW,
        arguments: {
          'url': 'https://github.com/Redes-Comunicacionais-Locais/redescomunicacionais/wiki/Perguntas-Frequentes',
          'title': 'RCL'
        });
  }
}