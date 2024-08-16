import 'package:flutter/material.dart';
import 'package:zippy/utils/const.dart';

import '../../utils/colors.dart';
import '../../widgets/text_widget.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: secondary,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          TextWidget(
                            text: 'Back',
                            fontSize: 15,
                            color: secondary,
                            fontFamily: 'Medium',
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        TextWidget(
                          text: 'Logout',
                          fontSize: 15,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.logout,
                          color: secondary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(5.0),
                      child: CircleAvatar(
                        minRadius: 75,
                        maxRadius: 75,
                        backgroundImage: AssetImage(
                          'assets/images/sample_avatar.png',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 120, top: 110, bottom: 20),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle, color: secondary),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: TextWidget(
                text: 'Paula Baresco',
                fontSize: 28,
                color: secondary,
                fontFamily: 'Bold',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Personal Information',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      TextWidget(
                        text: 'Edit',
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'EMAIL ADDRESS',
                    fontSize: 10,
                    color: secondary,
                    fontFamily: 'Regular',
                  ),
                  const SizedBox(
                    width: 120,
                  ),
                  TextWidget(
                    text: 'MOBILE NUMBER',
                    fontSize: 10,
                    color: secondary,
                    fontFamily: 'Regular',
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Paula.baresco@gmail.com',
                    fontSize: 14,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  TextWidget(
                    text: '+6399 9999 9999',
                    fontSize: 14,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(left: 30, right: 30),
              child: Divider(
                color: secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextWidget(
                text: 'BIRTHDATE',
                fontSize: 10,
                color: secondary,
                fontFamily: 'Regular',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: TextWidget(
                text: 'January 01, 2000',
                fontSize: 14,
                color: secondary,
                fontFamily: 'Medium',
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Saved Addresses',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      TextWidget(
                        text: 'Edit',
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    home,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'HOME',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      TextWidget(
                        text: '999 Home Street, House Avenue ',
                        fontSize: 14,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    office,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'OFFICE',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      TextWidget(
                        text: '999 Work Street, Office Avenue, 2nd Floor ',
                        fontSize: 14,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    groups,
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Sarah’s House',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Regular',
                      ),
                      SizedBox(
                        width: 250,
                        child: TextWidget(
                          align: TextAlign.start,
                          text:
                              '999 Friend Street, Friend Building, 2nd Floor, Room 111',
                          fontSize: 14,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Payment Methods',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      const Icon(
                        Icons.add,
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    gcash,
                    width: 80,
                    height: 25,
                  ),
                  TextWidget(
                    text: '+639 9999 9999',
                    fontSize: 12,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondary,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Unlink',
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    paymaya,
                    width: 80,
                    height: 25,
                  ),
                  const SizedBox(),
                  Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Link',
                        fontSize: 10,
                        color: secondary,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        bpi,
                        width: 25,
                        height: 25,
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      TextWidget(
                        text: 'BPI',
                        fontSize: 15,
                        color: secondary,
                      ),
                    ],
                  ),
                  TextWidget(
                    text: '123 1234 1234',
                    fontSize: 12,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                  Container(
                    width: 60,
                    height: 18,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: secondary,
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Unlink',
                        fontSize: 10,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Center(
              child: Container(
                width: 320,
                height: 40,
                decoration: BoxDecoration(
                  color: secondary,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Recent Transactions',
                        fontSize: 15,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                      TextWidget(
                        text: '',
                        fontSize: 14,
                        color: Colors.white,
                        fontFamily: 'Medium',
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 30, bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextWidget(
                      text: 'Bluebird Coffee',
                      fontSize: 15,
                      color: secondary,
                      fontFamily: 'Bold',
                    ),
                    Column(
                      children: [
                        TextWidget(
                          text: 'Total: ₱ 800.00',
                          fontSize: 12,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                        TextWidget(
                          text: 'July 11, 2024 11:02 AM ',
                          fontSize: 8,
                          color: secondary,
                          fontFamily: 'Regular',
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            tileWidget(
              'Favorites',
              const Icon(
                Icons.favorite,
                color: Colors.white,
              ),
            ),
            tileWidget(
              'Terms and Conditions',
              TextWidget(
                text: 'View',
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Medium',
              ),
            ),
            tileWidget(
              'Privacy Policy',
              TextWidget(
                text: 'View',
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Medium',
              ),
            ),
            tileWidget(
              'Developers',
              TextWidget(
                text: 'View',
                fontSize: 14,
                color: Colors.white,
                fontFamily: 'Medium',
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 15),
              child: Center(
                child: Container(
                  width: 320,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: Center(
                    child: TextWidget(
                      text: 'Delete Account',
                      fontSize: 15,
                      color: Colors.white,
                      fontFamily: 'Bold',
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget tileWidget(String title, Widget suffix) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Center(
        child: Container(
          width: 320,
          height: 40,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15, right: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: title,
                  fontSize: 15,
                  color: Colors.white,
                  fontFamily: 'Medium',
                ),
                suffix
              ],
            ),
          ),
        ),
      ),
    );
  }
}
