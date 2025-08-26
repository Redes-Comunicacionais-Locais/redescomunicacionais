import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';

class LocationController extends GetxController
    with GetTickerProviderStateMixin {
  var city = ''.obs;
  bool dialogShow = true; // Variável para controlar a exibição do diálogo
  late AnimationController _animationController;

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void onClose() {
    _animationController.dispose();
    super.onClose();
  }

  Future<bool> requestLocation() async {
    final completer = Completer<bool>();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (dialogShow) {
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
                  Get.back(); // Fecha o diálogo primeiro
                  _showLocationLoadingDialog(); // Mostra a tela de carregamento
                  await getUserLocation(); // Solicita permissão e obtém localização
                  Get.back(); // Fecha a tela de carregamento
                  completer.complete(true); // Usuário confirmou a solicitação
                },
                child: Text("Confirmar"),
              ),
            ],
          ),
        );
      } else {
        completer.complete(true);
        await getUserLocation();
      }
    });
    return completer.future;
  }

  Future<void> getUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        city.value = "Permissão negada";
        dialogShow = true;
        return;
      }
      dialogShow = false;
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

  void _showLocationLoadingDialog() {
    Get.dialog(
      AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Imagem piscando
            AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Opacity(
                  opacity: _animationController.value,
                  child: Image.asset(
                    'assets/icons/RCLIcon.png',
                    height: 80,
                    width: 80,
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            Text(
              "Aguarde enquanto verificamos sua localização",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 20),
            CircularProgressIndicator(),
          ],
        ),
      ),
      barrierDismissible:
          false, // Impede que o usuário feche o diálogo clicando fora
    );
  }
}
