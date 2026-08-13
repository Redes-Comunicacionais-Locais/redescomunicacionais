import 'package:redescomunicacionais/app/modules/mesh/model/public_key_model.dart';

class PublicKeyPackage {
  final List<PublicKeyModel> publicKeys;
  final String senderEmail;
  final DateTime timestamp;
  final String signature;

  PublicKeyPackage({
    required this.publicKeys,
    required this.senderEmail,
    required this.timestamp,
    required this.signature,
  });
}