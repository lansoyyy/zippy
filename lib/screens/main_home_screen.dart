import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/purchase_screen.dart';
import 'package:zippy/screens/ride_screen.dart';
import 'package:zippy/screens/surprise_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class MainHomeScreen extends StatefulWidget {
  const MainHomeScreen({super.key});

  @override
  State<MainHomeScreen> createState() => _MainHomeScreenState();
}

class _MainHomeScreenState extends State<MainHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              logo,
              width: 250,
              height: 104,
              color: secondary,
            ),
            TextWidget(
              text: 'Balance',
              fontSize: 22,
              color: secondary,
              fontFamily: "Medium",
            ),
            TextWidget(
              text: 'Php 00.00',
              fontSize: 25,
              color: secondary,
              fontFamily: "Bold",
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding: const EdgeInsets.all(5),
                    // color: secondary,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      children: [
                        TextWidget(
                          text: 'Top-up',
                          fontSize: 22,
                          color: white,
                          fontFamily: "Medium",
                        ),
                        const Icon(
                          Icons.wallet,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding: const EdgeInsets.all(5),
                    // color: secondary,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      children: [
                        TextWidget(
                          text: 'Send',
                          fontSize: 22,
                          color: white,
                          fontFamily: "Medium",
                        ),
                        const Icon(
                          Icons.money,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Container(
                    width: MediaQuery.of(context).size.width / 4,
                    padding: const EdgeInsets.all(5),
                    // color: secondary,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: secondary,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Column(
                      children: [
                        TextWidget(
                          text: 'Scan',
                          fontSize: 22,
                          color: white,
                          fontFamily: "Medium",
                        ),
                        const Icon(
                          Icons.qr_code_scanner_rounded,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            TextWidget(
              text: 'Our Services',
              fontSize: 20,
              color: secondary,
              fontFamily: "Bold",
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const HomeScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/fastfood.png',
                            width: 35,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Food',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const PurchaseScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/cart.png',
                            width: 35,
                            color: secondary,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Purchase',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const SurpriseScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/Surprise.png',
                            width: 35,
                            color: secondary,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Surprise',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/package.png',
                            width: 35,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Package',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => const RideScreen()),
                    );
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/ride.png',
                            width: 35,
                            color: secondary,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Ride',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/payments.png',
                            width: 35,
                            color: secondary,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Payment',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/transient.png',
                            width: 35,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Transient',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/homeservice.png',
                            width: 35,
                            color: secondary,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Home \nService',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    showToast('Coming Soon');
                  },
                  child: Column(
                    children: [
                      Stack(
                        alignment: Alignment
                            .center, // This centers all children in the Stack
                        children: [
                          Image.asset(
                            catIcon,
                            width: 100,
                          ),
                          Image.asset(
                            'assets/images/tutorial.png',
                            width: 35,
                            color: secondary,
                          ),
                        ],
                      ),
                      TextWidget(
                        text: 'Tutorial',
                        fontSize: 17,
                        color: secondary,
                        fontFamily: "Medium",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
