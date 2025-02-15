import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:redescomunicacionais/app/data/model/news_model.dart';

class NewsRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "news";

  // Adicionar notícias
  Future<void> adicionarNews(NewsModel news) async {
    try {
      await _firestore.collection(collectionPath).add(news.toMap());
    } catch (e) {
      throw Exception("Erro ao adicionar notícias: $e");
    }
  }

  // Buscar todas as notícias
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
