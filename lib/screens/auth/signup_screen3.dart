import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/signup_screen.dart';
import 'package:zippy/screens/auth/signup_screen4.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

import '../../utils/const.dart';

class SignupScreen3 extends StatefulWidget {
  const SignupScreen3({super.key});

  @override
  State<SignupScreen3> createState() => _SignupScreen3State();
}

class _SignupScreen3State extends State<SignupScreen3> {
  final List<TextEditingController> _controllers =
      List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());

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
                    text: 'You’re Almost There!',
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
                    text: 'Verify Email',
                    fontSize: 32,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  TextWidget(
                    text: 'Enter the 5-digit code sent to your\nemail address',
                    fontSize: 12,
                    color: Colors.black,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: List.generate(6, (index) {
                      return Container(
                        width: 50,
                        height: 100,
                        decoration: BoxDecoration(
                          border: Border.all(color: secondary),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: TextField(
                          style: const TextStyle(
                            color: Colors.white,
                          ),
                          controller: _controllers[index],
                          focusNode: _focusNodes[index],
                          maxLength: 1,
                          textAlign: TextAlign.center,
                          keyboardType: TextInputType.number,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            counterText: '',
                          ),
                          onChanged: (value) {},
                        ),
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ButtonWidget(
                          height: 25,
                          width: 73,
                          fontSize: 12,
                          label: 'Get Code',
                          onPressed: () {},
                        ),
                        TextButton(
                          onPressed: () {},
                          child: TextWidget(
                            text: 'Resend again in 500 seconds',
                            fontSize: 12,
                            color: secondary,
                            fontFamily: 'Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Checkbox(
                          activeColor: secondary,
                          value: true,
                          onChanged: (value) {},
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: TextWidget(
                            text:
                                'Agree to Terms and Conditions and Privacy Policy',
                            fontSize: 12,
                            color: secondary,
                            fontFamily: 'Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    height: 50,
                    width: 320,
                    fontSize: 20,
                    label: 'Create Account',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const SignupScreen4()),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 30,
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
