import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/main_home_screen.dart';
import 'package:zippy/screens/pages/order/location_picker_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/screens/purchase_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class RideScreen extends StatefulWidget {
  const RideScreen({super.key});

  @override
  State<RideScreen> createState() => _RideScreenState();
}

class _RideScreenState extends State<RideScreen> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  LatLng? pickupLocation;
  LatLng? dropoffLocation;
  String pickupLocationName = 'Pickup Location';
  String dropoffLocationName = 'Drop off Location';

  @override
  void initState() {
    super.initState();
    getMyLocation();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildGoogleMap(),
          _buildTopSection(),
          Visibility(
            visible: MediaQuery.of(context).viewInsets.bottom == 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: 100,
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

  Widget _buildGoogleMap() {
    return GoogleMap(
      zoomControlsEnabled: false,
      mapType: MapType.normal,
      myLocationButtonEnabled: true,
      compassEnabled: false,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.32),
      myLocationEnabled: true,
      initialCameraPosition:
          CameraPosition(target: LatLng(mylat, mylng), zoom: 14.0),
      onMapCreated: (controller) => _controller.complete(controller),
      markers: _buildMarkers(),
    );
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: pickupLocation!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: InfoWindow(title: pickupLocationName),
        ),
      );
    }

    if (dropoffLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('dropoff'),
          position: dropoffLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(title: dropoffLocationName),
        ),
      );
    }

    return markers;
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
          const SizedBox(height: 20),
          _pickUpLocation(),
          _dropOffLocation(),
          const SizedBox(height: 20),
          _buildCravingOptions(),
        ],
      ),
    );
  }

  Widget _pickUpLocation() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).push<Map<String, dynamic>>(
            MaterialPageRoute(
              builder: (context) => LocationPickerScreen(
                initialLatLng: pickupLocation,
                initialLocationName: pickupLocationName,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              pickupLocation = result['location'];
              pickupLocationName = result['name'];
            });
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.black54),
              const SizedBox(width: 8.0),
              Expanded(
                  child: TextWidget(
                align: TextAlign.start,
                text: pickupLocationName,
                fontSize: 14,
                color: black,
                fontFamily: "Regular",
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _dropOffLocation() {
    return Padding(
      padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
      child: GestureDetector(
        onTap: () async {
          final result = await Navigator.of(context).push<Map<String, dynamic>>(
            MaterialPageRoute(
              builder: (context) => LocationPickerScreen(
                initialLatLng: dropoffLocation,
                initialLocationName: dropoffLocationName,
              ),
            ),
          );

          if (result != null) {
            setState(() {
              dropoffLocation = result['location'];
              dropoffLocationName = result['name'];
            });
          }
        },
        child: Container(
          height: MediaQuery.of(context).size.height * 0.06,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(5.0),
          ),
          child: Row(
            children: [
              const Icon(Icons.location_on_rounded, color: Colors.black54),
              const SizedBox(width: 8.0),
              Expanded(
                child: Text(
                  dropoffLocationName,
                  style: const TextStyle(
                    fontFamily: 'Regular',
                    fontSize: 14,
                    color: Colors.black,
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
            _buildCravingOption(Icons.fastfood_outlined, 'Food', false,
                onTap: () => Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                        builder: (context) => const HomeScreen()))),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(
              Icons.shopping_cart,
              'Purchase',
              false,
              onTap: () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                      builder: (context) => const PurchaseScreen())),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(
                Icons.directions_car_filled_outlined, 'Ride', true,
                onTap: () => showToast('Coming soon.')),
            SizedBox(
              width: MediaQuery.of(context).size.height * 0.07,
            ),
            _buildCravingOption(Icons.card_giftcard, 'Surprise', false,
                onTap: () => showToast('Coming soon.')),
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
  // ... rest of your existing methods (_buildCravingOptions, _buildCravingOption) ...
}
