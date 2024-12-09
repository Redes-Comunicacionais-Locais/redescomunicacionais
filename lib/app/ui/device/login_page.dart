import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginPage extends StatelessWidget{

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(title: const Text('LoginPage')),

    body: Container(
      child: const Text("Login"),
    ),
    );
  }
}