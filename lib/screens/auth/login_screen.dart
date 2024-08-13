import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/signup_screen.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

import '../../utils/const.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final number = TextEditingController();
  final otp = TextEditingController();
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
                  const SizedBox(
                    height: 50,
                  ),
                  Image.asset(
                    logo,
                    width: 191,
                    height: 80,
                  ),
                  const SizedBox(
                    height: 12.5,
                  ),
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
                  topLeft: Radius.circular(
                    30,
                  ),
                  topRight: Radius.circular(
                    30,
                  ),
                )),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  TextWidget(
                    text: 'Log in',
                    fontSize: 32,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFieldWidget(
                    height: 80,
                    length: 9,
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
                  ),
                  TextFieldWidget(
                    suffix: Padding(
                      padding:
                          const EdgeInsets.only(right: 10, top: 10, bottom: 10),
                      child: ButtonWidget(
                        height: 10,
                        width: 75,
                        fontSize: 12,
                        label: 'Get OTP',
                        onPressed: () {},
                      ),
                    ),
                    height: 80,
                    length: 6,
                    inputType: TextInputType.number,
                    borderColor: secondary,
                    label: 'Enter OTP',
                    controller: otp,
                    hint: 'Enter 6-digit Code',
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    height: 50,
                    width: 320,
                    fontSize: 20,
                    label: 'Log in',
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const HomeScreen()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(
                          width: 110,
                          child: Divider(
                            color: secondary,
                          )),
                      Padding(
                        padding: const EdgeInsets.only(left: 5, right: 5),
                        child: TextWidget(
                          text: 'or log in with',
                          fontSize: 12,
                          color: secondary,
                        ),
                      ),
                      const SizedBox(
                          width: 110,
                          child: Divider(
                            color: secondary,
                          )),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      for (int i = 0; i < socials.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(left: 5, right: 5),
                          child: Image.asset(
                            socials[i],
                            width: 54,
                            height: 54,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextWidget(
                    text: 'Don’t have an account ?',
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen()),
                      );
                    },
                    child: TextWidget(
                      text: 'Create an Account',
                      fontSize: 15,
                      color: Colors.black,
                      fontFamily: 'Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
