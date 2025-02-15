import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:vertical_card_pager/vertical_card_pager.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';

class News extends StatelessWidget {
  News({super.key});

  final NewsController newsController =
      Get.put(NewsController()); // Adiciona manualmente

  @override
  Widget build(BuildContext context) {
    // Garante que as notícias sejam carregadas quando o widget for construído
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
          (index) => Container(
            color: Colors.white,
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Image.network(
                    //newsController.newss[index],
                    "https://avatars.githubusercontent.com/u/190403325?s=400&u=badaaa8fa393825cf58b7e7a81a1865c79e9d2e0&v=4",
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
                        newsController.newss[index].titulo,
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
              ],
            ),
          ),
        ),
        onSelectedItem: (index) {
          Get.toNamed(
            Routes.NEWS_PAGE,
            arguments: {"titulo": newsController.newss[index].titulo},
          );
        },
      );
    });
  }
}
