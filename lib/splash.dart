import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/vistas/clientes/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      backgroundColor: Colors.black,
      splash: Lottie.asset('img/tucann.json'
      ),
      nextScreen: Home(),
      duration: 3800,
      splashIconSize: 800,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
