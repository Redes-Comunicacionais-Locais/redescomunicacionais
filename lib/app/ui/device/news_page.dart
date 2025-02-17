import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  @override
  Widget build(BuildContext context) {
    final String titulo = Get.arguments["titulo"] ?? "";
    final String subtitulo = Get.arguments["subtitulo"] ?? "";
    final String imgurl = Get.arguments["imgurl"] ?? "";
    final String autor = Get.arguments["autor"] ?? "";
    final String dataCriacao = Get.arguments["dataCriacao"] ?? "";
    final String categoria = Get.arguments["categoria"] ?? "";
    final String cidade = Get.arguments["cidade"] ?? "";
    final String corpo = Get.arguments["corpo"] ?? "";

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Noticia completa"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        children: [
          Stack(
            children: [
              ShaderMask(
                shaderCallback: (rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Colors.black],
                  ).createShader(Rect.fromLTRB(0, 0, rect.width, rect.height));
                },
                /*child: Image.memory(
                        movie["image"],
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),*/
                child: Image.network(
                  imgurl, // Substitua com a URL da imagem desejada
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  titulo,
                  style: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
              ),
            ],
          ),
          Text(
            subtitulo,
            style: const TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(autor,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 12)),
          Text(categoria,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 12)),
          Text(cidade,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 12)),
          Text(dataCriacao,
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w100,
                  fontSize: 12)),
          const SizedBox(
            height: 20,
          ),
          MarkdownBody(
            data: corpo,
          ),
        ],
      ),
    );
  }
}
