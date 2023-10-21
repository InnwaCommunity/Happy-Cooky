import 'dart:async';

import 'package:flutter/material.dart';
import 'package:new_project/config/routes.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 2), () => go(context));
    return Scaffold(
      body: Center(
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          child: const Text(
            'Happy Cooky',
            style: TextStyle(color: Colors.green, fontSize: 25),
          ),
        ),
      ),
    );
  }

  void go(BuildContext context) {
    context.left(Routes.home, (route) => false);
  }
}
