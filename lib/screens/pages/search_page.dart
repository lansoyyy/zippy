import 'package:flutter/material.dart';
import 'package:zippy/screens/pages/order/review_page.dart';
import 'package:zippy/screens/pages/shop_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
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
                          text: 'Cart',
                          fontSize: 15,
                          color: secondary,
                          fontFamily: 'Medium',
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Image.asset(
                          'assets/images/cart.png',
                          height: 20,
                          width: 20,
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
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: secondary,
                  ),
                  borderRadius: BorderRadius.circular(5.0),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.search, color: Colors.black54),
                    SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: 'What are you craving today?',
                            hintStyle: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    Icon(Icons.tune, color: Colors.black54),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < foodCategories.length; i++)
                  Padding(
                    padding: const EdgeInsets.only(left: 5, right: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: i == 0 ? secondary.withOpacity(0.3) : null,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: secondary,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              foodCategories[i],
                              width: 25,
                              height: 25,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextWidget(
                          text: foodCategoriesName[i],
                          fontSize: 12,
                          fontFamily: 'Medium',
                          color: secondary,
                        ),
                      ],
                    ),
                  ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < 10; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: GestureDetector(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const ReviewPage()),
                      );
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 3,
                          child: Container(
                            width: 80,
                            height: 132,
                            decoration: BoxDecoration(
                              image: const DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(
                                  'assets/images/Rectangle 2.png',
                                ),
                              ),
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: secondary,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Card(
                          elevation: 3,
                          child: Container(
                            width: 230,
                            height: 132,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: secondary,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  TextWidget(
                                    text: 'Jollibee Downtown Strip',
                                    fontSize: 16,
                                    fontFamily: 'Bold',
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      const Icon(
                                        Icons.delivery_dining_outlined,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      TextWidget(
                                        text: 'Free delivery',
                                        fontSize: 10,
                                        fontFamily: 'Regular',
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      const Icon(
                                        Icons.access_time_sharp,
                                        size: 15,
                                      ),
                                      const SizedBox(
                                        width: 5,
                                      ),
                                      TextWidget(
                                        text: '10-15 minutes',
                                        fontSize: 10,
                                        fontFamily: 'Regular',
                                      ),
                                    ],
                                  ),
                                  TextWidget(
                                    text: 'Fastfood • Chicken • Burger • Pasta',
                                    fontSize: 16,
                                    align: TextAlign.start,
                                    fontFamily: 'Bold',
                                    color: secondary,
                                  ),
                                  TextWidget(
                                    text: 'Price range ₱',
                                    fontSize: 10,
                                    fontFamily: 'Regular',
                                  ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: TextWidget(
                                      text: '20% off first purchase. min ₱500',
                                      fontSize: 10,
                                      fontFamily: 'Regular',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
