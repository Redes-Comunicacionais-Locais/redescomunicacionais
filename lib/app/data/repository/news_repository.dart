import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';
import 'package:redescomunicacionais/app/data/model/news_model.dart';

class NewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "news";

  // Add news to Firebase
  Future<void> adicionarNews(NewsModel news) async {
    try {
      await _firestore.collection(collectionPath).add(news.toMap());
    } catch (e) {
      throw Exception("Erro ao adicionar notícias: $e");
    }
  }

  // Save news to Hive (local storage)
  Future<void> saveNewsToHive(NewsModel news) async {
    try {
      var box = await Hive.openBox<NewsModel>('news');
      await box.put(news.id, news);
    } catch (e) {
      throw Exception("Erro ao salvar notícia no Hive: $e");
    }
  }

  // Get news from Hive (local storage)
  Future<List<NewsModel>> getNewsFromHive() async {
    try {
      var box = await Hive.openBox<NewsModel>('news');
      return box.values.toList();
    } catch (e) {
      throw Exception("Erro ao buscar notícias do Hive: $e");
    }
  }

  // Get all news from Firebase
  Future<List<NewsModel>> buscarNews() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection(collectionPath).get();

      return querySnapshot.docs
          .map((doc) =>
              NewsModel.fromMap(doc.id, doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw Exception("Erro ao buscar notícias: $e");
    }
  }
}
