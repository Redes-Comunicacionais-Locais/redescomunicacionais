import 'package:get/get.dart';
import 'dart:convert';
import 'dart:io';

class Base64Controller extends GetxController {
    Future<String> encode(File imageFile) async { 
        List<int> imageBytes = await imageFile.readAsBytes();
        String base64Image = base64Encode(imageBytes);
        return base64Image;
    }
    List<int> decode(String base64Image) {
        List<int> imageBytes = base64Decode(base64Image);
        //File('img/imagem.jpg').writeAsBytes(imageBytes);
        return imageBytes;
    }

}
