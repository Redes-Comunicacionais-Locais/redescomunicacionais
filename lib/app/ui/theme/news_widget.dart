import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';
import 'package:intl/intl.dart'; // Para formatar datas

class NewsWidget extends StatelessWidget {
  NewsWidget({super.key});

  final NewsController newsController = Get.put(NewsController());
  
  @override
  Widget build(BuildContext context) {
    newsController.buscarNews();

    return Obx(() {
      if (newsController.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (newsController.newss.isEmpty) {
        return const Center(child: Text("Nenhuma notícia encontrada"));
      }

      return ListView(
        children: [
          const SizedBox(height: 16.0), // Espaço superior

          // Cards horizontais
          SizedBox(
            height: 120.0, // Altura dos cards horizontais
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: newsController.newss.map((news) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(
                        Routes.NEWS_PAGE,
                        arguments: {
                          "titulo": news.titulo,
                          "subtitulo": news.subtitulo,
                          "cidade": news.cidade,
                          "categoria": news.categoria,
                          "corpo": news.corpo,
                          "imgurl": news.imgurl,
                          "autor": news.autor,
                          "dataCriacao": news.dataCriacao
                        },
                      );
                    },
                    child: Card(
                      color: Colors.grey[900],
                      margin: const EdgeInsets.symmetric(horizontal: 8.0),
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: SizedBox(
                        width: 120.0, // Largura de cada card horizontal
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(8.0)),
                              child: Image.memory(
                                base64Decode(news.imgurl),
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 70.0,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                news.titulo,
                                style: const TextStyle(
                                  fontSize: 12.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          const SizedBox(height: 16.0), // Espaço entre os cards horizontais e a lista vertical

          // Lista vertical de notícias
          ...newsController.newss.map((news) {
            return GestureDetector(
              onTap: () {
                Get.toNamed(
                  Routes.NEWS_PAGE,
                  arguments: {
                    "titulo": news.titulo,
                    "subtitulo": news.subtitulo,
                    "cidade": news.cidade,
                    "categoria": news.categoria,
                    "corpo": news.corpo,
                    "imgurl": news.imgurl,
                    "autor": news.autor,
                    "dataCriacao": news.dataCriacao
                  },
                );
              },
              child: Card(
                color: Colors.black,
                margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Imagem da notícia
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
                      child: Image.memory(
                        base64Decode(news.imgurl),
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200.0,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Título da notícia
                          Text(
                            news.titulo,
                            style: const TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          // Subtítulo ou descrição curta
                          Text(
                            news.subtitulo,
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.grey,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8.0),
                          // Data formatada
                          Text(
                            _getFormattedDate(news.dataCriacao),
                            style: const TextStyle(
                              fontSize: 12.0,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }

  // Função para calcular e formatar a data
  String _getFormattedDate(String dataCriacao) {
    try {
      final creationDate = DateTime.parse(dataCriacao);
      final now = DateTime.now();
      final difference = now.difference(creationDate);

      if (difference.inSeconds < 60) {
        return '${difference.inSeconds} segundos atrás';
      } else if (difference.inMinutes < 60) {
        return '${difference.inMinutes} minutos atrás';
      } else if (difference.inHours < 24) {
        return '${difference.inHours} horas atrás';
      } else {
        return DateFormat('dd/MM/yyyy').format(creationDate);
      }
    } catch (e) {
      return dataCriacao;
    }
  }
}