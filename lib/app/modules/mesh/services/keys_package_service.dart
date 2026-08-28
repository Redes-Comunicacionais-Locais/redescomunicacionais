import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:pointycastle/asymmetric/api.dart';
import 'package:redescomunicacionais/app/modules/mesh/services/key_storage_service.dart';
import 'package:redescomunicacionais/app/modules/mesh/services/keys_service.dart';
import 'package:redescomunicacionais/app/modules/mesh/model/public_key_model.dart';
import '../model/keys_package_model.dart';

class KeysPackageService {
  final KeyStorageService _keyStorageService = KeyStorageService();

  // cria o pacote de chaves públicas pronto a ser enviado
  Future<PublicKeyPackage?> createPackage(
      List<PublicKeyModel> keysList,
      String userEmail
      ) async {
    try {
      // recupera a chave privada local em string
      final privateKeyStr = await _keyStorageService.getPrivateKey();
      if (privateKeyStr == null) {
        throw Exception("Private key not found on device");
      }

      // transforma chave de volta em RSA para a assinatura
      final RSAPrivateKey privateKey = KeysServices.importPrivateKey(privateKeyStr);

      // timestamp de agora
      final timestamp = DateTime.now();

      // monta map do conteúdo que será assinado
      // mesmo do pacote de chaves mas sem assinatura
      final Map<String, dynamic> mapToSign = {
        'publicKeys': keysList.map((k) => k.toJson()).toList(),
        'senderEmail': userEmail,
        'timestamp': timestamp.toIso8601String(),
      };

      // transforma map em string e cria a assinatura com a chave privada
      final String signature = KeysServices.toSign(jsonEncode(mapToSign), privateKey);

      // cria e retorna o pacote
      return PublicKeyPackage(
        publicKeys: keysList,
        senderEmail: userEmail,
        timestamp: timestamp,
        signature: signature,
      );
    } catch (e) {
      debugPrint("Error creating public keys package: $e");
      return null;
    }
  }

  // verifica se um pacote recebido é válido
  bool verifyPackage(PublicKeyPackage package, String senderPublicKeyStr) {
    try {
      // transforma chave pública de volta em RSA para a verificação
      final RSAPublicKey publicKey = KeysServices.importPublicKey(senderPublicKeyStr);

      // reconstrói o mesmo map que o remetente assinou
      final Map<String, dynamic> mapToCheck = {
        'publicKeys': package.publicKeys.map((k) => k.toJson()).toList(),
        'senderEmail': package.senderEmail,
        'timestamp': package.timestamp.toIso8601String(),
      };

      // transforma o map em string
      // verifica a autenticidade da assinatura
      return KeysServices.toCheck(jsonEncode(mapToCheck), package.signature, publicKey);
    } catch (e) {
      debugPrint("Error verifying public keys package: $e");
      return false;
    }
  }
}
