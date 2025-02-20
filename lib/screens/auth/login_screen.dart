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
  final TextEditingController _numberController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  bool _hasSentOtp = false;
  int _countdown = 60; // Initial countdown value
  Timer? _timer;

  final Random _random = Random();
  String _otpValue = '';
  final _box = GetStorage();

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when the screen is disposed
    _numberController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    final sixDigitNumber = _random.nextInt(900000) + 100000;

    sendSms('0${_numberController.text}', sixDigitNumber.toString());

    setState(() {
      _otpValue = sixDigitNumber.toString();
      _hasSentOtp = true;
      _countdown = 60;
    });

    _timer?.cancel(); // Cancel any existing timer before starting a new one
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (_countdown > 0) {
        setState(() => _countdown--);
      } else {
        t.cancel();
        setState(() => _hasSentOtp = false); // Allow resending OTP
      }
    });
  }

  Future<void> _login() async {
    if (_otpController.text != _otpValue) {
      showToast('Invalid OTP!');
      return;
    }

    final querySnapshot = await FirebaseFirestore.instance
        .collection('Users')
        .where('number', isEqualTo: _numberController.text)
        .get();

    if (querySnapshot.docs.isEmpty) {
      showToast('Your number is not associated with an account!');
      return;
    }

    final userDoc = querySnapshot.docs.first;
    _box.write('uid', userDoc['uid']);
    setState(() => userId = userDoc['uid']);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: Column(
        children: [
          Expanded(
            child: _buildWelcomeSection(),
          ),
          _buildLoginForm(),
        ],
      ),
    );
  }

  Widget _buildWelcomeSection() {
    return SizedBox(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
    );
  }

  Widget _buildLoginForm() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.5,
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
            _buildMobileNumberField(),
            _buildOtpField(),
            const SizedBox(height: 10),
            _buildLoginButton(),
            const SizedBox(height: 30),
            _buildSignupPrompt(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileNumberField() {
    return TextFieldWidget(
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
      controller: _numberController,
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildOtpField() {
    return TextFieldWidget(
      suffix: Padding(
        padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
        child: ButtonWidget(
          color: _numberController.text.length != 10 || _hasSentOtp
              ? Colors.grey
              : secondary,
          height: 10,
          width: 75,
          fontSize: 12,
          label: _hasSentOtp ? 'Resend OTP ($_countdown)' : 'Get OTP',
          onPressed: _numberController.text.length != 10 || _hasSentOtp
              ? () {}
              : _startCountdown,
        ),
      ),
      height: 80,
      length: 6,
      inputType: TextInputType.number,
      borderColor: secondary,
      label: 'Enter OTP',
      controller: _otpController,
      hint: 'Enter 6-digit Code',
      onChanged: (value) => setState(() {}),
    );
  }

  Widget _buildLoginButton() {
    return ButtonWidget(
      height: 50,
      width: 320,
      fontSize: 20,
      color: _otpController.text.length != 6 ? Colors.grey : secondary,
      label: 'Log in',
      onPressed: _otpController.text.length != 6 ? () {} : _login,
    );
  }

  Widget _buildSignupPrompt() {
    return Column(
      children: [
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
      ],
    );
  }
}
