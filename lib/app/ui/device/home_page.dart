import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/login_controller.dart';
import 'package:redescomunicacionais/app/controller/user_controller.dart';
import 'package:redescomunicacionais/app/data/components/news.dart';
import 'package:redescomunicacionais/app/data/sobre_texto.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';

import '../../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final UserController _userController = Get.put(UserController());

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
              Icons.wifi,
              color: Colors.white,
            ),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Wifi"),
                    content: const Text(
                      "Esta tela exibe informações sobre sua conexão.",
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
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
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
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: NetworkImage(_homeController
                            .user.urlImage ??
                        'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'), // Substitua pela URL da sua imagem
                  ),
                  const SizedBox(width: 16),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_homeController.user.name}',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      Text(
                        '${_homeController.user.email}',
                        style: const TextStyle(
                          fontSize: 10.0,
                          color: Colors.white,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('Sobre'),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return SimpleDialog(
                      title: const Text('Sobre'),
                      children: <Widget>[
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                             _homeController.goInfo();
                            
                          },
                          child: const Text('Informações do Projeto'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _homeController.goInfoTeam();

                           
                          },
                          child: const Text('Equipe'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _homeController.goProjectStructure();
                          },
                          child: const Text('Estrutura do Projeto'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _homeController.goUserGuide();
                          },
                          child: const Text('Guia do Usuário'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _homeController.goInstallationConfig();
                          },
                          child: const Text('Instalação e Configuração'),
                        ),
                        SimpleDialogOption(
                          onPressed: () {
                            Navigator.pop(context);
                            _homeController.goFAQ();
                          },
                          child: const Text('Perguntas Frequentes'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Obx(() {
              _userController.loadUserRole(_homeController.user.email);
              if (_userController.isAdmin.value || _userController.isSuperAdmin.value) {
                return ListTile(
                  leading: const Icon(Icons.article_outlined),
                  title: const Text('Criar Notícia'),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Routes.CREATE_NEWS);
                  },
                );
              } else {
                return const ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.red),
                  title: Text('Criar Notícia'),
                );
              }
            }),
            ListTile(
              leading: const Icon(Icons.exit_to_app),
              title: const Text('Sair'),
              onTap: () {
                LoginController().logout();
              },
            ),
        
       ] ),
      ),
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
          News(),
        ],
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        height: 56.0,
        child: const Center(
          child: Text(
            "Cidade: ...",
            style: TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}
