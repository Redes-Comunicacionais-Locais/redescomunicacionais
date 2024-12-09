import 'package:flutter/material.dart';
import 'package:redescomunicacionais/app/routes/app_routes.dart';
import 'package:redescomunicacionais/app/sign_in.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  tryLogin() async {
    var hasLogged = await SignInService().trySignInGoogle();
    if (!context.mounted) {
      return;
    }
    if (hasLogged) {
      Navigator.pushReplacementNamed(context, Routes.HOME);
    } else {
      Navigator.pushReplacementNamed(context, Routes.LOGIN);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: tryLogin(),
        builder: (context, snapshot) {
          return const Scaffold(
            body: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Entrando",
                    style: TextStyle(
                        color: Colors.grey,
                        fontSize: 32,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 50,
                ),
                CircularProgressIndicator(color: Colors.grey),
              ],
            ),
          );
        });
  }
}
