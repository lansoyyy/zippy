import 'dart:async';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zippy/screens/auth/signup_screen.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/services/otp_service.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

import '../../utils/const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final number = TextEditingController();
  final otp = TextEditingController();

  bool hasSent = false;
  int countdown = 10; // Initial countdown value
  Timer? timer;

  Random random = Random();

  String otpValue = '';

  final box = GetStorage();

  void startCountdown() {
    int sixDigitNumber = random.nextInt(900000) + 100000;

    sendSms('0${number.text}', sixDigitNumber.toString());

    setState(() {
      otpValue = sixDigitNumber.toString();
      hasSent = true;
      countdown = 10;
    });

    timer?.cancel(); // Cancel any existing timer before starting a new one
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (countdown > 0) {
        setState(() {
          countdown--;
        });
      } else {
        t.cancel();
        setState(() {
          hasSent = false; // Allow resending OTP
        });
      }
    });
  }

  @override
  void dispose() {
    timer?.cancel(); // Cancel timer when the screen is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: Column(
        children: [
          Expanded(
            child: SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(height: 50),
                  Image.asset(logo, width: 191, height: 80),
                  const SizedBox(height: 12.5),
                  TextWidget(
                    text: 'Hi! Welcome',
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 450,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  TextWidget(
                    text: 'Log in',
                    fontSize: 32,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(height: 25),
                  TextFieldWidget(
                    height: 80,
                    length: 10,
                    inputType: TextInputType.number,
                    prefix: TextWidget(
                      text: '+63',
                      fontSize: 24,
                      color: Colors.black,
                      fontFamily: 'Medium',
                    ),
                    borderColor: secondary,
                    label: 'Mobile Number',
                    controller: number,
                    onChanged: (p0) {
                      setState(() {
                        number.text = p0;
                      });
                    },
                  ),
                  TextFieldWidget(
                    suffix: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      child: ButtonWidget(
                        color: number.text.length != 10
                            ? Colors.grey
                            : hasSent
                                ? Colors.grey
                                : secondary,
                        height: 10,
                        width: 75,
                        fontSize: 12,
                        label: hasSent ? 'Resend OTP ($countdown)' : 'Get OTP',
                        onPressed: number.text.length != 10
                            ? () {}
                            : hasSent
                                ? () {}
                                : startCountdown, // Disable button if countdown is running
                      ),
                    ),
                    height: 80,
                    length: 6,
                    inputType: TextInputType.number,
                    borderColor: secondary,
                    label: 'Enter OTP',
                    controller: otp,
                    hint: 'Enter 6-digit Code',
                    onChanged: (p0) {
                      setState(() {
                        otp.text = p0;
                      });
                    },
                  ),
                  const SizedBox(height: 10),
                  ButtonWidget(
                    height: 50,
                    width: 320,
                    fontSize: 20,
                    color: otp.text.length != 6 ? Colors.grey : secondary,
                    label: 'Log in',
                    onPressed: otp.text.length != 6
                        ? () {}
                        : () {
                            FirebaseFirestore.instance
                                .collection('Users')
                                .where('number', isEqualTo: number.text)
                                .get()
                                .then((QuerySnapshot querySnapshot) {
                              if (querySnapshot.docs.isNotEmpty) {
                                if (otp.text == otpValue) {
                                  box.write(
                                      'uid', querySnapshot.docs.first['uid']);

                                  setState(() {
                                    userId = querySnapshot.docs.first['uid'];
                                  });

                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => const HomeScreen(),
                                    ),
                                  );
                                } else {
                                  showToast('Invalid OTP!');
                                }
                              } else {
                                showToast(
                                    'Your number is not associated with an account!');
                              }
                            });
                          },
                  ),
                  const SizedBox(height: 30),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     const SizedBox(
                  //         width: 110, child: Divider(color: secondary)),
                  //     Padding(
                  //       padding: const EdgeInsets.symmetric(horizontal: 5),
                  //       child: TextWidget(
                  //         text: 'or log in with',
                  //         fontSize: 12,
                  //         color: secondary,
                  //       ),
                  //     ),
                  //     const SizedBox(
                  //         width: 110, child: Divider(color: secondary)),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.center,
                  //   children: [
                  //     for (int i = 0; i < socials.length; i++)
                  //       Padding(
                  //         padding: const EdgeInsets.symmetric(horizontal: 5),
                  //         child: Image.asset(
                  //           socials[i],
                  //           width: 54,
                  //           height: 54,
                  //         ),
                  //       ),
                  //   ],
                  // ),
                  // const SizedBox(height: 20),
                  TextWidget(
                    text: 'Don’t have an account ?',
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(height: 2.5),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SignupScreen(),
                        ),
                      );
                    },
                    child: TextWidget(
                      text: 'Create an Account',
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
