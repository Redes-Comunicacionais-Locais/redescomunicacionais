import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/data/model/news_model.dart';
import 'package:redescomunicacionais/app/data/repository/news_repository.dart';

class NewsController extends GetxController {
  final NewsRepository _repository = NewsRepository();
  var newss = <NewsModel>[].obs;
  var isLoading = false.obs;

  // Add news - save to both Hive and Firebase
  Future<void> adicionarNews(
    String title,
    String subtitle,
    List<String> cities,
    List<String> categories,
    String body,
    List<String> urlImages,
    String author,
    String email,
    String createdAt,
    String type,
    String status,
  ) async {
    try {
      isLoading(true);
      NewsModel news = NewsModel(
        id: DateTime.now().toIso8601String(),
        title: title,
        subtitle: subtitle,
        cities: cities,
        categories: categories,
        body: body,
        urlImages: urlImages,
        author: author,
        createdBy: email,
        createdAt: DateTime.now(),
        type: type,
        status: status,
        validatedBy: null,
        validatedAt: null,
        editedBy: null,
        editedAt: null,
        excluedBy: null,
        excluedAt: null,
        editedObservation: null,
        validatedObservation: null,
        excludedObservation: null,
      );

      // Save to both Hive and Firebase simultaneously
      await Future.wait([
        _repository.saveNewsToHive(news),
        _repository.adicionarNews(news),
      ]);

      newss.insert(0, news); // Insert at the beginning of the list
      Get.snackbar(
        'Sucesso',
        'Notícia cadastrada com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green,
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível cadastrar a notícia.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red,
      );
    } finally {
      isLoading(false);
    }
  }

  // Get news from Firebase only
  Future<void> buscarNews() async {
    try {
      isLoading(true);
      newss.value = await _repository.buscarNews();
      newss.sort((a, b) => DateTime.parse(b.createdAt as String)
          .compareTo(DateTime.parse(a.createdAt as String)));
    } catch (e) {
      /*Get.snackbar('Erro', 'Não foi possível carregar as notícias.',
          snackPosition: SnackPosition.BOTTOM);*/
    } finally {
      isLoading(false);
    }
  }

  // Get news from Hive only
  Future<void> getNewsFromHive() async {
    try {
      isLoading(true);
      newss.value = await _repository.getNewsFromHive();
      newss.sort((a, b) => DateTime.parse(b.createdAt as String)
          .compareTo(DateTime.parse(a.createdAt as String)));
    } catch (e) {
      Get.snackbar(
          'Erro', 'Não foi possível carregar as notícias do cache local.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
