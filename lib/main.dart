import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/landing_screen.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/onboarding_screens/onboarding_one.dart';
import 'package:zippy/screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Zippy',
      home: OnboardingOne(),
    );
  }
}
