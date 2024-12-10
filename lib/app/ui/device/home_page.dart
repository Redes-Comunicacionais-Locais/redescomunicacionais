import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/login_controller.dart';

import '../../controller/home_controller.dart';

class HomePage extends StatelessWidget {
  final HomeController _homeController = Get.put(HomeController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Redes Comunicacionais Locais"),
        centerTitle: true,
      ),
      body: Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 150.0,
                  height: 150.0,
                  decoration: BoxDecoration(
                    color: Get.theme.primaryColor,
                    image: DecorationImage(
                      image: NetworkImage(_homeController.user.urlImage ?? 'https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png'),
                      fit: BoxFit.cover,
                    ),
                    borderRadius: const BorderRadius.all(Radius.circular(75.0)),
                    boxShadow: const [BoxShadow(blurRadius: 7.0, color: Colors.black)],
                  ),
                ),
                const SizedBox(height: 40.0),
                Text(
                  '${_homeController.user.name}',
                 
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 15.0),
                Text(
                  '${_homeController.user.email}',
                  style: const TextStyle(
                    fontSize: 17.0,
                    fontStyle: FontStyle.italic,
                    fontFamily: 'Montserrat',
                  ),
                ),
                const SizedBox(height: 25.0),
                SizedBox(
                  height: 30.0,
                  width: 95.0,
                  child: ElevatedButton(
                    onPressed: () {
                      LoginController().logout();
                    },
                    child: const Center(
                      child: Text(
                        'Sair',
                        style: TextStyle(
                          color: Colors.red,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}