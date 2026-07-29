import 'package:redescomunicacionais/app/modules/news/data/model/news_model.dart';

class NewsPackageModel {
  final NewsModel news;
  final String signature;
  final String authorEmail;

  NewsPackageModel({
    required this.news,
    required this.signature,
    required this.authorEmail,
  });

}