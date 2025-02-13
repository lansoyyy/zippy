import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat, toBeginningOfSentenceCase;
import 'package:zippy/screens/pages/shop_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final searchController = TextEditingController();
  String nameSearched = '';
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
                    const SizedBox(),
                    // GestureDetector(
                    //   onTap: () {
                    //     Navigator.of(context).push(
                    //       MaterialPageRoute(
                    //           builder: (context) => ReviewPage(
                    //                 basketCount: 0,
                    //                 selectedItems: const [],
                    //                 onUpdateCart: (p0) {},
                    //               )),
                    //     );
                    //   },
                    //   child: Row(
                    //     children: [
                    //       TextWidget(
                    //         text: 'Cart',
                    //         fontSize: 15,
                    //         color: secondary,
                    //         fontFamily: 'Medium',
                    //       ),
                    //       const SizedBox(
                    //         width: 10,
                    //       ),
                    //       Image.asset(
                    //         'assets/images/cart.png',
                    //         height: 20,
                    //         width: 20,
                    //       ),
                    //     ],
                    //   ),
                    // ),
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
                child: Row(
                  children: [
                    const Icon(Icons.search, color: Colors.black54),
                    const SizedBox(width: 8.0),
                    Expanded(
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            nameSearched = value;
                          });
                        },
                        controller: searchController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'What are you craving today?',
                            hintStyle: TextStyle(
                              fontFamily: 'Regular',
                              fontSize: 14,
                              color: Colors.black,
                            )),
                      ),
                    ),
                    // Icon(Icons.tune, color: Colors.black54),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     for (int i = 0; i < foodCategories.length; i++)
            //       Padding(
            //         padding: const EdgeInsets.only(left: 5, right: 5),
            //         child: Column(
            //           crossAxisAlignment: CrossAxisAlignment.center,
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             Container(
            //               decoration: BoxDecoration(
            //                 color: i == 0 ? secondary.withOpacity(0.3) : null,
            //                 shape: BoxShape.circle,
            //                 border: Border.all(
            //                   color: secondary,
            //                 ),
            //               ),
            //               child: Padding(
            //                 padding: const EdgeInsets.all(15.0),
            //                 child: Image.asset(
            //                   foodCategories[i],
            //                   width: 25,
            //                   height: 25,
            //                 ),
            //               ),
            //             ),
            //             const SizedBox(
            //               height: 10,
            //             ),
            //             TextWidget(
            //               text: foodCategoriesName[i],
            //               fontSize: 12,
            //               fontFamily: 'Medium',
            //               color: secondary,
            //             ),
            //           ],
            //         ),
            //       ),
            //   ],
            // ),
            // const SizedBox(
            //   height: 20,
            // ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Merchant')
                    .where('businessName',
                        isGreaterThanOrEqualTo:
                            toBeginningOfSentenceCase(nameSearched))
                    .where('businessName',
                        isLessThan:
                            '${toBeginningOfSentenceCase(nameSearched)}z')
                    .snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    return const Center(child: Text('Error'));
                  }
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: Center(
                          child: CircularProgressIndicator(
                        color: Colors.black,
                      )),
                    );
                  }

                  final data = snapshot.requireData;
                  return Column(
                    children: [
                      for (int i = 0; i < data.docs.length; i++)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: GestureDetector(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => ShopPage(
                                        merchantId: data.docs[i]['uid']),
                                  ),
                                );
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Card(
                                    elevation: 3,
                                    child: Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.35,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.35,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                            data.docs[i]['img'],
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
                                      width: MediaQuery.of(context).size.width *
                                          0.55,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              0.35,
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
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextWidget(
                                              text: data.docs[i]
                                                  ['businessName'],
                                              fontSize: 16,
                                              fontFamily: 'Bold',
                                            ),
                                            TextWidget(
                                              align: TextAlign.start,
                                              text: data.docs[i]['desc'],
                                              fontSize: 10,
                                              fontFamily: 'Regular',
                                            ),
                                            Wrap(
                                              children: [
                                                for (int j = 0;
                                                    j <
                                                        data
                                                            .docs[i]
                                                                ['categories']
                                                            .length;
                                                    j++)
                                                  TextWidget(
                                                    text: data.docs[i]
                                                            ['categories'][j] +
                                                        ' • ',
                                                    fontSize: 16,
                                                    align: TextAlign.start,
                                                    fontFamily: 'Bold',
                                                    color: secondary,
                                                  ),
                                              ],
                                            ),
                                            TextWidget(
                                              text: 'Price range ₱20',
                                              fontSize: 10,
                                              fontFamily: 'Regular',
                                            ),
                                            Align(
                                              alignment: Alignment.bottomRight,
                                              child: TextWidget(
                                                text:
                                                    '20% off first purchase. min ₱500',
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
                  );
                }),
          ],
        ),
      ),
    );
  }
}
