import 'package:flutter/material.dart';
import 'package:zippy/screens/onboarding_screens/onboarding_third.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class OnboardingSecond extends StatelessWidget {
  const OnboardingSecond({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
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
                            color: i == 1 ? secondary : Colors.grey,
                          ),
                        ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const OnboardingThird()));
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
                text: 'Ride Hailing',
                fontSize: 26,
                fontFamily: 'Bold',
              ),
              TextWidget(
                text: 'Going somewhere?\nZippy got you covered.',
                fontSize: 16,
                color: Colors.grey,
              ),
              const Expanded(
                child: SizedBox(
                  height: 25,
                ),
              ),
              Image.asset(
                'assets/images/cat/CAT #1 1.png',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
