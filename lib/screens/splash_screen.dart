import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zippy/screens/auth/landing_screen.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/main_home_screen.dart';
import 'package:zippy/screens/onboarding_screens/onboarding_one.dart';
import 'package:zippy/utils/const.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final box = GetStorage();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 2), () async {
      if (box.read('uid') == '' ||
          box.read('uid').toString() == '' ||
          box.read('uid') == null ||
          box.read('uid') == 'null') {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const OnboardingOne()));
      } else {
        setState(() {
          userId = box.read('uid');
        });
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const MainHomeScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              'assets/images/splash.gif',
            ),
          ),
        ),
      ),
    );
  }
}
