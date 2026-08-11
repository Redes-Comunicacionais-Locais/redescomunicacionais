import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PopUps {
  PopUps._();

  static void snackbar({
    required String texto,
    required Color cor,
  }) {
    // Remove qualquer SnackBar do Flutter que esteja visível.
    final context = Get.context;

    if (context != null) {
      final messenger = ScaffoldMessenger.maybeOf(context);

      if (messenger != null) {
        messenger.clearSnackBars();

        messenger.showSnackBar(
          SnackBar(
            content: Text(texto),
            backgroundColor: cor,
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 3),
          ),
        );

        return;
      }
    }

    // Remove qualquer GetSnackBar antigo antes de mostrar outro.
    Get.closeAllSnackbars();

    Get.showSnackbar(
      GetSnackBar(
        messageText: Text(
          texto,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: cor,
        margin: const EdgeInsets.all(12),
        borderRadius: 8,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  /// Use quando trocar o tema.
  /// Remove tanto SnackBar do Flutter quanto GetSnackBar.
  static void clear() {
    // Flutter SnackBar
    final context = Get.context;

    if (context != null) {
      final messenger = ScaffoldMessenger.maybeOf(context);

      if (messenger != null) {
        messenger.clearSnackBars();
      }
    }

    // GetX SnackBar
    Get.closeAllSnackbars();
  }
}