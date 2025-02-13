import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:zippy/screens/chats/chat_tab.dart';
import 'package:zippy/screens/pages/order/completed_page.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/utils/keys.dart';
import 'package:zippy/utils/my_location.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class CheckoutPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const CheckoutPage({super.key, required this.data});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map<String, dynamic>? userData;
  String? profileImage;
  bool hasLoaded = false;
  double mylat = 0;
  double mylng = 0;
  Set<Marker> markers = {};
  GoogleMapController? mapController;
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  late Polyline _polyline = const Polyline(polylineId: PolylineId('route'));
  List<LatLng> polylineCoordinates = [];
  final PolylinePoints polylinePoints = PolylinePoints();

  @override
  void initState() {
    super.initState();
    _initializeData();
  }

  @override
  void dispose() {
    mapController?.dispose();
    super.dispose();
  }

  void _initializeData() async {
    determinePosition();
    _plotPolylines();
    await _fetchUser();
    setState(() => hasLoaded = true);
  }

  Future<void> _fetchUser() async {
    try {
      FirebaseFirestore.instance
          .collection('Users')
          .doc(userId)
          .snapshots()
          .listen((docSnapshot) {
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

  void _plotPolylines() {
    Timer.periodic(const Duration(seconds: 10), (timer) async {
      final riderDoc = FirebaseFirestore.instance
          .collection('Riders')
          .doc(widget.data['riderId']);

      riderDoc.snapshots().listen((docSnapshot) async {
        if (docSnapshot.exists) {
          final data = docSnapshot.data() as Map<String, dynamic>;
          final position = await Geolocator.getCurrentPosition(
              locationSettings:
                  const LocationSettings(accuracy: LocationAccuracy.high));

          final result = await polylinePoints.getRouteBetweenCoordinates(
              kGoogleApiKey,
              PointLatLng(position.latitude, position.longitude),
              PointLatLng(data['lat'], data['lng']));

          if (result.points.isNotEmpty) {
            polylineCoordinates = result.points
                .map((point) => LatLng(point.latitude, point.longitude))
                .toList();
          }

          mapController?.animateCamera(CameraUpdate.newLatLngZoom(
              LatLng(data['lat'], data['lng']), 18.0));

          setState(() {
            markers.clear();
            _polyline = Polyline(
                color: Colors.red,
                polylineId: const PolylineId('route'),
                points: polylineCoordinates,
                width: 4);

            mylat = position.latitude;
            mylng = position.longitude;

            markers.add(Marker(
                draggable: true,
                icon: BitmapDescriptor.defaultMarker,
                markerId: const MarkerId("pickup"),
                position: LatLng(data['lat'], data['lng']),
                infoWindow: const InfoWindow(title: "Rider's Location")));
          });
        } else {
          showToast('Rider data not found.');
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: hasLoaded
          ? StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('Orders')
                  .doc(widget.data['orderId'])
                  .snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: Text('Loading'));
                } else if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                } else if (snapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final data = snapshot.data!.data() as Map<String, dynamic>;
                return _buildMainContent(data);
              },
            )
          : const Center(child: CircularProgressIndicator(color: secondary)),
    );
  }

  Widget _buildMainContent(Map<String, dynamic> data) {
    return Stack(
      children: [
        if (data['status'] == 'Preparing')
          Center(
              child: _buildLoadingDialog('assets/images/Group 121 (1).png',
                  'Preparing your Treats', '15 to 20 minutes'))
        else
          GoogleMap(
            polylines: {_polyline},
            zoomControlsEnabled: false,
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            markers: markers,
            initialCameraPosition:
                CameraPosition(target: LatLng(mylat, mylng), zoom: 14.4746),
            onMapCreated: (controller) {
              mapController = controller;
              _controller.complete(controller);
            },
          ),
        _buildTopSection(data),
        if (data['status'] == 'On the way') _buildBottomSection(),
      ],
    );
  }

  Widget _buildTopSection(Map<String, dynamic> data) {
    return Container(
      width: double.infinity,
      height: data['status'] == 'On the way' ? 200 : 280,
      decoration: const BoxDecoration(
          color: secondary,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40))),
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
                      text: data['status'] == 'On the way'
                          ? 'Awaiting delivery..'
                          : data['status'] == 'Preparing'
                              ? 'Awaiting order..'
                              : 'Order pending...',
                      fontSize: 22,
                      fontFamily: 'Bold',
                      color: Colors.white,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ProfilePage())),
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
          ),
          if (data['status'] == 'On the way')
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Center(
                child: ButtonWidget(
                  color: Colors.white,
                  textColor: secondary,
                  label: 'Order delivered',
                  onPressed: _showCompleteDialog,
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
              child: Column(
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 20),
                  _buildCravingOptions(),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
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
                    fontFamily: 'Regular', fontSize: 14, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCravingOptions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildCravingOption(Icons.fastfood_outlined, 'Food', true),
        _buildCravingOption(
            Icons.directions_car_filled_outlined, 'Ride', false),
        _buildCravingOption(Icons.card_giftcard, 'Surprise', false),
        _buildCravingOption(Icons.local_shipping_outlined, 'Package', false),
      ],
    );
  }

  Widget _buildCravingOption(IconData icon, String label, bool selected) {
    return Column(
      children: [
        Icon(icon, color: Colors.white),
        const SizedBox(height: 5.0),
        Text(label,
            style: const TextStyle(color: Colors.white, fontFamily: 'Medium')),
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

  Widget _buildBottomSection() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        width: double.infinity,
        height: 140,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(icon, height: 20, width: 20),
                      const SizedBox(width: 10),
                      TextWidget(
                          text: 'arriving in 20-30 minutes', fontSize: 12),
                    ],
                  ),
                  TextWidget(
                    text: 'Total: ₱${widget.data['total'].toStringAsFixed(2)}',
                    fontSize: 15,
                    fontFamily: 'Bold',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Riders')
                    .doc(widget.data['riderId'])
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Loading'));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final driverData =
                      snapshot.data!.data() as Map<String, dynamic>;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 3,
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(100)),
                        child: IconButton(
                          onPressed: () async => await launchUrlString(
                              'tel:${driverData['number']}'),
                          icon: const Icon(Icons.phone, color: secondary),
                        ),
                      ),
                      const SizedBox(width: 15),
                      GestureDetector(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              driverId: widget.data['riderId'],
                              driverName: driverData['number'],
                            ),
                          ),
                        ),
                        child: Container(
                          width: 240,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: secondary,
                            border: Border.all(color: secondary),
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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingDialog(String image, String caption, String duration) {
    return SizedBox(
      height: 320,
      width: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextWidget(
              text: 'Please wait...',
              fontSize: 20,
              fontFamily: 'Bold',
              color: secondary),
          const SizedBox(height: 10),
          Image.asset(image, height: 160, width: 160),
          const SizedBox(height: 10),
          TextWidget(
              text: caption,
              fontSize: 20,
              fontFamily: 'Bold',
              color: secondary),
          const SizedBox(height: 5),
          TextWidget(
              text: duration,
              fontSize: 15,
              fontFamily: 'Regular',
              color: secondary),
        ],
      ),
    );
  }

  void _showCompleteDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Complete Order Confirmation',
            style: TextStyle(fontFamily: 'QBold', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to complete your order?',
            style: TextStyle(fontFamily: 'QRegular')),
        actions: [
          MaterialButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Close',
                style: TextStyle(
                    fontFamily: 'QRegular', fontWeight: FontWeight.bold)),
          ),
          MaterialButton(
            onPressed: () => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(
                  builder: (context) => CompletedPage(data: widget.data)),
              (route) => false,
            ),
            child: const Text('Continue',
                style: TextStyle(
                    fontFamily: 'QRegular', fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
