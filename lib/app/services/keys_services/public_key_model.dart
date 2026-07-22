import 'package:cloud_firestore/cloud_firestore.dart';

class PublicKeyModel {
  String? id;
  String? email;
  String? publicKey;
  List<String>? revokedPublicKeys;
  List<String>? cities;
  DateTime? createdAt;
  DateTime? lastUpdated;

  PublicKeyModel({
    this.id,
    this.email,
    this.publicKey,
    this.revokedPublicKeys,
    this.cities,
    this.createdAt,
    this.lastUpdated,
  });

  factory PublicKeyModel.fromJson(Map<String, dynamic> json) {
    return PublicKeyModel(
      id: json['id'] as String?,
      email: json['email'] as String?,
      publicKey: json['publicKey'] as String?,
      revokedPublicKeys: (json['revokedPublicKeys'] as List<dynamic>?)
          ?.map((e) => e.toString())
          .toList(),
      cities:
          (json['cities'] as List<dynamic>?)?.map((e) => e.toString()).toList(),
      // Converte o Timestamp do Firestore de volta para DateTime
      createdAt: _parseTimestamp(json['createdAt']),
      lastUpdated: _parseTimestamp(json['lastUpdated']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'publicKey': publicKey,
      'revokedPublicKeys': revokedPublicKeys,
      'cities': cities,
      'createdAt': createdAt,
      'lastUpdated': lastUpdated,
    };
  }

  PublicKeyModel copyWith({
    String? id,
    String? email,
    String? publicKey,
    List<String>? revokedPublicKeys,
    List<String>? cities,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return PublicKeyModel(
      id: id ?? this.id,
      email: email ?? this.email,
      publicKey: publicKey ?? this.publicKey,
      revokedPublicKeys: revokedPublicKeys ?? this.revokedPublicKeys,
      cities: cities ?? this.cities,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  static DateTime? _parseTimestamp(dynamic value) {
    if (value == null) return null;

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }
}
