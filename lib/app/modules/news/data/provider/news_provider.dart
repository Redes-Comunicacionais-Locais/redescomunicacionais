import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:redescomunicacionais/app/modules/news/data/model/news_model.dart';
import 'package:redescomunicacionais/app/modules/news/utils/news_states.dart';
import 'package:redescomunicacionais/app/modules/user/data/model/user_model.dart';
import 'package:redescomunicacionais/app/modules/user/utils/userRoles.dart';




class NewsProvider {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String collectionPath = "news";

  Future<void> _saveNewsToFirebase(NewsModel news) async {
    try {
      await _firestore.collection(collectionPath).doc(news.id).set(
            news.toMap(),
            SetOptions(merge: true),
          );
    } on FirebaseException catch (e) {
      throw Exception("Erro no Firebase (${e.code}): ${e.message}");
    } catch (e) {
      throw Exception("Erro desconhecido ao salvar: $e");
    }
  }

  Future<QueryDocumentSnapshot<Map<String, dynamic>>?> getPublicNewsPaginated({
  QueryDocumentSnapshot<Map<String, dynamic>>? lastDocument,
}) async {
  try {
    QueryDocumentSnapshot<Map<String, dynamic>>? nextLastDocument;

    Query<Map<String, dynamic>> query = _firestore
        .collection(collectionPath)
        .where('status', whereIn: [NewsStates.publicado])
        .orderBy('createdAt', descending: true)
        .limit(10);

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

    if (snapshot.docs.isNotEmpty) {
      nextLastDocument = snapshot.docs.last;
    }

    List<NewsModel> newsList = snapshot.docs.map((doc) {
      Map<String, dynamic> data = doc.data();
      data['id'] = doc.id;
      return NewsModel.fromMap(data);
    }).toList();

    await saveNewsListToHive(newsList);

    return nextLastDocument;
    
  } catch (e) {
    throw Exception("Erro ao buscar notícias públicas paginadas: $e");
  }
}

 Future<void> getOuthersNews(UserModel user) async {
  try {
    if (user.role != UserRoles.admin && user.role != UserRoles.editor) {
      throw Exception("Acesso negado: Usuário não é admin ou editor.");
    }

    Map<String, QueryDocumentSnapshot<Map<String, dynamic>>> docs = {};

    List<Future<QuerySnapshot<Map<String, dynamic>>>> futures = [
      // Suas próprias privadas (Rascunho, Rejeitado, Deletado)
      _firestore
          .collection(collectionPath)
          .where('status', whereIn: [
            NewsStates.rascunho,
            NewsStates.rejeitado,
            NewsStates.deletado,
          ])
          .where('createdBy', isEqualTo: user.email)
          .get(),

      // Todas as matérias que aguardam análise no sistema
      _firestore
          .collection(collectionPath)
          .where('status', whereIn: [NewsStates.emAnalise]).get(),
    ];

    List<QuerySnapshot<Map<String, dynamic>>> snapshots =
        await Future.wait(futures);

    // Agrupa os resultados removendo duplicatas por ID
    for (var snapshot in snapshots) {
      for (var doc in snapshot.docs) {
        docs[doc.id] = doc;
      }
    }

    // Mapeia o resultado final unificado
    List<NewsModel> othersNewsList = docs.values.map((doc) {
      final data = doc.data();
      data['id'] = doc.id;
      return NewsModel.fromMap(data);
    }).toList();

    await saveNewsListToHive(othersNewsList);
  } catch (e) {
    throw Exception("Erro ao buscar matérias de administração: $e");
  }
}

  Future<void> saveNewsToHive(NewsModel news) async {
    try {
      // Verifiqua se a box já está aberta para evitar lentidão
      var box = Hive.isBoxOpen(collectionPath)
          ? Hive.box<NewsModel>(collectionPath)
          : await Hive.openBox<NewsModel>(collectionPath);

      //  salva ou atualiza se o ID já existir
      await box.put(news.id, news);
    } catch (e) {
      throw Exception("Erro ao salvar no Hive local: $e");
    }
  }

  Future<void> saveNewsListToHive(List<NewsModel> newsList) async {
    if (newsList.isEmpty) return;

    try {
      var box = Hive.isBoxOpen(collectionPath)
          ? Hive.box<NewsModel>(collectionPath)
          : await Hive.openBox<NewsModel>(collectionPath);

      final Map<String, NewsModel> newsMap = {
        for (var news in newsList) news.id: news
      };

      await box.putAll(newsMap);
    } catch (e) {
      throw Exception("Erro ao salvar a lista no Hive local: $e");
    }
  }

  Future<List<NewsModel>> getPublicNewsFromHive() async {
  try {
    final box = Hive.isBoxOpen(collectionPath)
        ? Hive.box<NewsModel>(collectionPath)
        : await Hive.openBox<NewsModel>(collectionPath);

    List<NewsModel> allList = box.values.toList().cast<NewsModel>();

    List<NewsModel> publicList = allList
        .where((news) => news.status == NewsStates.publicado)
        .toList();

    return publicList;
  } catch (e) {
    throw Exception("Erro ao buscar notícias públicas no Hive: $e");
  }
}

Future<List<NewsModel>> getOuthersNewsFromHive() async {
  try {
    final box = Hive.isBoxOpen(collectionPath)
        ? Hive.box<NewsModel>(collectionPath)
        : await Hive.openBox<NewsModel>(collectionPath);

    List<NewsModel> allList = box.values.toList().cast<NewsModel>();

    List<NewsModel> internalList = allList.where((news) {
      return news.status == NewsStates.rascunho ||
             news.status == NewsStates.rejeitado ||
             news.status == NewsStates.deletado ||
             news.status == NewsStates.emAnalise;
    }).toList();

    return internalList;
  } catch (e) {
    throw Exception("Erro ao buscar notícias internas no Hive: $e");
  }
}

  Future<void> _deleteNewsFromHive(String newsId) async {
    try {
      var box = await Hive.openBox<NewsModel>(collectionPath);

      // Verifica se a notícia realmente existe no Hive antes de deletar
      if (box.containsKey(newsId)) {
        await box.delete(newsId);
        debugPrint("Notícia ID $newsId deletada com sucesso do Hive.");
      } else {
        debugPrint("A notícia ID $newsId não foi encontrada no Hive.");
      }
    } catch (e) {
      debugPrint("Erro ao deletar a notícia do Hive: $e");
      throw Exception("Erro ao remover dados locais: $e");
    }
  }

  Future<void> hideNews(String newsId, String status, String userEmail) async {
    DateTime now = DateTime.now();

    try {
      if (Hive.isBoxOpen(collectionPath)) {
        var box = Hive.box<NewsModel>(collectionPath);
        var news = box.get(newsId);
        if (news != null) {
          news.status = status;
          news.excludedAt = now;
          news.excludedBy = userEmail;
          news.lastUpdated = now;
          await box.put(newsId, news);
        }
      }
    } catch (e) {
      debugPrint("Erro crítico ao atualizar Hive local: $e");
      throw Exception("Falha ao ocultar notícia.");
    }
  }

  Future<void> updateNews(
      String newsId, Map<String, dynamic> updatedData) async {
    try {
      final box = Hive.isBoxOpen(collectionPath)
          ? Hive.box<NewsModel>(collectionPath)
          : await Hive.openBox<NewsModel>(collectionPath);

      final existingNews = box.get(newsId);
      if (existingNews == null) {
        throw Exception('Notícia não encontrada no Hive local.');
      }

      final mergedData = existingNews.toMap()..addAll(updatedData);
      mergedData['id'] = newsId;

      final updatedNews = NewsModel.fromMap(mergedData);
      await box.put(newsId, updatedNews);
    } catch (e) {
      throw Exception("Erro ao atualizar notícia no Hive local: $e");
    }
  }

  Future<void> reviewNews({
    required String newsId,
    required bool isApproved,
    required String reason,
    required String validator,
    required String validatorName,
    required String newsType,
  }) async {
    DateTime now = DateTime.now();
    bool isDeleted = newsType == NewsStates.deletado;
    String status = isApproved ? NewsStates.publicado : NewsStates.rejeitado;

    final Map<String, dynamic> updates = {
      'status': isDeleted ? NewsStates.deletado : status,
      'type': newsType,
    };

    try {
      if (Hive.isBoxOpen(collectionPath)) {
        var box = Hive.box<NewsModel>(collectionPath);
        var news = box.get(newsId);

        if (news != null) {
          // Atualizamos o objeto local com as mesmas informações
          news.status = updates['status'];
          news.type = updates['type'];
          news.lastUpdated = now;

          if (isApproved) {
            news.validatedAt = now;
            news.validatedObservation = reason;
            news.validatedBy = validator;
            news.validatedByName = validatorName;
          } else {
            if (isDeleted) {
              news.excludedAt = now;
              news.excludedBy = validator;
              news.excludedObservation = reason;
            } else {
              news.rejectedAt = now;
              news.rejectedBy = validator;
              news.rejectedObservation = reason;
            }
          }
          await box.put(newsId, news);
        }
      }
    } catch (e) {
      debugPrint("Erro ao atualizar revisão no Hive: $e");
      throw Exception("Erro ao atualizar revisão no Hive");
    }
  }

  Future<void> syncNewsHiveAndFirebase(UserModel user) async {
    bool isAdminOrEditor =
        user.role == UserRoles.admin || user.role == UserRoles.editor;

    if (!isAdminOrEditor) {
      debugPrint("Usuário comum: Sincronização em segundo plano pulada.");
      return;
    }

    try {
      List<NewsModel> hiveNewsList = await getOuthersNewsFromHive();

      for (var hiveNews in hiveNewsList) {
        try {
          NewsModel? fbNews = await _getNewsByIdFromFirebase(hiveNews.id);

          if (fbNews == null) {
            // Se não existe no Firebase mas o autor criou localmente offline, envia pro servidor
            if (hiveNews.createdBy == user.email) {
              await _saveNewsToFirebase(hiveNews);
            } else {
              // Se sumiu do Firebase, remove do Hive local
              await _deleteNewsFromHive(hiveNews.id);
            }
          } else {
            // Ambas existem: compara as datas de modificação para ver quem ganha
            DateTime? fbDate = fbNews.lastUpdated;
            DateTime? hiveDate = hiveNews.lastUpdated;

            if (fbDate != null && hiveDate != null) {
              DateTime cleanFbDate = trimDateTime(fbDate);
              DateTime cleanHiveDate = trimDateTime(hiveDate);

              if (cleanFbDate.isAfter(cleanHiveDate)) {
                await saveNewsToHive(fbNews);
              } else if (cleanHiveDate.isAfter(cleanFbDate)) {
                await _saveNewsToFirebase(hiveNews);
              }
            }
          }
        } catch (e) {
          debugPrint("Erro ao sincronizar a notícia ID ${hiveNews.id}: $e");
        }
      }
    } catch (e) {
      throw Exception("Erro fatal ao sincronizar Hive e Firebase: $e");
    }
  }

  Future<NewsModel?> _getNewsByIdFromFirebase(String id) async {
    var doc = await _firestore.collection(collectionPath).doc(id).get();
    if (!doc.exists) return null;
    final data = doc.data()!;
    data['id'] = doc.id;
    return NewsModel.fromMap(data);
  }

  DateTime trimDateTime(DateTime dt) {
    return DateTime(dt.year, dt.month, dt.day, dt.hour, dt.minute, dt.second);
  }
}
