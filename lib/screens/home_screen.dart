import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';

import 'pages/shop_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Expanded(
            child: GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: HomeScreen._kGooglePlex,
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
                        TextWidget(
                          text: 'Hi! Paula, Welcome Back!',
                          fontSize: 22,
                          fontFamily: 'Bold',
                          color: Colors.white,
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => const ProfilePage()),
                            );
                          },
                          child: const CircleAvatar(
                            maxRadius: 25,
                            minRadius: 25,
                            backgroundImage: AssetImage(
                              'assets/images/sample_avatar.png',
                            ),
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
          Padding(
            padding: const EdgeInsets.only(bottom: 30, left: 25, right: 25),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 30,
                    width: 100,
                    decoration: BoxDecoration(
                      color: secondary,
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Center(
                      child: TextWidget(
                        text: 'Featured',
                        fontSize: 15,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        for (int i = 0; i < 5; i++)
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                      builder: (context) => const ShopPage()),
                                );
                              },
                              child: Container(
                                width: 265,
                                height: 86,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    15,
                                  ),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15, right: 15),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        width: 64,
                                        height: 60,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                            fit: BoxFit.cover,
                                            image: AssetImage(
                                              'assets/images/Rectangle 2.png',
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 15,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          TextWidget(
                                            text: 'Bluebird Coffee',
                                            fontSize: 20,
                                            fontFamily: 'Bold',
                                          ),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.location_on_sharp,
                                                color: secondary,
                                                size: 15,
                                              ),
                                              TextWidget(
                                                text: '10 mtr Left',
                                                fontSize: 12,
                                                fontFamily: 'Medium',
                                                color: Colors.grey,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
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
