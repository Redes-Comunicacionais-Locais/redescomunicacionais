import 'package:flutter/material.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';
import 'package:redescomunicacionais/app/ui/components/icon_base64.dart';
import 'package:redescomunicacionais/app/ui/components/markdown_editor.dart';
import '../../../controller/home_controller.dart';
import 'package:redescomunicacionais/app/controller/image_controller.dart';
import 'package:get/get.dart';
import 'package:flutter_quill/flutter_quill.dart'; // Adicione este import
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
  late QuillController
      bodyController; // Altere de TextEditingController para QuillController

  List<String> selectedCategories = [];
  List<String> selectedCities = [];
  String? type;

  bool showCategoryError = false;

  void validateAndPublish() {
    setState(() {
      showCategoryError = selectedCategories.isEmpty; // Marca erro se vazio
    });

    if (_formKey.currentState!.validate() && selectedCategories.isNotEmpty) {
      final String title = titleController.text;
      final String subtitle = subtitleController.text;
      final String body = getBodyText();
      List<String> urlImages = [imageController.base64String ?? iconBase64()];
      final String author = homeController.user.name!;
      final String email = homeController.user.email;
      final String createdAt = DateTime.now().toString();

      // ====== Adicionar notícia/FireStore ======
      titleController.clear();
      subtitleController.clear();
      newsController.adicionarNews(
        title,
        subtitle,
        selectedCities,
        selectedCategories,
        body,
        urlImages,
        author,
        email,
        createdAt,
        type ?? '',
        "Em análise",
      );
      Get.back();
    }
  }

  @override
  void initState() {
    super.initState();
    bodyController = QuillController.basic(); // Altere esta linha
  }

  // Formato Delta
  String getBodyText() {
    return jsonEncode(bodyController.document.toDelta().toJson());
  }

  @override
  void dispose() {
    bodyController.dispose(); // Mantenha o dispose
    super.dispose();
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
                                      'Segurança',
                                      'Educação',
                                      'Saúde',
                                      'Transporte público e trânsito',
                                      'Economia',
                                      'Emprego e oportunidades',
                                      'Cultura',
                                      'Turismo e lazer',
                                      'Esportes',
                                      'Meio Ambiente',
                                      'Infraestrutura da cidade',
                                      'Habitação',
                                      'Tecnologia',
                                      'Ação comunitária'
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
                                        value: selectedCities.contains(city),
                                        onChanged: (bool? isChecked) {
                                          setState(() {
                                            if (isChecked == true) {
                                              selectedCities.add(city);
                                            } else {
                                              selectedCities.remove(city);
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
                                    ].map((selectedType) {
                                      return CheckboxListTile(
                                        title: Text(
                                          selectedType,
                                          style: const TextStyle(
                                              color: Colors.white),
                                        ),
                                        value: type ==
                                            selectedType, // Apenas uma pode ser selecionada
                                        onChanged: (bool? isChecked) {
                                          setState(() {
                                            if (isChecked == true) {
                                              type = selectedType;
                                            } else {
                                              type = null;
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
                      Expanded(
                        child: MarkdownEditor(controller: bodyController),
                      ),

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
