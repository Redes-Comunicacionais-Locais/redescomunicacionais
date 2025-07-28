import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/data/model/news_model.dart';
import 'package:redescomunicacionais/app/data/repository/news_repository.dart';

class NewsController extends GetxController {
  final NewsRepository _repository = NewsRepository();
  var newss = <NewsModel>[].obs;
  var isLoading = false.obs;

  // Adicionar notícias
  Future<void> adicionarNews(
    String titulo,
    String subtitulo,
    String cidade,
    String categoria,
    String corpo,
    String imgurl,
    String autor,
    String email,
    String dataCriacao,
    String type,
  ) async {
    try {
      isLoading(true);
      NewsModel news = NewsModel(
        titulo: titulo,
        subtitulo: subtitulo,
        cidade: cidade,
        categoria: categoria,
        corpo: corpo,
        imgurl: imgurl,
        autor: autor,
        email: email,
        dataCriacao: dataCriacao,
        type: type,
      );

      await _repository.adicionarNews(news);
      newss.insert(0, news); // Insere no início da lista
      Get.snackbar(
        'Sucesso',
        'Notícia cadastrada com sucesso!',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.green, // Fundo verde para sucesso
      );
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Não foi possível cadastrar a notícia.',
        snackPosition: SnackPosition.BOTTOM,
        colorText: Colors.white,
        backgroundColor: Colors.red, // Fundo vermelho para erro
      );
    } finally {
      isLoading(false);
    }
  }

  // Buscar notícias
  Future<void> buscarNews() async {
    try {
      isLoading(true);
      newss.value = await _repository.buscarNews();
      newss.sort((a, b) => DateTime.parse(b.dataCriacao)
          .compareTo(DateTime.parse(a.dataCriacao)));
    } catch (e) {
      Get.snackbar('Erro', 'Não foi possível carregar as notícias.',
          snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading(false);
    }
  }
}
