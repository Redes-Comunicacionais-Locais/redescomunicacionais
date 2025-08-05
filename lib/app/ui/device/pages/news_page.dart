import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart'; // Adicione este import
import 'package:intl/intl.dart';

class NewsPage extends StatefulWidget {
  const NewsPage({super.key});

  @override
  State<NewsPage> createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  late QuillController _quillController;

  @override
  void initState() {
    super.initState();
    // Inicializa com documento vazio - será carregado no build
    _quillController = QuillController.basic();
  }

  @override
  void dispose() {
    _quillController.dispose();
    super.dispose();
  }

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

    // Carrega o conteúdo Delta no controller
    try {
      if (corpo.isNotEmpty) {
        final deltaJson = jsonDecode(corpo);
        final document = Document.fromJson(deltaJson);
        _quillController = QuillController(
          document: document,
          selection: const TextSelection.collapsed(offset: 0),
        );
      }
    } catch (e) {
      // Se falhar ao decodificar, usa texto simples
      _quillController = QuillController.basic();
      _quillController.document.insert(0, corpo);
    }

    // Formata a data
    String formatData(String data) {
      try {
        final DateTime parsedDate = DateTime.parse(data);
        return DateFormat('dd/MM/yyyy HH:mm').format(parsedDate);
      } catch (e) {
        return data;
      }
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Noticia completa",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.memory(
                  base64Decode(imgurl),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text(
            titulo,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 28,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            subtitulo,
            style: const TextStyle(
              color: Colors.white70,
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Autor: $autor",
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
              Text(
                "Data: ${formatData(dataCriacao)}",
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
          
          // SUBSTITUÍDO: MarkdownBody por QuillEditor somente leitura
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white24),
              borderRadius: BorderRadius.circular(8),
            ),
            child: AbsorbPointer( // ← BLOQUEIA TODA INTERAÇÃO
              child: QuillEditor.basic(
                controller: _quillController,
                focusNode: FocusNode(),
                scrollController: ScrollController(),
                config: QuillEditorConfig(
                  padding: const EdgeInsets.all(16),
                  autoFocus: false,
                  expands: false,
                  customStyles: DefaultStyles(
                    paragraph: DefaultTextBlockStyle(
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      HorizontalSpacing.zero,
                      const VerticalSpacing(6, 0),
                      const VerticalSpacing(0, 0),
                      null,
                    ),
                    bold: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    italic: const TextStyle(
                      color: Colors.white,
                      fontStyle: FontStyle.italic,
                    ),
                    underline: const TextStyle(
                      color: Colors.white,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.white,
                    ),
                    quote: DefaultTextBlockStyle(
                      const TextStyle(color: Colors.white70),
                      HorizontalSpacing.zero,
                      const VerticalSpacing(6, 6),
                      const VerticalSpacing(0, 0),
                      BoxDecoration(
                        border: Border(
                          left: BorderSide(color: Colors.white, width: 4),
                        ),
                      ),
                    ),
                    lists: DefaultListBlockStyle(
                      const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      HorizontalSpacing.zero,
                      const VerticalSpacing(6, 0),
                      const VerticalSpacing(0, 0),
                      const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      null,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
