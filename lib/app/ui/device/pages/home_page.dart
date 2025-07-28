import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/home_controller.dart';
import 'package:redescomunicacionais/app/controller/location_controller.dart';
import 'package:redescomunicacionais/app/ui/theme/news_widget.dart';
import 'package:redescomunicacionais/app/ui/theme/menu_drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final HomeController _homeController = Get.put(HomeController());
  final LocationController _locationController = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redes Comunicacionais Locais"),
        iconTheme: const IconThemeData(color: Colors.white),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.cloud_queue,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Sincronismo"),
                    content: const Text(
                      "Módulo em desenvolvimento, em breve teremos novidades.",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text("Fechar"),
                      ),
                    ],
                  );
                },
              );
            },
          ),
          IconButton(
            icon: const Icon(
              Icons.help_outline,
              color: Colors.white,
            ),
            onPressed: () {
              _homeController.goUserGuide();
            },
          ),
        ],
      ),
      drawer: MenuPage(), // Substitui o menu antigo pela nova classe
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: [
                  Colors.blue,
                  Colors.black,
                ],
              ),
            ),
          ),
          FutureBuilder(
            future: _locationController.requestLocation(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData && snapshot.data == true) {
                return NewsWidget();
              } else {
                return const Center(
                    child: Text(
                  "Localização não disponível. Verifique as permissões.",
                  style: TextStyle(color: Colors.white),
                ));
              }
            },
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.black,
        height: 30.0,
        child: Center(
          child: Obx(() => Text(
                _locationController.city.value,
                style: const TextStyle(fontSize: 18.0, color: Colors.white),
              )),
        ),
      ),
    );
  }
}
