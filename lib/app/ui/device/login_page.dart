import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:redescomunicacionais/app/sign_in.dart';
import 'package:redescomunicacionais/app/ui/device/home_page.dart';
import 'package:sign_in_button/sign_in_button.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}
class _LoginPageState extends State<LoginPage> {
  loginGoogle() async {
    // FirebaseAuth.
    try {
      await SignInService().signInGoogle();
    } catch (e) {
      if (!context.mounted) {
        return;
      }
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
      return;
    }
    print(FirebaseAuth.instance.currentUser!.email);
    if (!context.mounted) {
      return;
    }
    Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomePage()));
  }

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
          SignInButton(Buttons.google, onPressed: loginGoogle),
        ],
      ),
    ));
  }
}