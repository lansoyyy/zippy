import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({super.key});

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

class _PurchaseScreenState extends State<PurchaseScreen> {
  Map<String, dynamic>? userData;
  String? profileImage;
  bool hasLoaded = true;
  bool isNowSelected = true;
  final namecontroller = TextEditingController();
  final mobileNumber = TextEditingController();
  final address = TextEditingController();
  final typesOfPurchase = TextEditingController();
  final deliveryAddress = TextEditingController();
  final riderNoteController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _fetchUser();
  }

  Future<void> _fetchUser() async {
    try {
      final userDoc =
          FirebaseFirestore.instance.collection('Users').doc(userId);
      userDoc.snapshots().listen((docSnapshot) {
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          setState(() {
            userData = data;
            profileImage = data['profile'];
          });
        } else {
          showToast('User data not found.');
        }
      });
    } catch (e) {
      print("Error fetching user data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                _buildTopSection(),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.only(bottom: 15),
                  height: MediaQuery.of(context).size.height * 0.55,
                  width: MediaQuery.of(context).size.width - 20,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: black),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              const SizedBox(height: 15),
                              TextWidget(
                                text: 'Welcome to Zippy Purchase!',
                                fontSize: 18,
                                color: secondary,
                                fontFamily: "Bold",
                              ),
                              TextWidget(
                                text:
                                    'Groceries, Medicine, and other need? \n Zippy can do it for you',
                                fontSize: 12,
                                color: Colors.black,
                                fontFamily: "Bold",
                              ),
                              const SizedBox(height: 10),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isNowSelected = !isNowSelected;
                                  });
                                },
                                child: Container(
                                  width: 200,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    border:
                                        Border.all(color: secondary, width: 2),
                                  ),
                                  child: Stack(
                                    children: [
                                      AnimatedAlign(
                                        alignment: isNowSelected
                                            ? Alignment.centerLeft
                                            : Alignment.centerRight,
                                        duration:
                                            const Duration(milliseconds: 300),
                                        child: Container(
                                          width: 100,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: secondary,
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Center(
                                              child: TextWidget(
                                                  text: 'reserve',
                                                  fontSize: 15,
                                                  fontFamily: "Medium",
                                                  color: isNowSelected
                                                      ? Colors.white
                                                      : secondary),
                                            ),
                                          ),
                                          Expanded(
                                            child: Center(
                                              child: TextWidget(
                                                  text: 'reserve',
                                                  fontSize: 15,
                                                  fontFamily: "Medium",
                                                  color: isNowSelected
                                                      ? secondary
                                                      : Colors.white),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // TextWidget(
                                        //   text: 'Name of Recipient',
                                        //   fontSize: 12,
                                        //   fontFamily: "Medium",
                                        // ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: black, width: 1.5),
                                          ),
                                          child: TextFieldWidget(
                                              height: 55,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              radius: 10,
                                              color: secondary,
                                              label: 'Name of Recipient',
                                              fontSize: 14,
                                              controller: namecontroller),
                                        ),
                                        const SizedBox(height: 10),
                                        // TextWidget(
                                        //   text: 'Mobile Number',
                                        //   fontSize: 12,
                                        //   fontFamily: "Medium",
                                        // ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: black, width: 1.5),
                                          ),
                                          child: TextFieldWidget(
                                              height: 55,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              radius: 10,
                                              color: secondary,
                                              label: 'Mobile Number',
                                              fontSize: 14,
                                              controller: mobileNumber),
                                        ),
                                        const SizedBox(height: 10),
                                        // TextWidget(
                                        //   text: 'Address',
                                        //   fontSize: 12,
                                        //   fontFamily: "Medium",
                                        // ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: black, width: 1.5),
                                          ),
                                          child: TextFieldWidget(
                                              height: 55,
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              radius: 10,
                                              color: secondary,
                                              label: 'Address',
                                              fontSize: 14,
                                              controller: address),
                                        ),
                                        const SizedBox(height: 10),
                                        // TextWidget(
                                        //   text: 'Types of Purchase',
                                        //   fontSize: 12,
                                        //   fontFamily: "Medium",
                                        // ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                55,
                                            child:
                                                DropdownButtonFormField<String>(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              value:
                                                  typesOfPurchase.text.isEmpty
                                                      ? null
                                                      : typesOfPurchase.text,
                                              items: [
                                                'Grocery',
                                                'Market',
                                                'Medicine',
                                                'Pet Shop',
                                                'Household',
                                                'Others',
                                              ]
                                                  .map((label) =>
                                                      DropdownMenuItem(
                                                        value: label,
                                                        child: TextWidget(
                                                          text: label,
                                                          fontSize: 15,
                                                          color: secondary,
                                                          fontFamily: 'Medium',
                                                        ),
                                                      ))
                                                  .toList(),
                                              hint: TextWidget(
                                                text: 'Types of Purchase',
                                                fontSize: 12,
                                                color: secondary,
                                              ),
                                              onChanged: (value) {
                                                setState(() {
                                                  typesOfPurchase.text = value!;
                                                });
                                              },
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  borderSide: BorderSide(
                                                      color: black, width: 1.5),
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: black, width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      color: black, width: 1.5),
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                ),
                                              ),
                                              validator: (value) {
                                                if (value == null ||
                                                    value.isEmpty) {
                                                  return 'Please select types of purchase.';
                                                }
                                                return null;
                                              },
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        // TextWidget(
                                        //   text: 'Drop-off Address',
                                        //   fontSize: 12,
                                        //   fontFamily: "Medium",
                                        // ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: black, width: 1.5),
                                            ),
                                            child: TextFieldWidget(
                                                height: 55,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                radius: 10,
                                                color: secondary,
                                                label: 'Delivery Address',
                                                fontSize: 14,
                                                controller: deliveryAddress),
                                          ),
                                        ),
                                        const SizedBox(height: 10),
                                        TextWidget(
                                          text: 'List of Items',
                                          fontSize: 12,
                                          fontFamily: "Medium",
                                        ),
                                        Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              55,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                                color: black, width: 1.5),
                                          ),
                                          child: TextFieldWidget(
                                              label: '',
                                              controller: namecontroller),
                                        ),
                                        const SizedBox(height: 10),
                                        // TextWidget(
                                        //   text: 'Note to rider',
                                        //   fontSize: 12,
                                        //   fontFamily: "Medium",
                                        // ),
                                        Material(
                                          borderRadius:
                                              BorderRadius.circular(5),
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                55,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: black, width: 1.5),
                                            ),
                                            child: TextFieldWidget(
                                                height: 55,
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                radius: 10,
                                                color: secondary,
                                                label: 'Note to rider',
                                                fontSize: 14,
                                                controller:
                                                    riderNoteController),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 112,
                decoration: const BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey,
                      blurRadius: 10,
                      spreadRadius: 1,
                      offset: Offset(0, 0),
                    )
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25),
                      topRight: Radius.circular(25)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 50,
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: secondary,
                        border: Border.all(color: secondary),
                      ),
                      child: Center(
                        child: TextWidget(
                          text: 'BOOK',
                          fontSize: 23,
                          color: Colors.white,
                          fontFamily: "Bold",
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Container(
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.32,
      decoration: const BoxDecoration(
        color: secondary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(40),
          bottomRight: Radius.circular(40),
        ),
      ),
      child: Column(
        children: [
          _buildAppBar(),
          _buildSearchBar(),
          const SizedBox(height: 20),
          _buildCravingOptions(),
        ],
      ),
    );
  }

  Widget _buildCravingOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCravingOption(
          Icons.fastfood_outlined,
          'Food',
          false,
          onTap: () => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen())),
        ),
        _buildCravingOption(
          Icons.production_quantity_limits_sharp,
          'Purchase',
          true,
        ),
        _buildCravingOption(Icons.directions_car_filled_outlined, 'Ride', false,
            onTap: () => showToast('Coming soon.')),
        _buildCravingOption(Icons.card_giftcard, 'Surprise', false,
            onTap: () => showToast('Coming soon.')),
        _buildCravingOption(Icons.local_shipping_outlined, 'Package', false,
            onTap: () => showToast('Coming soon.')),
      ],
    );
  }

  Widget _buildCravingOption(IconData icon, String label, bool selected,
      {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 5.0),
          Text(label,
              style:
                  const TextStyle(color: Colors.white, fontFamily: 'Medium')),
          if (selected)
            Container(
              margin: const EdgeInsets.only(top: 4.0),
              height: 2.0,
              width: 40.0,
              color: Colors.white,
            ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 275,
              child: TextWidget(
                align: TextAlign.start,
                text:
                    'Hi! ${'${userData?['name'].toString().split(' ')[0]}' ?? 'User'}, Welcome Back!',
                fontSize: 22,
                fontFamily: 'Bold',
                color: Colors.white,
              ),
            ),
            GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const ProfilePage()),
              ),
              child: CircleAvatar(
                maxRadius: 25,
                minRadius: 25,
                backgroundImage: profileImage != null
                    ? NetworkImage(profileImage!)
                    : const AssetImage('assets/images/Group 121 (2).png')
                        as ImageProvider,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => const SearchPage()),
        ),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: const Row(
            children: [
              Icon(Icons.search, color: Colors.black54),
              SizedBox(width: 8.0),
              Expanded(
                child: TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'What are you craving today?',
                    hintStyle: TextStyle(
                      fontFamily: 'Regular',
                      fontSize: 14,
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
