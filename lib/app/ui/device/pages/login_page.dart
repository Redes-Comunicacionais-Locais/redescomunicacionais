import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:redescomunicacionais/app/controller/login_controller.dart';
import 'package:redescomunicacionais/app/controller/version_controller.dart';
import 'package:sign_in_button/sign_in_button.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginController _loginController = Get.find<LoginController>();
  final versionController = Get.find<VersionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: const Text(
                    "Redes Comunicacionais Locais",
                    style: TextStyle(
                        fontSize: 32,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
              SvgPicture.asset(
                'assets/RCLLogo.svg',
                width: 200,
                height: 200,
                // ignore: deprecated_member_use
                color: Colors.white,
              ),
              Column(
                children: [
                  SizedBox(
                    width: 250,
                    child: SignInButton(Buttons.google,
                        text: 'Entrar com Google',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: const EdgeInsets.all(16.0),
                        onPressed: _loginController.loginGoogle),
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 250,
                    child: SignInButton(Buttons.microsoft,
                        text: 'Entrar com Microsoft',
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50.0),
                        ),
                        padding: const EdgeInsets.all(22.0),
                        onPressed: _loginController.loginMicrosoft),
                  ),
                ],
              ),
              Text(
                versionController.version,
                style: const TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
