import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/auth/signup_screen2.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

import '../../utils/const.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final name = TextEditingController();
  final bday = TextEditingController();
  final address = TextEditingController();
  final otp = TextEditingController();
  final number = TextEditingController();

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
                    text: 'Create Account',
                    fontSize: 32,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  TextWidget(
                    text: 'Fill in the required information below',
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  TextFieldWidget(
                    height: 55,
                    hint: 'eg. Josefa M. Rizalino',
                    borderColor: secondary,
                    label: 'Fullname',
                    controller: name,
                  ),
                  TextFieldWidget(
                    height: 55,
                    hint: 'MM/DD/YYYY',
                    borderColor: secondary,
                    label: 'Birthday',
                    controller: bday,
                    suffix: IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.calendar_month_outlined,
                          color: secondary,
                        )),
                  ),
                  TextFieldWidget(
                    inputType: TextInputType.streetAddress,
                    height: 55,
                    hint: 'Enter your Location',
                    borderColor: secondary,
                    label: 'Address',
                    controller: address,
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
                    label: 'Next',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen2()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
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
