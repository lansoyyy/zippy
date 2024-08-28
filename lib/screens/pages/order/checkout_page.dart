import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  void initState() {
    // TODO: implement initState

    showDialogs();

    super.initState();
  }

  showDialogs() async {
    showLoadingDialog('assets/images/Group 121.png', 'Eyeing out for riders',
        '1 to 5 minutes');
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
