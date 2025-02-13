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
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _bdayController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  bool _hasSentOtp = false;
  int _countdown = 10;
  Timer? _timer;

  final Random _random = Random();
  String _otpValue = '';
  final _box = GetStorage();

  @override
  void dispose() {
    _timer?.cancel(); // Cancel timer when the screen is disposed
    _nameController.dispose();
    _bdayController.dispose();
    _addressController.dispose();
    _otpController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    final sixDigitNumber = _random.nextInt(900000) + 100000;

    sendSms('0${_numberController.text}', sixDigitNumber.toString());

    setState(() {
      _otpValue = sixDigitNumber.toString();
      _hasSentOtp = true;
      _countdown = 10;
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

  Future<void> _proceedToNextScreen() async {
    if (_otpController.text != _otpValue) {
      showToast('Invalid OTP, Please try again.');
      return;
    }

    if (_nameController.text.isEmpty ||
        _bdayController.text.isEmpty ||
        _addressController.text.isEmpty) {
      showToast('Please fill in all the required fields');
      return;
    }

    final result = await addUser(
      name: _nameController.text,
      email: _box.read('email') ?? '',
      bday: _bdayController.text,
      number: _numberController.text,
      home: 'Home',
      homeAddress: _addressController.text,
      homeLat: 0.0,
      homeLng: 0.0,
      officeAddress: '',
      officeLat: 0.0,
      officeLng: 0.0,
      profile: 'https://cdn-icons-png.flaticon.com/256/149/149071.png',
      isActive: true,
      isVerified: false,
    );

    if (result != null) {
      _box.write('uid', result);

      setState(() {
        userId = result;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const SignupScreen4()),
      );
    } else {
      showToast("Failed to create user. Please try again.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondary,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildLogoSection(),
            _buildFormSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildLogoSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Center(
        child: Image.asset(logo, width: 191, height: 80),
      ),
    );
  }

  Widget _buildFormSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.7,
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
            const SizedBox(height: 25),
            _buildFullNameField(),
            _buildBirthdayField(),
            _buildAddressField(),
            _buildMobileNumberField(),
            _buildOtpField(),
            const SizedBox(height: 10),
            _buildNextButton(),
            const SizedBox(height: 30),
            _buildLoginPrompt(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFullNameField() {
    return TextFieldWidget(
      height: 55,
      hint: 'eg. Josefa M. Rizalino',
      borderColor: secondary,
      label: 'Fullname',
      controller: _nameController,
    );
  }

  Widget _buildBirthdayField() {
    return TextFieldWidget(
      height: 55,
      hint: 'MM/DD/YYYY',
      borderColor: secondary,
      label: 'Birthday',
      inputType: TextInputType.datetime,
      controller: _bdayController,
      suffix: IconButton(
        onPressed: () {}, // Add date picker logic here
        icon: const Icon(Icons.calendar_month_outlined, color: secondary),
      ),
    );
  }

  Widget _buildAddressField() {
    return TextFieldWidget(
      inputType: TextInputType.streetAddress,
      height: 55,
      hint: 'Enter your Location',
      borderColor: secondary,
      label: 'Address',
      controller: _addressController,
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

  Widget _buildNextButton() {
    return ButtonWidget(
      height: 50,
      width: 320,
      fontSize: 20,
      label: 'Next',
      color: _otpController.text.length != 6 ? Colors.grey : secondary,
      onPressed: _otpController.text.length != 6 ? () {} : _proceedToNextScreen,
    );
  }

  Widget _buildLoginPrompt() {
    return Column(
      children: [
        TextWidget(
          text: 'Already have an account ?',
          fontSize: 14,
          color: Colors.grey,
          fontFamily: 'Medium',
        ),
        const SizedBox(height: 2.5),
        GestureDetector(
          onTap: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: TextWidget(
            text: 'Log in Now',
            fontSize: 15,
            color: Colors.black,
            fontFamily: 'Bold',
          ),
        ),
      ],
    );
  }
}
