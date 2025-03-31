import 'dart:convert';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class ImageController extends GetxController {
  final RxnString _base64String = RxnString();
  final RxString _message = "".obs;

  String get message => _message.value;
  String? get base64String => _base64String.value;

  Future<void> pickImage() async {
    const int maxSizeBytes = 500000; // 500KB
    final ImagePicker picker = ImagePicker();
    final XFile? imageFile = await picker.pickImage(source: ImageSource.gallery);

    if (imageFile == null) {
      _message.value = "Nenhuma imagem selecionada.";
      return;
    }

    _base64String.value = null;
    _message.value = "Processando sua imagem... Isso pode levar alguns segundos.";

    if (!imageFile.path.toLowerCase().endsWith('.jpg') && 
        !imageFile.path.toLowerCase().endsWith('.jpeg')) {
      _message.value = "A imagem deve ser no formato JPG ou JPEG.";
      return;
    }

    Uint8List imageBytes = await imageFile.readAsBytes();
    if (imageBytes.lengthInBytes <= maxSizeBytes) {
      _base64String.value = base64Encode(imageBytes);
      _message.value = "Imagem selecionada com sucesso!";
      return;
    }

    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      _message.value = "Erro ao processar a imagem.";
      return;
    }

    Uint8List compressedImage = Uint8List.fromList(img.encodeJpg(image, quality: 10));
    
    if (compressedImage.lengthInBytes > maxSizeBytes) {
      _message.value = "A imagem ainda é muito grande!";
    } else {
      _base64String.value = base64Encode(compressedImage);
      _message.value = "A imagem ultrapassou o limite de 500KB e foi comprimida. Esse processo pode resultar em perda de qualidade na imagem.";
    }
  }
}