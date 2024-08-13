import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/landing_screen.dart';

import '../utils/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    Timer(const Duration(seconds: 4), () async {
      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LandingScreen()));
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
