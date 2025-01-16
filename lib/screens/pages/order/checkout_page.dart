import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/pages/order/completed_page.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class CheckoutPage extends StatefulWidget {
  Map data;
  CheckoutPage({
    super.key,
    required this.data,
  });

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Map<String, dynamic>? userData;
  String? profileImage;
  @override
  void initState() {
    // showDialogs();
    fetchUser();
    super.initState();
  }

  Future<void> fetchUser() async {
    try {
      DocumentReference userDoc =
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

  showDialogs() async {
    showLoadingDialog('assets/images/Group 121 (2).png',
        'Eyeing out for riders', '1 to 5 minutes');
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pop(context);
    await Future.delayed(const Duration(seconds: 2));
    showLoadingDialog('assets/images/Group 121 (1).png',
        'Preparing your Treats', '15 to 20 minutes');
    await Future.delayed(const Duration(seconds: 5));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: CheckoutPage._kGooglePlex,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
            ),
          ),
          Container(
            width: double.infinity,
            height: 265,
            decoration: const BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(
                  40,
                ),
                bottomRight: Radius.circular(
                  40,
                ),
              ),
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 15, right: 15),
                  child: SafeArea(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: 275,
                          child: TextWidget(
                            align: TextAlign.start,
                            text: 'Hi! ${userData!['name']}, Welcome Back!',
                            fontSize: 22,
                            fontFamily: 'Bold',
                            color: Colors.white,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            );
                          },
                          child: CircleAvatar(
                            maxRadius: 25,
                            minRadius: 25,
                            backgroundImage: profileImage != null
                                ? NetworkImage(profileImage!)
                                : const AssetImage(
                                        'assets/images/Group 121 (2).png')
                                    as ImageProvider,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => const SearchPage()),
                          );
                        },
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
                                      )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildCravingOption(
                              Icons.fastfood_outlined, 'Food', true),
                          _buildCravingOption(
                              Icons.directions_car_filled_outlined,
                              'Ride',
                              false),
                          _buildCravingOption(
                              Icons.card_giftcard, 'Surprise', false),
                          _buildCravingOption(
                              Icons.local_shipping_outlined, 'Package', false),
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: double.infinity,
              height: 140,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25)),
                color: Colors.white,
              ),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Image.asset(
                              icon,
                              height: 20,
                              width: 20,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            TextWidget(
                                text: 'arriving in 5-10 minutes', fontSize: 12),
                          ],
                        ),
                        TextWidget(
                          text: 'Total: ₱800',
                          fontSize: 15,
                          fontFamily: 'Bold',
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Card(
                          elevation: 3,
                          color: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.phone,
                                color: secondary,
                              )),
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => const CompletedPage()),
                            );
                          },
                          child: Container(
                            width: 240,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              color: secondary,
                              border: Border.all(
                                color: secondary,
                              ),
                            ),
                            child: Center(
                              child: TextWidget(
                                text: 'Open Chat',
                                fontSize: 20,
                                fontFamily: 'Bold',
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  showLoadingDialog(String image, String caption, String duration) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SizedBox(
            height: 320,
            width: 240,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                TextWidget(
                  text: 'Please wait...',
                  fontSize: 20,
                  fontFamily: 'Bold',
                  color: secondary,
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset(
                  image,
                  height: 160,
                  width: 160,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextWidget(
                  text: caption,
                  fontSize: 20,
                  fontFamily: 'Bold',
                  color: secondary,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: duration,
                  fontSize: 15,
                  fontFamily: 'Regular',
                  color: secondary,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Widget _buildCravingOption(IconData icon, String label, bool selected) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 5.0),
        Text(
          label,
          style: const TextStyle(color: Colors.white, fontFamily: 'Medium'),
        ),
        if (selected)
          Container(
            margin: const EdgeInsets.only(top: 4.0),
            height: 2.0,
            width: 40.0,
            color: Colors.white,
          ),
      ],
    );
  }
}
