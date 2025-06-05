import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController {
  var city = ''.obs;

  Future<bool> requestLocation() async {
    final completer = Completer<bool>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Get.dialog(
        AlertDialog(
          title: Text("Solicitação de Localização"),
          content: Text(
              "Este aplicativo precisa acessar sua localização para fornecer informações relevantes à sua área. Para continuar, selecione 'Confirmar'. Caso não deseje prosseguir, selecione 'Sair'."),
          actions: [
            TextButton(
              onPressed: () {
                completer.complete(false); // Usuário escolheu "Sair"
                Get.back();
              },
              child: Text("Sair"),
            ),
            TextButton(
              onPressed: () async {
                await getUserLocation(); // Solicita permissão e obtém localização
                completer.complete(true); // Usuário confirmou a solicitação
                Get.back();
              },
              child: Text("Confirmar"),
            ),
          ],
        ),
      );
    });
    return completer.future;
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
