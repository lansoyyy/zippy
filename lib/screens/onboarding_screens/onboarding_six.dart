import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/landing_screen.dart';
import 'package:zippy/screens/onboarding_screens/onboarding_third.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class OnboardingSix extends StatelessWidget {
  const OnboardingSix({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      for (int i = 0; i < 6; i++)
                        Padding(
                          padding: const EdgeInsets.only(left: 3),
                          child: Icon(
                            Icons.circle,
                            size: 10,
                            color: i == 5 ? secondary : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).pushReplacement(MaterialPageRoute(
                          builder: (context) => const LandingScreen()));
                    },
                    child: Row(
                      children: [
                        TextWidget(
                          text: 'next',
                          fontSize: 16,
                          color: secondary,
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.arrow_circle_right_outlined,
                          color: secondary,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 100,
            ),
            Image.asset(
              logo,
              color: secondary,
              height: 80,
              width: 190,
            ),
            const SizedBox(
              height: 25,
            ),
            TextWidget(
              text: 'Payments',
              fontSize: 26,
              fontFamily: 'Bold',
            ),
            TextWidget(
              text: 'Bill is due?\nZippy got you.',
              fontSize: 16,
              color: Colors.grey,
            ),
            const Expanded(
              child: SizedBox(
                height: 25,
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                'assets/images/cat/CAT #11 1.png',
                width: 220,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
