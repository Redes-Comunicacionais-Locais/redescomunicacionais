import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/login_controller.dart';
import 'package:redescomunicacionais/app/controller/user_controller.dart';
import 'package:redescomunicacionais/app/data/components/news.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/controller/version_controller.dart'; // Import necessário

import '../../../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  final UserController _userController = Get.put(UserController());
  final VersionController _versionController = Get.put(VersionController()); // Instância do VersionController

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
        backgroundColor: Colors.black,
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
                    backgroundImage: NetworkImage(_homeController.user.urlImage ??
                        'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
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
              leading: const Icon(Icons.info_outline, color: Colors.white),
              title: const Text(
                'Sobre',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);

                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: Colors.black,
                      title: const Text(
                        'Sobre',
                        style: TextStyle(color: Colors.white),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          ListTile(
                            leading: const Icon(Icons.info, color: Colors.blue),
                            title: const Text(
                              'Informações do Projeto',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _homeController.goInfo();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.group, color: Colors.blue),
                            title: const Text(
                              'Equipe',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _homeController.goInfoTeam();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.folder, color: Colors.blue),
                            title: const Text(
                              'Estrutura do Projeto',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _homeController.goProjectStructure();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.book, color: Colors.blue),
                            title: const Text(
                              'Guia do Usuário',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _homeController.goUserGuide();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.settings, color: Colors.blue),
                            title: const Text(
                              'Instalação e Configuração',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _homeController.goInstallationConfig();
                            },
                          ),
                          ListTile(
                            leading: const Icon(Icons.help, color: Colors.blue),
                            title: const Text(
                              'Perguntas Frequentes',
                              style: TextStyle(color: Colors.white),
                            ),
                            onTap: () {
                              Navigator.pop(context);
                              _homeController.goFAQ();
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
            Obx(() {
              _userController.loadUserRole(_homeController.user.email);
              if (_userController.isAdmin.value || _userController.isSuperAdmin.value) {
                return ListTile(
                  leading: const Icon(Icons.article_outlined, color: Colors.white),
                  title: const Text(
                    'Criar Notícia',
                    style: TextStyle(color: Colors.white)
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, Routes.CREATE_NEWS);
                  },
                );
              } else {
                return const ListTile(
                  leading: Icon(Icons.lock_outline, color: Colors.red),
                  title: Text('Criar Notícia',
                  style: TextStyle(color: Colors.white)
                ),
                );
              }
            }),
             ListTile(
              leading: const Icon(Icons.info, color: Colors.white),
              title: const Text(
                'Versão',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                _versionController.version, // Acessa diretamente a versão
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app, color: Colors.white),
              title: const Text(
                'Sair',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                LoginController().logout();
              },
            ),
           
          ],
        ),
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
        color: Colors.black,
        height: 56.0,
        child: const Center(
          child: Text(
            "Cidade: ...",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
