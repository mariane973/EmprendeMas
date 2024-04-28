import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:emprende_mas/home.dart';
import 'package:emprende_mas/vistas/login.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splash: Lottie.asset('img/splash.json'),
        nextScreen: Home(),
        duration: 2000,
        splashIconSize: 2000,
        splashTransition: SplashTransition.fadeTransition,
        animationDuration: const Duration(seconds: 3),
    );
  }
}
