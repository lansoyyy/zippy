import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/auth/signup_screen4.dart';
import 'package:zippy/services/add_user.dart';
import 'package:zippy/services/otp_service.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

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

  bool hasSent = false;
  int countdown = 10;
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    // height: 50,
                    height: MediaQuery.of(context).size.height * 0.3,
                  ),
                  Image.asset(
                    logo,
                    width: 191,
                    height: 80,
                  ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.1,
            ),
            Container(
              width: double.infinity,
              height: MediaQuery.of(context).size.height * 0.7,
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
                    inputType: TextInputType.datetime,
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
                                ? () {
                                    // print('+63${number.text}');
                                  }
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
                  const SizedBox(
                    height: 10,
                  ),
                  ButtonWidget(
                    height: 50,
                    width: 320,
                    fontSize: 20,
                    label: 'Next',
                    color: otp.text.length != 6 ? Colors.grey : secondary,
                    onPressed: otp.text.length != 6
                        ? () {}
                        : () async {
                            if (otp.text == otpValue &&
                                name.text.isNotEmpty &&
                                bday.text.isNotEmpty &&
                                address.text.isNotEmpty) {
                              String? result = await addUser(
                                name: name.text,
                                email: box.read('email') ?? '',
                                bday: bday.text,
                                number: number.text,
                                home: 'Home',
                                homeAddress: address.text,
                                homeLat: 0.0,
                                homeLng: 0.0,
                                officeAddress: '',
                                officeLat: 0.0,
                                officeLng: 0.0,
                                profile:
                                    'https://cdn-icons-png.flaticon.com/256/149/149071.png',
                                isActive: true,
                                isVerified: false,
                              );

                              if (result != null) {
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(
                                    builder: (context) => const SignupScreen4(),
                                  ),
                                );
                              } else {
                                showToast(
                                    "Failed to create user. Please try again.");
                              }
                            } else {
                              showToast(name.text.isEmpty ||
                                      bday.text.isEmpty ||
                                      address.text.isEmpty
                                  ? 'Please fill in all the required fields'
                                  : 'Invalid OTP, Please try again.');
                            }
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
          ],
        ),
      ),
    );
  }
}
