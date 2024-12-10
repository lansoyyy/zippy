import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zippy/firebase_options.dart';
import 'package:zippy/screens/onboarding_screens/onboarding_one.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: 'zippy-3c566',
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zippy',
      home: OnboardingOne(),
    );
  }
}
