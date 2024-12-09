import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:redescomunicacionais/app/ui/device/splash_page.dart';
class InitialPage extends StatelessWidget {
  const InitialPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Colors.blue,
                Colors.red,
              ],
            ),
          ),
        ),
        AnimatedSplashScreen(
          duration: 5000,
          splash: const Icon(
            Icons.ac_unit,
            size: 100,
            color: Colors.white,
          ),
          nextScreen: const SplashPage(), 
          splashTransition: SplashTransition.fadeTransition,
          backgroundColor: Colors.transparent,
        ),
        const Align(
          alignment: Alignment.bottomCenter,
          child:  Padding(
            padding: EdgeInsets.only(bottom: 50),
          ),
        ),
      ],
    );
  }
}