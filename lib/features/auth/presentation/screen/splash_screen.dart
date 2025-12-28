import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:spendly/features/auth/presentation/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  final SplashController splashController = Get.find();

  SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
