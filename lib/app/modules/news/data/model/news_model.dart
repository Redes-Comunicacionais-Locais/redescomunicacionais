import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import 'package:hive/hive.dart';
import 'package:flutter/foundation.dart';
part 'news_model.g.dart';


@HiveType(typeId: 1)
class NewsModel {
  // ==========================================
  // 1. INFORMAÇÕES DO CONTEÚDO (Core Data)
  // ==========================================

  @HiveField(0)
  String id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String? subtitle;

  @HiveField(3)
  List<String> cities;

  @HiveField(4)
  List<String> categories;

  @HiveField(5)
  String body;

  @HiveField(6)
  List<String> urlImages;

  @HiveField(10)
  String type;

  @HiveField(21)
  String? videoUrl;

  // ==========================================
  // 2. STATUS E CONTROLE DE ESTADO
  // ==========================================

  @HiveField(11)
  String status;

  @HiveField(26)
  DateTime lastUpdated;

  @HiveField(31)
  Map<String, dynamic>? publicationTerms;

  // ==========================================
  // 3. CRIAÇÃO E AUTORIA
  // ==========================================

  @HiveField(7)
  String author;

  @HiveField(8)
  String createdBy;

  @HiveField(9)
  DateTime createdAt;

  // ==========================================
  // 4. FLUXO DE VALIDAÇÃO / APROVAÇÃO
  // ==========================================

  @HiveField(12)
  String? validatedBy;

  @HiveField(30)
  String? validatedByName;

  @HiveField(13)
  DateTime? validatedAt;

  @HiveField(19)
  String? validatedObservation;

  // ==========================================
  // 5. FLUXO DE REJEIÇÃO
  // ==========================================

  @HiveField(23)
  String? rejectedBy;

  @HiveField(24)
  DateTime? rejectedAt;

  @HiveField(25)
  String? rejectedObservation;

  // ==========================================
  // 6. HISTÓRICO DE EDIÇÃO E EXCLUSÃO
  // ==========================================

  @HiveField(15)
  DateTime? editedAt;

  @HiveField(16)
  String? excludedBy;

  @HiveField(17)
  DateTime? excludedAt;

  @HiveField(20)
  String? excludedObservation;

  NewsModel({
    String? id,
    required this.title,
    this.subtitle,
    required this.body,
    required this.cities,
    required this.categories,
    required this.urlImages,
    this.videoUrl,
    required this.type,
    required this.status,
    required this.lastUpdated,
    required this.author,
    required this.createdBy,
    required this.createdAt,
    this.validatedBy,
    this.validatedByName,
    this.validatedAt,
    this.validatedObservation,
    this.rejectedBy,
    this.rejectedAt,
    this.rejectedObservation,
    this.editedAt,
    this.excludedBy,
    this.excludedAt,
    this.excludedObservation,
    this.publicationTerms,
  }) : id = id ?? Uuid().v4();

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'body': body,
      'cities': cities,
      'categories': categories,
      'urlImages': urlImages,
      'videoUrl': videoUrl,
      'type': type,
      'status': status,
      'lastUpdated': Timestamp.fromDate(lastUpdated),
      'author': author,
      'createdBy': createdBy,
      'createdAt': Timestamp.fromDate(createdAt),
      'validatedBy': validatedBy,
      'validatedByName': validatedByName,
      'validatedAt': validatedAt != null ? Timestamp.fromDate(validatedAt!) : null,
      'validatedObservation': validatedObservation,
      'rejectedBy': rejectedBy,
      'rejectedAt': rejectedAt != null ? Timestamp.fromDate(rejectedAt!) : null,
      'rejectedObservation': rejectedObservation,
      'editedAt': editedAt != null ? Timestamp.fromDate(editedAt!) : null,
      'excludedBy': excludedBy,
      'excludedAt': excludedAt != null ? Timestamp.fromDate(excludedAt!) : null,
      'excludedObservation': excludedObservation,
      'publicationTerms': publicationTerms,
    };

    const requiredKeys = {
      'id', 'title', 'body', 'cities', 'categories', 'urlImages',
      'type', 'status', 'lastUpdated', 'author', 'createdBy', 'createdAt',
    };

    data.removeWhere((key, value) {
      if (requiredKeys.contains(key)) return false;
      if (value == null) return true;
      if (value is String && value.trim().isEmpty) return true;
      if (value is Iterable && value.isEmpty) return true;
      return false;
    });

    return data;
  }

  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      id: map['id']?.toString() ?? '',
      title: map['title']?.toString() ?? '',
      subtitle: map['subtitle']?.toString(),
      body: map['body']?.toString() ?? '',

      cities: List<String>.from(map['cities'] ?? []),
      categories: List<String>.from(map['categories'] ?? []),
      urlImages: List<String>.from(map['urlImages'] ?? []),

      videoUrl: map['videoUrl']?.toString(),
      type: map['type']?.toString() ?? '',
      status: map['status']?.toString() ?? '',

      lastUpdated: _parseDate(map['lastUpdated']) ?? DateTime.now(),

      author: map['author']?.toString() ?? '',
      createdBy: map['createdBy']?.toString() ?? '',
      createdAt: _parseDate(map['createdAt']) ?? DateTime.now(),

      validatedBy: map['validatedBy']?.toString(),
      validatedByName: map['validatedByName']?.toString(),
      validatedAt: _parseDate(map['validatedAt']),
      validatedObservation: map['validatedObservation']?.toString(),

      rejectedBy: map['rejectedBy']?.toString(),
      rejectedAt: _parseDate(map['rejectedAt']),
      rejectedObservation: map['rejectedObservation']?.toString(),

      editedAt: _parseDate(map['editedAt']),

      excludedBy: map['excludedBy']?.toString(),
      excludedAt: _parseDate(map['excludedAt']),
      excludedObservation: map['excludedObservation']?.toString(),

      publicationTerms: map['publicationTerms'] != null
          ? Map<String, dynamic>.from(map['publicationTerms'])
          : null,
    );
  }

  static DateTime? _parseDate(dynamic value) {
    if (value is Timestamp) {
      return value.toDate();
    }
    if (value is DateTime) {
      return value;
    }
    return null;
  }
}