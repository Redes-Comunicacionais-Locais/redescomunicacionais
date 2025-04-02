import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';
import 'package:intl/intl.dart'; // Adicione esta importação para formatar datas

class News extends StatelessWidget {
  News({super.key});

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

      return VerticalCardPager(
        titles: List.filled(newsController.newss.length, ""),
        images: List.generate(
          newsController.newss.length,
          (index) {
            final news = newsController.newss[index];
            
            return Container(
              color: Colors.white,
              child: Column(
                children: [
                  Expanded(
                    flex: 4,
                    child: Image.memory(
                      base64Decode(news.imgurl),
                      fit: BoxFit.cover, // Preencher a caixa toda proporcionalmente
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: const Color.fromARGB(255, 34, 34, 34), // Caixa preta
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          return SingleChildScrollView(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  news.titulo,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0,
                                  ),
                                  textAlign: TextAlign.center, // Título centralizado
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 8.0, top: 30.0),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                      _getFormattedDate(news.dataCriacao),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 12.0,
                                      ),
                                      textAlign: TextAlign.left, // Subtítulo à esquerda
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
        onSelectedItem: (index) {
          Get.toNamed(
            Routes.NEWS_PAGE,
            arguments: {
              "titulo": newsController.newss[index].titulo,
              "subtitulo": newsController.newss[index].subtitulo,
              "cidade": newsController.newss[index].cidade,
              "categoria": newsController.newss[index].categoria,
              "corpo": newsController.newss[index].corpo,
              "imgurl": newsController.newss[index].imgurl,
              "autor": newsController.newss[index].autor,
              "dataCriacao": newsController.newss[index].dataCriacao
            },
          );
        },
      );
    });
  }

  // Função para calcular e formatar a data
  String _getFormattedDate(String dataCriacao) {
    try {
      // Parse da data de criação
      final creationDate = DateTime.parse(dataCriacao);
      final now = DateTime.now();

      // Calcula a diferença
      final difference = now.difference(creationDate);

      if (difference.inSeconds < 60) {
        // Retorna a diferença em segundos se for menor que 1 minuto
        return '${difference.inSeconds} segundos atrás';
      } else if (difference.inMinutes < 60) {
        // Retorna a diferença em minutos se for menor que 1 hora
        return '${difference.inMinutes} minutos atrás';
      } else if (difference.inHours < 24) {
        // Retorna a diferença em horas se for menos de 24 horas
        return '${difference.inHours} horas atrás';
      } else {
        // Retorna a data formatada se for mais de 24 horas
        return DateFormat('dd/MM/yyyy').format(creationDate);
      }
    } catch (e) {
      // Retorna a data original em caso de erro
      return dataCriacao;
    }
  }
}