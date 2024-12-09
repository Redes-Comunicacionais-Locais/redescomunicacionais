import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InitialPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(title: const Text('InitialPage')),

    body: Container(
      child: const Text("Login"),
    ),
    );
  }
}