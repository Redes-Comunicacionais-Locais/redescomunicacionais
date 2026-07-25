import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageBase64Service extends GetxController {
  final RxList<String> _base64Images = <String>[].obs;

  String? get base64String =>
      _base64Images.isEmpty ? null : _base64Images.first;

  List<String> get base64Images => _base64Images;
  final RxString _message = "".obs;

  String get message => _message.value;
  void removeImage(int index) {
    _base64Images.removeAt(index);
  }

  void clearImages() {
    _base64Images.clear();
  }

  Future<void> pickImage() async {
    // Limite de imagens
    if (_base64Images.length >= 3) {
      _message.value = 'Você pode adicionar no máximo 3 imagens.';
      return;
    }

    const int maxSizeBytes = 150000;
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile =
    await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      _message.value = 'no_image_selected'.tr;
      return;
    }

    _message.value = 'processing_image_message'.tr;


    // Redimensionamento da imagem
    final CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: imageFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      maxWidth: 1920,
      maxHeight: 1080,
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'crop_image_title'.tr,
          toolbarColor: Colors.black,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false,
          hideBottomControls: false,
        ),
        IOSUiSettings(
          title: 'crop_image_title'.tr,
          aspectRatioLockEnabled: false,
          resetAspectRatioEnabled: true,
        ),
      ],
    );

    if (croppedFile == null) {
      _message.value = 'no_image_selected'.tr;
      return;
    }

    // Compressão para WebP
    Uint8List? webpBytes = await FlutterImageCompress.compressWithFile(
      croppedFile.path,
      format: CompressFormat.webp,
      quality: 90,
    );

    if (webpBytes == null) {
      _message.value = 'error_processing_image'.tr;
      return;
    }

    int currentQuality = 90;

    // Loop de compressão gradual
    while (webpBytes!.lengthInBytes > maxSizeBytes && currentQuality > 10) {
      currentQuality -= 10; // Diminui 10% a cada tentativa

      webpBytes = await FlutterImageCompress.compressWithList(
        webpBytes,
        format: CompressFormat.webp,
        quality: currentQuality,
      );
    }

// Verificação final após o loop
    if (webpBytes.lengthInBytes > maxSizeBytes) {
      _message.value = 'image_too_large'.tr;
    } else {
      _base64Images.add(base64Encode(webpBytes));
      var tamanho = (_base64Images.last.length) / 1024;
      debugPrint(
          'Tamanho original: ${File(imageFile.path).lengthSync() / 1024} KB');
      debugPrint(
          'Tamanho após crop: ${File(croppedFile.path).lengthSync() / 1024} KB');
      debugPrint('Tamanho em WebP: ${webpBytes.lengthInBytes / 1024} KB');
      debugPrint('Tamanho em base 64: $tamanho KB');
      _message.value = 'image_selected_success'.tr;
    }
  }
}
