import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:get/get.dart';

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({Key? key}) : super(key: key);

  @override
  _CreateNewsPageState createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  List<String> selectedCategories = [];
  String? selectedCategory;
  bool showCategoryError = false;
  String? selectedCity;

  void validateAndPublish() {
    setState(() {
      showCategoryError = selectedCategories.isEmpty; // Marca erro se vazio
    });

    if (_formKey.currentState!.validate() && selectedCategories.isNotEmpty) {
      final String title = titleController.text;
      final String category = selectedCategories.join(", ");

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Notícia Publicada!"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Título: $title"),
                Text("Cidade: ${selectedCity ?? 'Não informada'}"),
                Text("Categoria: $category"),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("Fechar"),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Adicionar Notícia"),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Colors.blue, // Cor inicial
              Colors.black, // Cor final
            ],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    minHeight: MediaQuery.of(context).size.height),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: titleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Título",
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "O título é obrigatório.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: subtitleController,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Subtítulo (opcional)",
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Seleção múltipla de categorias com FilterChip
                      Column(
                          crossAxisAlignment: CrossAxisAlignment
                              .start, // Alinha os filhos à esquerda
                          children: [
                            const Text(
                              'Categorias',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8.0,
                              runSpacing: 4.0,
                              children: [
                                'Política',
                                'Esporte',
                                'Economia',
                                'Tecnologia',
                              ]
                                  .map((category) => FilterChip(
                                        label: Text(
                                          category,
                                          style: const TextStyle(
                                              color: Colors.black),
                                        ),
                                        selected: selectedCategories
                                            .contains(category),
                                        selectedColor: Colors.blue[100],
                                        checkmarkColor: Colors.black,
                                        backgroundColor: Colors.grey[300],
                                        onSelected: (bool isSelected) {
                                          setState(() {
                                            if (isSelected) {
                                              selectedCategories.add(category);
                                              showCategoryError = false;
                                            } else {
                                              selectedCategories
                                                  .remove(category);
                                            }
                                          });
                                        },
                                      ))
                                  .toList(),
                            ),
                            if (showCategoryError)
                              const Padding(
                                padding: EdgeInsets.only(top: 8),
                                child: Text(
                                  "Selecione pelo menos uma categoria!",
                                  style: TextStyle(
                                      color: Colors.red, fontSize: 14),
                                ),
                              ),
                          ]),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<String>(
                        value: selectedCity,
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          labelText: "Cidade",
                          labelStyle: const TextStyle(color: Colors.white),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        dropdownColor: Colors.black,
                        items: const [
                          DropdownMenuItem(
                              value: "São Sebastião do Alto",
                              child: Text("São Sebastião do Alto")),
                          DropdownMenuItem(
                              value: "Macuco", child: Text("Macuco")),
                          DropdownMenuItem(
                              value: "Rio das Flores",
                              child: Text("Rio das Flores")),
                          DropdownMenuItem(
                              value: "Comendador Levy Gasparian",
                              child: Text("Comendador Levy Gasparian")),
                          DropdownMenuItem(
                              value: "Laje do Muriaé",
                              child: Text("Laje do Muriaé")),
                          DropdownMenuItem(
                              value: "São José de Ubá",
                              child: Text("São José de Ubá")),
                        ],
                        onChanged: (value) {
                          selectedCity = value;
                        },
                        validator: (value) {
                          if (value == null) {
                            return "Selecione a cidade.";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      // Corpo em markdown
                      Column(children: [
                        TextFormField(
                          controller: bodyController,
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Corpo da Notícia",
                            labelStyle: const TextStyle(color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                              borderSide: const BorderSide(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.white, width: 2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          maxLines: 6,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "O corpo da notícia é obrigatório.";
                            }
                            return null;
                          },
                        ),
                        // TESTO EM MARKDOWN
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: const Color.fromARGB(137, 86, 42, 42),
                          ),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: bodyController,
                            builder: (context, value, child) {
                              return MarkdownBody(
                                data: value
                                    .text, // Atualiza o Markdown em tempo real
                                styleSheet: MarkdownStyleSheet(
                                  p: const TextStyle(color: Colors.white),
                                  h1: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold),
                                  h2: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                  h3: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                  strong: const TextStyle(
                                      color: Colors.yellow,
                                      fontWeight: FontWeight.bold),
                                  em: const TextStyle(
                                      color: Colors.cyan,
                                      fontStyle: FontStyle.italic),
                                  blockquote: TextStyle(
                                      color: Colors.grey[400],
                                      fontStyle: FontStyle.italic),
                                  code: TextStyle(
                                      color: Colors.greenAccent,
                                      fontFamily: "monospace"),
                                  listBullet:
                                      const TextStyle(color: Colors.white),
                                ),
                              );
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.image),
                        label: const Text("Adicionar Imagem"),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: validateAndPublish,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text("Publicar Notícia"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
