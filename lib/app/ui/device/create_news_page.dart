import 'package:flutter/material.dart';
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
  String? selectedCity;

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
                                    style: const TextStyle(color: Colors.black),
                                  ),
                                  selected:
                                      selectedCategories.contains(category),
                                  selectedColor: Colors.blue[100],
                                  checkmarkColor: Colors.black,
                                  backgroundColor: Colors.grey[300],
                                  onSelected: (bool isSelected) {
                                    setState(() {
                                      if (isSelected) {
                                        selectedCategories.add(category);
                                      } else {
                                        selectedCategories.remove(category);
                                      }
                                    });
                                  },
                                ))
                            .toList(),
                      ),
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
                            borderSide:
                                const BorderSide(color: Colors.white, width: 2),
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
                      const SizedBox(height: 16),
                      ElevatedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.image),
                        label: const Text("Adicionar Imagem"),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final String title = titleController.text;
                            final String? city = selectedCity;
                            final String category =
                                selectedCategories.join(", ");

                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text("Notícia Publicada!"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Título: $title"),
                                      Text("Cidade: $city"),
                                      Text("Categoria: $category"),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text("Fechar"),
                                    ),
                                  ],
                                );
                              },
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 50),
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
