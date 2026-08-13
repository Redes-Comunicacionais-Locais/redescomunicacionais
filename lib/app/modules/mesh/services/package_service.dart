import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../model/news_package_model.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:redescomunicacionais/app/modules/news/data/model/news_model.dart';
import 'package:redescomunicacionais/app/modules/mesh/services/key_storage_service.dart';
import 'package:redescomunicacionais/app/modules/mesh/services/keys_service.dart';

class OfflinePackageService {
  final KeyStorageService _keyStorageService = KeyStorageService();

  // cria o pacote a ser enviado
  Future<NewsPackageModel?> createPackage(NewsModel news) async {
    try {
      // Recupera a chave privada do armazenamento seguro
      final privateKeyStr = await _keyStorageService.getPrivateKey();
      if (privateKeyStr == null) {
        throw Exception("Private key not found on device");
      }

      // Transforma a chave privada salva em string em RSAPrivateKey
      final RSAPrivateKey privateKey = KeysServices.importPrivateKey(privateKeyStr);

      // Converte a notícia em uma string para ser assinada
      final String newsString = jsonEncode(news.toMap());

      // Assina a string da notícia com a chave privada
      final String signature = KeysServices.toSign(newsString, privateKey);

      final package = NewsPackageModel(
        news: news,
        signature: signature,
        email: news.author, 
        lastUpdated: DateTime.now(),
        isUploaded: false,
        id: news.id,
      );

      // Salva o pacote no Hive local
      await _saveNewsPackageInHive(package);

      // Cria o pacote
      return package;
    } catch (e) {
      debugPrint("Error creating news package: $e");
      return null;
    }
  }

  Future<void> _saveNewsPackageInHive(NewsPackageModel package) async {
     try {
      // Verifiqua se a box já está aberta para evitar lentidão
      var box = Hive.isBoxOpen('news_packages')
          ? Hive.box<NewsPackageModel>('news_packages')
          : await Hive.openBox<NewsPackageModel>('news_packages');

      //  salva ou atualiza se o ID já existir
      await box.put(package.id, package);
    } catch (e) {
      throw Exception("Erro ao salvar no Hive local: $e");
    }
  }

  // valida um pacote recebido
  bool verifyPackage(NewsPackageModel package, String publicKeyStr) {
    try {
      final RSAPublicKey publicKey = KeysServices.importPublicKey(publicKeyStr);

      // Transforma a noticia recebida na mesma string de quando foi assinada
      final String newsString = jsonEncode(package.news?.toMap());

      // Verifica a assinatura
      return KeysServices.toCheck(newsString, package.signature ?? "", publicKey);
    } catch (e) {
      debugPrint("Error verifying news package: $e");
      return false;
    }
  }
}