import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';
import 'package:redescomunicacionais/app/ui/components/icon_base64.dart';
import 'package:redescomunicacionais/app/ui/components/markdown_styles.dart';
import '../../../controller/home_controller.dart';
import 'package:redescomunicacionais/app/controller/image_controller.dart';
import 'package:get/get.dart';
//import 'package:image_picker/image_picker.dart';
//import 'dart:typed_data';
import 'dart:convert';

class CreateNewsPage extends StatefulWidget {
  const CreateNewsPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CreateNewsPageState createState() => _CreateNewsPageState();
}

class _CreateNewsPageState extends State<CreateNewsPage> {
  final _formKey = GlobalKey<FormState>();

  final HomeController homeController = Get.find<HomeController>();
  final NewsController newsController = Get.find<NewsController>();
  final ImageController imageController = Get.find<ImageController>();

  final TextEditingController titleController = TextEditingController();
  final TextEditingController subtitleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();

  List<String> selectedCategories = [];
  String? selectedCategory;
  bool showCategoryError = false;
  String? selectedCity;
  String? selectedType;

  String textoExemploMarkdown = """
  ### Este é um exemplo de texto em Markdown
  
  **O que é o Markdown?** É uma linguagem de marcação leve usada para formatar texto de forma simples e intuitiva.

  Este é um parágrafo de exemplo que contém um pouco de **negrito** e *itálico* para destacar algumas palavras.
  
  ### Lista de Itens:
   - **Item 1**: Explicação sobre o primeiro item.
   - *Item 2*: Explicação sobre o segundo item.
   - *Item 3*: Um trecho de código destacado.
   
  > Esta é uma citação para dar mais ênfase a uma ideia.
  """;

  void validateAndPublish() {
    setState(() {
      showCategoryError = selectedCategories.isEmpty; // Marca erro se vazio
    });

    if (_formKey.currentState!.validate() && selectedCategories.isNotEmpty) {
      final String title = titleController.text;
      final String subtitle = subtitleController.text;
      final String category = selectedCategories.join(", ");
      final String bodyNews = bodyController.text;
      String imageUrl = imageController.base64String ?? iconBase64();
      final String autor = homeController.user.name!;
      final String email = homeController.user.email!;
      final String dataCriacao = DateTime.now().toString();

      // ====== Adicionar notícia/FireStore ======
      titleController.clear();
      subtitleController.clear();
      newsController.adicionarNews(
        title,
        subtitle,
        selectedCity ?? '',
        category,
        bodyNews,
        imageUrl,
        autor,
        email,
        dataCriacao,
        selectedType ?? '',
      );
      Get.back();
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
                      // ########## Seleção de Categoria ##########
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                "Selecione as Categorias",
                                style: TextStyle(color: Colors.white),
                              ),
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children: [
                                Column(
                                  children: [
                                    ...[
                                      'Política',
                                      'Esporte',
                                      'Economia',
                                      'Tecnologia',
                                    ].map((category) {
                                      return CheckboxListTile(
                                        title: Text(
                                          category,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        value: selectedCategories
                                            .contains(category),
                                        onChanged: (bool? isChecked) {
                                          setState(() {
                                            if (isChecked == true) {
                                              selectedCategories.add(category);
                                            } else {
                                              selectedCategories
                                                  .remove(category);
                                            }
                                          });
                                        },
                                        activeColor: Colors.blue,
                                        side: BorderSide(
                                            color: Colors.white,
                                            width: 2), // borda branca
                                        checkColor:
                                            Colors.white, // Marcação branca
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (showCategoryError)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Selecione pelo menos uma categoria.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ########## Seleção de Cidade ##########

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                "Selecione a Cidade",
                                style: TextStyle(color: Colors.white),
                              ),
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children: [
                                Column(
                                  children: [
                                    ...[
                                      'São Sebastião do Alto',
                                      'Macuco',
                                      'Rio das Flores',
                                      'Comendador Levy Gasparian',
                                      'Laje do Muriaé',
                                      'São José de Ubá',
                                    ].map((city) {
                                      return CheckboxListTile(
                                        title: Text(
                                          city,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        value: selectedCity ==
                                            city, // Apenas uma pode ser selecionada
                                        onChanged: (bool? isChecked) {
                                          setState(() {
                                            if (isChecked == true) {
                                              selectedCity = city;
                                            } else {
                                              selectedCity = null;
                                            }
                                          });
                                        },
                                        activeColor: Colors.blue,
                                        side: const BorderSide(
                                            color: Colors.white, width: 2),
                                        checkColor: Colors.white,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (showCategoryError)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Selecione pelo menos uma cidade.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // ########## Seleção do tipo ##########
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 8),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ExpansionTile(
                              title: const Text(
                                "Selecione o Tipo",
                                style: TextStyle(color: Colors.white),
                              ),
                              iconColor: Colors.white,
                              collapsedIconColor: Colors.white,
                              children: [
                                Column(
                                  children: [
                                    ...[
                                      'Notícia',
                                      'Opnião',
                                    ].map((type) {
                                      return CheckboxListTile(
                                        title: Text(
                                          type,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        value: selectedType ==
                                            type, // Apenas uma pode ser selecionada
                                        onChanged: (bool? isChecked) {
                                          setState(() {
                                            if (isChecked == true) {
                                              selectedType = type;
                                            } else {
                                              selectedType = null;
                                            }
                                          });
                                        },
                                        activeColor: Colors.blue,
                                        side: const BorderSide(
                                            color: Colors.white, width: 2),
                                        checkColor: Colors.white,
                                        controlAffinity:
                                            ListTileControlAffinity.leading,
                                      );
                                    }).toList(),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          if (showCategoryError)
                            const Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Text(
                                "Selecione pelo menos um tipo.",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 12),
                              ),
                            ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Texto em markdown
                      Column(children: [
                        TextFormField(
                          controller: bodyController
                            ..text = bodyController.text.isEmpty
                                ? textoExemploMarkdown
                                : bodyController
                                    .text, // Texto padrão quando vazio
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

                        // Convertendo texto para markdown
                        const SizedBox(height: 16),

                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.black,
                          ),
                          child: ValueListenableBuilder<TextEditingValue>(
                            valueListenable: bodyController,
                            builder: (context, value, child) {
                              return MarkdownBody(
                                data: value.text, // Atualiza o Markdown em tempo real
                                styleSheet: customMarkdownStyle
                              );
                            },
                          ),
                        ),
                      ]),
                      const SizedBox(height: 16),
                      // >>>>> Buscando imagem na galeria e convertendo para base 64 <<<<<

                      Center(
                        child: ElevatedButton.icon(
                          onPressed: () => imageController.pickImage(),
                          icon: const Icon(
                            Icons.image,
                          ),
                          label: const Text(
                            "Adicionar Imagem",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        "A imagem deve estar no formato JPG ou JPEG e, preferencialmente, ter um tamanho máximo de 500 KB. Imagens maiores serão comprimidas, o que pode causar perda de qualidade e lentidão no carregamento. Para uma melhor visualização, recomenda-se o uso de imagens com orientação paisagem.",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      Center(
                        child: Obx(() {
                          if (imageController.base64String != null) {
                            return Column(
                              children: [
                                Image.memory(
                                  base64Decode(imageController.base64String!),
                                  height: 150,
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        }),
                      ),
                      const SizedBox(height: 16),
                      Obx(() => Text(
                            imageController.message, // Acessa via getter
                            style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.yellow),
                          )),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: validateAndPublish,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: Colors.blue,
                        ),
                        child: const Text(
                          "Publicar Notícia",
                          style: TextStyle(color: Colors.white),
                        ),
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
