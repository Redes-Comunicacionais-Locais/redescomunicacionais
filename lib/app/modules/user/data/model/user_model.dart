import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String? name;

  @HiveField(2)
  String email;

  @HiveField(3)
  String? urlImage;

  @HiveField(4)
  String role;

  @HiveField(5)
  DateTime createdAt;

  @HiveField(6)
  DateTime? roleUpdatedAt;

  @HiveField(7)
  String? roleUpdatedBy;

  @HiveField(8)
  String status;

  @HiveField(9)
  DateTime? statusUpdatedAt;

  @HiveField(10)
  String? statusUpdatedBy;

  @HiveField(11)
  String? statusObservation;

  @HiveField(12)
  DateTime? lastUpdated;

  UserModel({
    required this.id,
    this.name,
    required this.email,
    this.urlImage,
    required this.role,
    required this.createdAt,
    this.roleUpdatedAt,
    this.roleUpdatedBy,
    required this.status,
    this.statusUpdatedAt,
    this.statusUpdatedBy,
    this.statusObservation,
    this.lastUpdated,
  });

  // Factory para criar um usuário vazio com campos required
  factory UserModel.empty() {
    return UserModel(
      id: '',
      email: '',
      role: 'user',
      createdAt: DateTime.now(),
      status: 'anonymous',
      lastUpdated: DateTime.now(),
    );
  }

  static DateTime _readDateTime(dynamic value, {required DateTime fallback}) {
    if (value == null) {
      return fallback;
    }

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  // toJson
  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    void addIfNotEmpty(String key, dynamic value) {
      if (value == null) return;
      if (value is String && value.trim().isEmpty) return;
      if (value is List && value.isEmpty) return;
      data[key] = value;
    }

    addIfNotEmpty('id', id);
    addIfNotEmpty('name', name);
    addIfNotEmpty('email', email);
    addIfNotEmpty('urlImage', urlImage);
    addIfNotEmpty('role', role);
    data['createdAt'] = Timestamp.fromDate(createdAt);
    addIfNotEmpty(
      'roleUpdatedAt',
      roleUpdatedAt != null ? Timestamp.fromDate(roleUpdatedAt!) : null,
    );
    addIfNotEmpty('roleUpdatedBy', roleUpdatedBy);
    addIfNotEmpty('status', status);
    addIfNotEmpty(
      'statusUpdatedAt',
      statusUpdatedAt != null ? Timestamp.fromDate(statusUpdatedAt!) : null,
    );
    addIfNotEmpty('statusUpdatedBy', statusUpdatedBy);
    addIfNotEmpty('statusObservation', statusObservation);
    addIfNotEmpty(
      'lastUpdated',
      lastUpdated != null ? Timestamp.fromDate(lastUpdated!) : null,
    );

    return data;
  }

  // fromJson
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      urlImage: json['urlImage'],
      role: json['role'] ?? 'user',
      createdAt: _readDateTime(
        json['createdAt'],
        fallback: DateTime.now(),
      ),
      roleUpdatedAt: json['roleUpdatedAt'] != null
          ? _readDateTime(
              json['roleUpdatedAt'],
              fallback: DateTime.now(),
            )
          : null,
      roleUpdatedBy: json['roleUpdatedBy'],
      status: json['status'] ?? 'active',
      statusUpdatedAt: json['statusUpdatedAt'] != null
          ? _readDateTime(
              json['statusUpdatedAt'],
              fallback: DateTime.now(),
            )
          : null,
      statusUpdatedBy: json['statusUpdatedBy'],
      statusObservation: json['statusObservation'],
      lastUpdated: json['lastUpdated'] != null
          ? _readDateTime(
              json['lastUpdated'],
              fallback: DateTime.now(),
            )
          : null,
    );
  }
}
