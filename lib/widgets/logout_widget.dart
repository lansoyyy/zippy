import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zippy/screens/auth/login_screen.dart';

logout(BuildContext context, Widget navigationRoute) {
  final box = GetStorage();
  return showDialog(
      context: context,
      builder: (context) => AlertDialog(
            title: const Text(
              'Logout Confirmation',
              style:
                  TextStyle(fontFamily: 'QBold', fontWeight: FontWeight.bold),
            ),
            content: const Text(
              'Are you sure you want to Logout?',
              style: TextStyle(fontFamily: 'QRegular'),
            ),
            actions: <Widget>[
              MaterialButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Close',
                  style: TextStyle(
                      fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                ),
              ),
              MaterialButton(
                onPressed: () async {
                  box.write('uid', '');

                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                        builder: (context) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ));
}
