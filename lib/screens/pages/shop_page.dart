import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zippy/screens/pages/order/checkout_page.dart';
import 'package:zippy/screens/pages/order/completed_page.dart';
import 'package:zippy/screens/pages/order/review_page.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';

class ShopPage extends StatefulWidget {
  final String merchantId;
  const ShopPage({super.key, required this.merchantId});

  @override
  State<ShopPage> createState() => _ShopPageState();
}

class _ShopPageState extends State<ShopPage> {
  List<Map<String, dynamic>> merchants = [];
  List<Map<String, dynamic>> menuItems = [];

  int basketCount = 0;

  @override
  void initState() {
    super.initState();
    fetchMerchants();
    fetchMenuItems();
  }

  Future<void> fetchMerchants() async {
    CollectionReference merchantsCollection =
        FirebaseFirestore.instance.collection('Merchant');

    QuerySnapshot querySnapshot = await merchantsCollection.get();
    final allData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      merchants = allData;
    });
  }

  Future<void> fetchMenuItems() async {
    CollectionReference menuCollection =
        FirebaseFirestore.instance.collection('Menu');

    QuerySnapshot querySnapshot =
        await menuCollection.where('uid', isEqualTo: widget.merchantId).get();

    final filteredData = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    setState(() {
      menuItems = filteredData;
    });
  }

  void addToCart() {
    setState(() {
      basketCount++;
    });
  }

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
                        // TextWidget(
                        //   text: 'Cart',
                        //   fontSize: 15,
                        //   color: secondary,
                        //   fontFamily: 'Medium',
                        // ),
                        const SizedBox(
                          width: 10,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => const ReviewPage()));
                          },
                          child: Image.asset(
                            'assets/images/cart.png',
                            height: 20,
                            width: 20,
                          ),
                        ),
                        if (basketCount > 0)
                          Positioned(
                            right: 8,
                            top: 52,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              constraints: const BoxConstraints(
                                minWidth: 14,
                                minHeight: 14,
                              ),
                              child: Text(
                                '$basketCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
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
            Card(
              child: Container(
                width: 320,
                height: 160,
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: secondary),
                  borderRadius: BorderRadius.circular(
                    10,
                  ),
                  image: const DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(
                      'assets/images/Rectangle 38.png',
                    ),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(top: 10, right: 15),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.favorite,
                          color: Colors.white,
                          size: 35,
                        ),
                      ),
                    ),
                    Container(
                      width: double.infinity,
                      height: 36,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(
                            7.5,
                          ),
                          bottomRight: Radius.circular(
                            7.5,
                          ),
                        ),
                        color: secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            TextWidget(
                              text:
                                  merchants[0]['businessName'] ?? 'Loading...',
                              fontSize: 15,
                              fontFamily: 'Bold',
                              color: Colors.white,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: '4.5',
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Colors.white,
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                const Icon(
                                  Icons.star_rate_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (int i = 0; i < shopCategories.length; i++)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: shopCategories[i],
                        fontSize: 15,
                        fontFamily: 'Medium',
                        color: secondary,
                      ),
                      i == 0
                          ? const Icon(
                              Icons.circle,
                              color: secondary,
                              size: 15,
                            )
                          : const SizedBox(
                              height: 15,
                            ),
                    ],
                  ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            ...menuItems.map((item) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 3,
                        child: Container(
                          width: 100,
                          height: 112.5,
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              fit: BoxFit.cover,
                              image: NetworkImage(
                                item['imageUrl'] ?? '',
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
                          width: 210,
                          height: 112.5,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: secondary,
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 33,
                                decoration: const BoxDecoration(
                                  color: secondary,
                                  borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(
                                      7.5,
                                    ),
                                    topRight: Radius.circular(
                                      7.5,
                                    ),
                                  ),
                                ),
                                child: Center(
                                  child: TextWidget(
                                    text: item['name'] ??
                                        'Loading...', // Ensure the name field matches your database
                                    fontSize: 15,
                                    fontFamily: 'Bold',
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextWidget(
                                text: item['description'] ??
                                    'No description available', // Ensure the description field matches your database
                                fontSize: 12,
                                fontFamily: 'Medium',
                                color: Colors.black,
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextWidget(
                                      text:
                                          '₱ ${item['price']?.toString() ?? '0.00'}', // Ensure the price field matches your database
                                      fontSize: 12,
                                      fontFamily: 'Bold',
                                      color: secondary,
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        addToCart();
                                      },
                                      child: Row(
                                        children: [
                                          TextWidget(
                                            text: 'Add to Cart',
                                            fontSize: 12,
                                            fontFamily: 'Bold',
                                            color: secondary,
                                          ),
                                          const Icon(
                                            Icons.arrow_right_alt_outlined,
                                            color: secondary,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
