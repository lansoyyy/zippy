import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/auth/signup_screen3.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

import '../../utils/const.dart';

class SignupScreen2 extends StatefulWidget {
  const SignupScreen2({super.key});

  @override
  State<SignupScreen2> createState() => _SignupScreen2State();
}

class _SignupScreen2State extends State<SignupScreen2> {
  final email = TextEditingController();
  final password = TextEditingController();
  final cpassword = TextEditingController();

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
                ],
              ),
            ),
          ),
          Container(
            width: double.infinity,
            height: 525,
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
                    text: 'Sign up',
                    fontSize: 32,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  TextWidget(
                    text:
                        'Fill in the required information below\nor register with your social account',
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFieldWidget(
                    inputType: TextInputType.emailAddress,
                    height: 55,
                    hint: 'Enter your Email',
                    borderColor: secondary,
                    label: 'Email',
                    controller: email,
                  ),
                  TextFieldWidget(
                    showEye: true,
                    height: 55,
                    hint: 'Enter your Password',
                    borderColor: secondary,
                    label: 'Password',
                    controller: password,
                  ),
                  TextFieldWidget(
                    showEye: true,
                    height: 55,
                    hint: 'Enter your Password',
                    borderColor: secondary,
                    label: 'Verify Password',
                    controller: cpassword,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    height: 50,
                    width: 320,
                    fontSize: 20,
                    label: 'Next',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen3()),
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
                          text: 'or sign up with',
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
                      for (int i = 1; i < socials.length; i++)
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
                    text: 'Already have an account ?',
                    fontSize: 14,
                    color: Colors.grey,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    height: 2.5,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen()),
                      );
                    },
                    child: TextWidget(
                      text: 'Log in Now',
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
