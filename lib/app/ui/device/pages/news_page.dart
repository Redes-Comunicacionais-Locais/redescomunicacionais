import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:intl/intl.dart'; // Adicione esta importação
import 'package:redescomunicacionais/app/ui/components/markdown_styles.dart';

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
    final String type = Get.arguments["type"] ?? "";

    // Formata a data
    String formatData(String data) {
      try {
        final DateTime parsedDate = DateTime.parse(data);
        return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
      } catch (e) {
        return data; // Retorna a data original caso ocorra erro
      }
    }

    return Scaffold(
      backgroundColor: Colors.black, // Fundo escuro
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Noticia completa",
          style: TextStyle(color: Colors.white), // Texto claro
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0), // Adiciona espaçamento
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10), // Bordas arredondadas
                child: Image.memory(
                  base64Decode(imgurl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200, // Altura ajustada para melhor visualização
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white, // Texto claro
              fontWeight: FontWeight.bold,
              fontSize: 28, // Tamanho maior para destaque
            ),
            textAlign: TextAlign.center, // Centraliza o título
          ),
          const SizedBox(height: 10),
          Text(
            subtitulo,
            style: const TextStyle(
              color: Colors.white70, // Texto claro com opacidade
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center, // Centraliza o subtítulo
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Autor: $autor",
                style: const TextStyle(
                  color: Colors.white54, // Texto mais sutil
                  fontSize: 12,
                ),
              ),
              Text(
                "Data: ${formatData(dataCriacao)}", // Formata a data
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Cidade: $cidade",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              Text(
                "Categoria: $categoria",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              Text(
                "Tipo: $type",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          MarkdownBody(
            data: corpo,
            styleSheet: customMarkdownStyle
          ),
        ],
      ),
    );
  }
}
