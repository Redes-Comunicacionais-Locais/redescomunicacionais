import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:redescomunicacionais/app/controller/home_controller.dart';

class LocationController extends GetxController {
  var city = ''.obs;
  Future<void> requestLocation(BuildContext context) async {
    // Aguarda o fim da construção do widget antes de exibir o diálogo
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.dialog(
        AlertDialog(
          title: Text("Solicitação de Localização"),
          content: Text(
              "Este aplicativo precisa acessar sua localização para fornecer informações relevantes à sua área. Para continuar, selecione 'Confirmar'. Caso não deseje prosseguir, selecione 'Sair'. Para obter mais informações, clique em 'Saiba Mais'."),
          actions: [
            TextButton(
              onPressed: () {
                Get.back(); // Fecha o diálogo sem fazer nada
              },
              child: Text("Sair"),
            ),
            TextButton(
              onPressed: () {
                // Abre o site da política de privacidade
              },
              child: Text("Saiba Mais"),
            ),
            TextButton(
              onPressed: () async {
                Get.back(); // Fecha o diálogo
                await getUserLocation(); // Solicita permissão e obtém localização
              },
              child: Text("Confirmar"),
            ),
          ],
        ),
      );
    });
  }

  Future<void> getUserLocation() async {
    try {
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
        city.value =
            placemarks.first.subAdministrativeArea ?? "Cidade não encontrada";
      }
    } catch (e) {
      print("Erro ao obter localização: $e");
      city.value = "Erro ao obter localização";
    }
  }
}
