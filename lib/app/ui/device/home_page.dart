import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    appBar: AppBar(title: const Text('HomePage')),

    body: Container(
      child: const Text("Home page"),
    )
    );
  }
}