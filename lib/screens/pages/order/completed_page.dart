import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';

class CompletedPage extends StatelessWidget {
  const CompletedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: TextWidget(
                text: 'Delivery Completed',
                fontSize: 22,
                fontFamily: 'Bold',
                color: secondary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                'assets/images/cat.png',
                width: 140,
                height: 140,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextWidget(
                text: 'Enjoy your food!',
                fontSize: 22,
                fontFamily: 'Bold',
                color: secondary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Order ID',
                    fontSize: 16,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  TextWidget(
                    text: '123 abc EFG 458',
                    fontSize: 16,
                    fontFamily: 'Bold',
                  ),
                  const Divider(
                    color: secondary,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Reference Number',
                    fontSize: 16,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  TextWidget(
                    text: '111 2222 3333 444',
                    fontSize: 16,
                    fontFamily: 'Bold',
                  ),
                  const Divider(
                    color: secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                itemButton(Icons.download_sharp, 'Download'),
                itemButton(Icons.share, 'Share'),
                itemButton(Icons.warning, 'Report'),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ButtonWidget(
                width: 310,
                color: secondary,
                label: 'DONE',
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  itemButton(IconData icon, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextWidget(
          text: label,
          fontSize: 12,
          fontFamily: 'Regular',
        ),
      ],
    );
  }
}
