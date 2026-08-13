import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:redescomunicacionais/app/modules/news/data/model/news_model.dart';

part 'news_package_model.g.dart';

@HiveType(typeId: 2)
class NewsPackageModel {
  @HiveField(0)
  final NewsModel? news;

  @HiveField(1)
  final String? signature;

  @HiveField(2)
  final String? email;

  @HiveField(3)
  final DateTime? lastUpdated;

  @HiveField(4)
  final bool? isUploaded;

  @HiveField(5)
  final String? id;

  NewsPackageModel({
    required this.news,
    required this.signature,
    required this.email,
    required this.lastUpdated,
    required this.isUploaded,
    required this.id,
  });

  factory NewsPackageModel.fromJson(Map<String, dynamic> json) {
    

    return NewsPackageModel(
      // Assumindo que seu NewsModel possui um método fromJson
      news: NewsModel.fromMap(Map<String, dynamic>.from(json['news'] ?? {})),
      signature: json['signature'] ?? '',
      email: json['email'] ?? '',
      lastUpdated: _parseDate(json['lastUpdated']),
      isUploaded: json['isUploaded'] ?? false,
      id: json['id'], // Mantém o ID gerado e salvo anteriormente
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'news': news?.toMap(), 
      'signature': signature,
      'email': email,
      'lastUpdated': lastUpdated, 
      'isUploaded': isUploaded,
      'id': id,
    };
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