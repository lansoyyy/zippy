import 'package:flutter/material.dart';

logout(BuildContext context, Widget navigationRoute) {
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
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(
                  //       builder: (context) => const LoginScreen()),
                  // );
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
