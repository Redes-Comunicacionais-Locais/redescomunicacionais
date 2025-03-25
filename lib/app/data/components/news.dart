 import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';

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
                    flex: 3,
                    child: Image.memory(
                      base64Decode(news.imgurl),
                      fit: BoxFit.cover,
                      width: double.infinity,
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          news.titulo,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      color: Colors.white,
                      child: Center(
                        child: Text(
                          news.subtitulo,
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
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
}