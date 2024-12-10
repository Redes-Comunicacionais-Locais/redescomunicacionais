import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/login_controller.dart';
import 'package:sign_in_button/sign_in_button.dart';
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = Get.put(LoginController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text(
            "Redes Comunicacionais Locais",
            style: TextStyle(
                fontSize: 32, color: Colors.grey, fontWeight: FontWeight.bold),
          ),
          SignInButton(Buttons.google, onPressed: _loginController.loginGoogle),
        ],
      ),
    ));
  }
}