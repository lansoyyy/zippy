import 'package:flutter/material.dart';
import 'package:zippy/screens/auth/landing_screen.dart';
import 'package:zippy/screens/onboarding_screens/onboarding_second.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class OnboardingOne extends StatelessWidget {
  const OnboardingOne({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: PageView(
          children: [
            Column(
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
                                color: i == 0 ? secondary : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => const OnboardingSecond()));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       TextWidget(
                      //         text: 'next',
                      //         fontSize: 16,
                      //         color: secondary,
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       const Icon(
                      //         Icons.arrow_circle_right_outlined,
                      //         color: secondary,
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                  text: 'Food Delivery',
                  fontSize: 26,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text: 'Get your treats delivered at\nyour doorstep.',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 25,
                  ),
                ),
                Image.asset(
                  'assets/images/cat/CAT #7 1.png',
                ),
              ],
            ),
            Column(
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
                                color: i == 1 ? secondary : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     // Navigator.of(context).push(MaterialPageRoute(
                      //     //     builder: (context) => const OnboardingThird()));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       TextWidget(
                      //         text: 'next',
                      //         fontSize: 16,
                      //         color: secondary,
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       const Icon(
                      //         Icons.arrow_circle_right_outlined,
                      //         color: secondary,
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
            Column(
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
                                color: i == 2 ? secondary : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => const OnboardingFourth()));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       TextWidget(
                      //         text: 'next',
                      //         fontSize: 16,
                      //         color: secondary,
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       const Icon(
                      //         Icons.arrow_circle_right_outlined,
                      //         color: secondary,
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                  text: 'Surprise',
                  fontSize: 26,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text: 'Surprise your loved ones with\ntreats.',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 25,
                  ),
                ),
                Image.asset(
                  'assets/images/cat/CAT #8 1.png',
                  width: 250,
                ),
              ],
            ),
            Column(
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
                                color: i == 3 ? secondary : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => const OnboardingFifth()));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       TextWidget(
                      //         text: 'next',
                      //         fontSize: 16,
                      //         color: secondary,
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       const Icon(
                      //         Icons.arrow_circle_right_outlined,
                      //         color: secondary,
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                  text: 'Package Delivery',
                  fontSize: 26,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text: 'Zippy is your business\npartner in deliveries',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 25,
                  ),
                ),
                Image.asset(
                  'assets/images/cat/CAT #5 3.png',
                ),
              ],
            ),
            Column(
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
                                color: i == 4 ? secondary : Colors.grey,
                              ),
                            ),
                        ],
                      ),
                      // GestureDetector(
                      //   onTap: () {
                      //     Navigator.of(context).push(MaterialPageRoute(
                      //         builder: (context) => const OnboardingSix()));
                      //   },
                      //   child: Row(
                      //     children: [
                      //       TextWidget(
                      //         text: 'next',
                      //         fontSize: 16,
                      //         color: secondary,
                      //       ),
                      //       const SizedBox(
                      //         width: 10,
                      //       ),
                      //       const Icon(
                      //         Icons.arrow_circle_right_outlined,
                      //         color: secondary,
                      //       ),
                      //     ],
                      //   ),
                      // ),
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
                  text: 'Purchase Delivery',
                  fontSize: 26,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text:
                      'Short in time for groceries?\nZippy can do it for you.',
                  fontSize: 16,
                  color: Colors.grey,
                ),
                const Expanded(
                  child: SizedBox(
                    height: 25,
                  ),
                ),
                Image.asset(
                  'assets/images/cat/CAT #6 1.png',
                  width: 250,
                ),
              ],
            ),
            Column(
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
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const LandingScreen()));
                        },
                        child: Row(
                          children: [
                            TextWidget(
                              text: 'proceed',
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
          ],
        ),
      ),
    );
  }
}
