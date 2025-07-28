import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/home_controller.dart';
import 'package:redescomunicacionais/app/controller/location_controller.dart';
import 'package:redescomunicacionais/app/controller/news_controller.dart';
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
  int timeRefresh = 30; // Intervalo de refresh automático em minutos

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  Timer? _refreshTimer;

  @override
  void initState() {
    super.initState();
    _startAutoRefresh();
  }

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
      body: RefreshIndicator(
        key: _refreshIndicatorKey,
        onRefresh: _onRefresh,
        child: Stack(
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
                  return SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Container(
                      height: MediaQuery.of(context).size.height - 200,
                      child: const Center(
                        child: Text(
                          "Localização não disponível. Verifique as permissões.\n\nArraste para baixo para tentar novamente.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  );
                }
              },
            ),
          ],
        ),
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

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  void _startAutoRefresh() {
    _refreshTimer = Timer.periodic(Duration(minutes: timeRefresh), (timer) {
      _onRefreshSilent();
    });
  }

  Future<void> _onRefreshSilent() async {
    try {
      await _locationController.getUserLocation();

      try {
        final newsController = Get.find<NewsController>();
        await newsController.buscarNews();
      } catch (e) {
        // NewsController ainda não foi inicializado, ignore
      }

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      // Falha silenciosa para não incomodar o usuário
      print("Erro no refresh automático: $e");
    }
  }

  Future<void> _onRefresh() async {
    try {
      // Sempre atualiza a localização no refresh manual
      // Se a localização não está disponível, chama requestLocation que mostrará o popup
      if (_locationController.city.value.isEmpty ||
          _locationController.city.value == "Permissão negada" ||
          _locationController.city.value == "Erro ao obter localização") {
        bool locationResult = await _locationController.requestLocation();

        // Se o usuário escolheu "Sair", não continua com a atualização
        if (!locationResult) {
          return;
        }
      } else {
        // Se já tem localização, atualiza silenciosamente
        await _locationController.getUserLocation();
      }

      // Recarrega as notícias se o controller existir
      try {
        final newsController = Get.find<NewsController>();
        await newsController.buscarNews();
      } catch (e) {
        // NewsController ainda não foi inicializado, ignore
      }

      // Força a reconstrução da interface
      setState(() {});
    } catch (e) {
      // Tratamento de erro geral
      Get.snackbar(
        'Erro',
        'Erro ao atualizar dados',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
