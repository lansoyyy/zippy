import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/main_home_screen.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/screens/pages/shop_page.dart';
import 'package:zippy/screens/purchase_screen.dart';
import 'package:zippy/screens/ride_screen.dart';
import 'package:zippy/screens/surprise_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/utils/my_location.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Map<String, dynamic>> merchants = [];
  Map<String, dynamic>? userData;
  String? profileImage;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  bool isLocationLoaded = false;
  GoogleMapController? mapController;

  @override
  void initState() {
    super.initState();
    _fetchMerchants();
    _fetchUser();
    _initializeLocation();
    getMyLocation();
  }

  // void _initializeData() async {
  //   await _fetchMerchants();
  //   await _fetchUser();
  //   await determinePosition();
  //   await getMyLocation();
  //   setState(() => hasLoaded = true);
  // }

  Future<void> _initializeLocation() async {
    await getMyLocation();
    setState(() {
      isLocationLoaded = true;
    });
  }

  Future getMyLocation() async {
    final position = await Geolocator.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.high));

    setState(() {
      mylat = position.latitude;
      mylng = position.longitude;
    });
  }

  double mylat = 0;
  double mylng = 0;

  Future<void> _fetchMerchants() async {
    final merchantsCollection =
        FirebaseFirestore.instance.collection('Merchant');
    final querySnapshot =
        await merchantsCollection.where('type', isEqualTo: 'Food').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    setState(() => merchants = allData);
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
        _buildGoogleMap(),
        _buildTopSection(),
        _buildFeaturedMerchants(),
      ],
    ));
  }

  Widget _buildGoogleMap() {
    if (!isLocationLoaded) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      myLocationEnabled: true,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.32),
      initialCameraPosition: CameraPosition(
        target: LatLng(mylat, mylng),
        zoom: 14.4746,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        mapController = controller;
      },
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

  Widget _buildCravingOptions() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildCravingOption(Icons.fastfood_outlined, 'Food', true),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(Icons.shopping_cart, 'Purchase', false,
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const PurchaseScreen()))),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(
                Icons.directions_car_filled_outlined, 'Ride', false,
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const RideScreen()))),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(Icons.card_giftcard, 'Surprise', false,
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const SurpriseScreen()))),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(Icons.local_shipping_outlined, 'Package', false,
                onTap: () => showToast('Coming soon.')),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(Icons.more_horiz_rounded, 'Others', false,
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const MainHomeScreen()))),
          ],
        ),
      ),
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

  Widget _buildFeaturedMerchants() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 30, left: 25, right: 25),
      child: Align(
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildFeaturedLabel(),
            const SizedBox(height: 10),
            _buildMerchantList(),
          ],
        ),
      ),
    );
  }

  Widget _buildFeaturedLabel() {
    return Container(
      height: 40,
      width: 110,
      padding: const EdgeInsets.all(5),
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
    );
  }

  Widget _buildMerchantList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: merchants.map((merchant) {
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => ShopPage(merchantId: merchant['uid']),
                ),
              ),
              child: Container(
                width: 265,
                height: MediaQuery.of(context).size.height * 0.13,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildMerchantImage(merchant['img']),
                      const SizedBox(width: 15),
                      _buildMerchantDetails(merchant),
                    ],
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildMerchantImage(String imageUrl) {
    return Container(
      width: 64,
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(imageUrl),
        ),
      ),
    );
  }

  Widget _buildMerchantDetails(Map<String, dynamic> merchant) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 150,
          child: TextWidget(
            align: TextAlign.start,
            text: merchant['businessName'] ?? 'Unknown',
            fontSize: 20,
            fontFamily: 'Bold',
          ),
        ),
        Row(
          children: [
            const Icon(Icons.location_on_sharp, color: secondary, size: 15),
            const SizedBox(width: 5),
            SizedBox(
              width: 100,
              child: TextWidget(
                align: TextAlign.start,
                text: merchant['address'] ?? 'No address provided',
                fontSize: 12,
                fontFamily: 'Medium',
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
