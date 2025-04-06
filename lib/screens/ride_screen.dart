import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/auth/login_screen.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/main_home_screen.dart';
import 'package:zippy/screens/pages/order/checkout_page.dart';
import 'package:zippy/screens/pages/order/location_picker_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/screens/purchase_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/utils/keys.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';
import 'package:google_maps_webservice/directions.dart' as directions;

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
  Set<Polyline> _polylines = {};
  final directions.GoogleMapsDirections _directionsService =
      directions.GoogleMapsDirections(apiKey: kGoogleApiKey);
  final PolylinePoints _polylinePoints = PolylinePoints();
  List<LatLng> _routeCoordinates = [];
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    getMyLocation();
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
          });
        } else {
          showToast('User data not found.');
        }
      });
    } catch (e) {
      print("Error fetching user data: $e");
      showToast('Error loading user data');
    }
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
          _bookButton(),
        ],
      ),
    );
  }

  Widget _bookButton() {
    return Visibility(
      visible: MediaQuery.of(context).viewInsets.bottom == 0,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.19,
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
                topLeft: Radius.circular(25), topRight: Radius.circular(25)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Padding(
                padding: EdgeInsets.only(
                    left: MediaQuery.of(context).size.width * 0.05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: 'Total: ',
                      fontSize: 23,
                      color: secondary,
                      fontFamily: "Bold",
                    ),
                    TextWidget(
                      text: '₱ ${_calculateDeliveryFee().toStringAsFixed(2)}',
                      fontSize: 25,
                      color: secondary,
                      fontFamily: "Bold",
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async {
                  // Check if locations are selected
                  if (pickupLocation == null || dropoffLocation == null) {
                    showToast('Please select pickup and drop-off locations');
                    return;
                  }

                  // Check if user is logged in
                  final user = FirebaseAuth.instance.currentUser;
                  if (userData == null || userId.isEmpty) {
                    showToast('Please login first');
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const LoginScreen()),
                    );
                    return;
                  }
                  if (userData == null) {
                    showToast('Loading user data, please wait...');
                    return;
                  }

                  try {
                    // Check for available drivers
                    final availableDriver = await FirebaseFirestore.instance
                        .collection('Riders')
                        .where('isActive', isEqualTo: true)
                        .limit(1)
                        .get();

                    if (availableDriver.docs.isEmpty) {
                      showToast('No drivers available at the moment');
                      return;
                    }
                    DocumentReference rideRef = await FirebaseFirestore.instance
                        .collection('Ride Bookings')
                        .add({
                      'customerName': userData!['name'] ?? 'Unknown',
                      'customerNumber': userData!['number'] ?? 'Unknown',
                      'date': DateTime.now(),
                      'pickupLocation': GeoPoint(
                          pickupLocation!.latitude, pickupLocation!.longitude),
                      'dropoffLocation': GeoPoint(dropoffLocation!.latitude,
                          dropoffLocation!.longitude),
                      'pickupLocationName': pickupLocationName,
                      'dropoffLocationName': dropoffLocationName,
                      'fare': _calculateDeliveryFee(),
                      'driverId': availableDriver.docs.first.id,
                      'driverName': availableDriver.docs.first['name'],
                      'driverContact': availableDriver.docs.first['number'],
                      'type': 'Ride',
                      'status': 'Pending',
                      'userId': userId,
                    });

                    showToast('Booking successful!');

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CheckoutPage(
                          data: {
                            'customerName': userData!['name'],
                            'customerNumber': userData!['number'],
                            'pickupLocationName': pickupLocationName,
                            'dropoffLocationName': dropoffLocationName,
                            'fare': _calculateDeliveryFee().toStringAsFixed(2),
                            'driverId': availableDriver.docs.first.id,
                            'driverName': availableDriver.docs.first['name'],
                            'driverContact':
                                availableDriver.docs.first['number'],
                            'type': 'Ride',
                            'status': 'Pending',
                            'orderId': rideRef.id,
                          },
                        ),
                      ),
                    );
                  } catch (e) {
                    print('Error creating booking: $e');
                    showToast('Error creating booking. Please try again.');
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 50,
                  height: MediaQuery.of(context).size.height * 0.07,
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
              ),
            ],
          ),
        ),
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
      polylines: _polylines,
    );
  }

  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    if (pickupLocation != null) {
      // markers.add(
      //   Marker(
      //     markerId: const MarkerId('pickup'),
      //     position: pickupLocation!,
      //     icon:
      //         BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
      //     infoWindow: InfoWindow(title: pickupLocationName),
      //   ),
      // );
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
    if (pickupLocation != null && dropoffLocation != null) {
      Polyline(
        polylineId: const PolylineId('route'),
        color: secondary,
        width: 5,
        points: [
          pickupLocation!,
          dropoffLocation!,
        ],
      );
    }

    return markers;
  }

  Future<void> _updatePolylines() async {
    if (pickupLocation == null || dropoffLocation == null) return;

    try {
      final response = await _directionsService.directionsWithLocation(
        directions.Location(
          lat: pickupLocation!.latitude,
          lng: pickupLocation!.longitude,
        ),
        directions.Location(
          lat: dropoffLocation!.latitude,
          lng: dropoffLocation!.longitude,
        ),
        travelMode: directions.TravelMode.driving,
      );

      if (response.isOkay && response.routes.isNotEmpty) {
        // Get the encoded polyline string
        final polylineString = response.routes.first.overviewPolyline.points;

        // Decode the polyline points
        final result = _polylinePoints.decodePolyline(polylineString);

        // Convert to LatLng list
        _routeCoordinates = result
            .map((point) => LatLng(point.latitude, point.longitude))
            .toList();

        setState(() {
          _polylines = {
            Polyline(
              polylineId: const PolylineId('route'),
              color: secondary,
              width: 5,
              points: _routeCoordinates,
              geodesic: false, // Set to false to follow roads
            ),
          };
        });

        // Adjust camera to show the entire route
        if (_routeCoordinates.isNotEmpty) {
          final controller = await _controller.future;
          controller.animateCamera(
            CameraUpdate.newLatLngBounds(
              _boundsFromLatLngList(_routeCoordinates),
              100, // padding
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error getting directions: $e');
      // Fallback to straight line if API fails
      setState(() {
        _polylines = {
          Polyline(
            polylineId: const PolylineId('route'),
            color: secondary,
            width: 5,
            points: [pickupLocation!, dropoffLocation!],
          ),
        };
      });
    }
  }

  LatLngBounds _boundsFromLatLngList(List<LatLng> list) {
    double? x0, x1, y0, y1;
    for (LatLng latLng in list) {
      if (x0 == null) {
        x0 = x1 = latLng.latitude;
        y0 = y1 = latLng.longitude;
      } else {
        if (latLng.latitude > x1!) x1 = latLng.latitude;
        if (latLng.latitude < x0) x0 = latLng.latitude;
        if (latLng.longitude > y1!) y1 = latLng.longitude;
        if (latLng.longitude < y0!) y0 = latLng.longitude;
      }
    }
    return LatLngBounds(
      northeast: LatLng(x1!, y1!),
      southwest: LatLng(x0!, y0!),
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
              _updatePolylines();
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
              TextWidget(
                text: 'From: ',
                fontSize: 14,
                color: black,
                fontFamily: "Bold",
              ),
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
              _updatePolylines();
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
              TextWidget(
                text: 'To: ',
                fontSize: 14,
                color: black,
                fontFamily: "Bold",
              ),
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

  double _calculateDeliveryFee() {
    if (pickupLocation == null || dropoffLocation == null) {
      return 0.0;
    }
    double distanceInMeters = Geolocator.distanceBetween(
      pickupLocation!.latitude,
      pickupLocation!.longitude,
      dropoffLocation!.latitude,
      dropoffLocation!.longitude,
    );
    double distanceInKm = distanceInMeters / 1000;
    return 50 + (distanceInKm * 15);
  }
}
