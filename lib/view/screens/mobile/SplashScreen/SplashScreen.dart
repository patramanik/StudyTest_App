// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:study_test_app/view/screens/mobile/Home/HomeScreen.dart';
import 'package:get/get.dart';
import '../../../../viewmodel/Auth/auth_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    final AuthController authController = Get.find<AuthController>();
    Timer(const Duration(seconds: 3), () {
      authController.checkLoginStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Container(
        height: height,
        width: width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(colors: [
          Color(0xffcfd9df),
          Color(0xffe2ebf0),
        ], begin: FractionalOffset.topLeft, end: FractionalOffset.bottomRight)),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              height: 230,
              width: 350,
              decoration: const BoxDecoration(
                  // color: Colors.white,
                  borderRadius: BorderRadius.only(
                topLeft: Radius.elliptical(150, 150),
                topRight: Radius.elliptical(150, 150),
                bottomLeft: Radius.elliptical(150, 150),
              )),
              child: Center(
                child: SizedBox(
                  width: 200.0,
                  height: 150.0,
                  child: Image.asset(
                    'assets/images/logo.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}