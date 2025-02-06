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
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Map<String, dynamic>? userData;
  String? profileImage;
  @override
  void initState() {
    // showDialogs();

    super.initState();
    determinePosition();
    plotPloylines();
    fetchUser().whenComplete(
      () {
        setState(() {
          hasLoaded = true;
        });
      },
    );
  }

  @override
  void dispose() {
    mapController!.dispose();
    super.dispose();
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

    await Future.delayed(const Duration(seconds: 5));
    Navigator.pop(context);
  }

  late Polyline _poly = const Polyline(polylineId: PolylineId('new'));

  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();

  plotPloylines() async {
    Timer.periodic(
      const Duration(seconds: 10),
      (timer) async {
        DocumentReference userDoc = FirebaseFirestore.instance
            .collection('Riders')
            .doc(widget.data['riderId']);

        userDoc.snapshots().listen((docSnapshot) async {
          if (docSnapshot.exists) {
            final data = docSnapshot.data() as Map<String, dynamic>;
            await Geolocator.getCurrentPosition(
                locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.high,
            )).then(
              (value) async {
                PolylineResult result =
                    await polylinePoints.getRouteBetweenCoordinates(
                        kGoogleApiKey,
                        PointLatLng(value.latitude, value.longitude),
                        PointLatLng(data['lat'], data['lng']));
                if (result.points.isNotEmpty) {
                  polylineCoordinates = result.points
                      .map((point) => LatLng(point.latitude, point.longitude))
                      .toList();
                }

                mapController!.animateCamera(CameraUpdate.newLatLngZoom(
                    LatLng(data['lat'], data['lng']), 18.0));
                setState(() {
                  markers.clear();
                  _poly = Polyline(
                      color: Colors.red,
                      polylineId: const PolylineId('route'),
                      points: polylineCoordinates,
                      width: 4);

                  mylat = value.latitude;
                  mylng = value.longitude;

                  markers.add(Marker(
                      draggable: true,
                      icon: BitmapDescriptor.defaultMarker,
                      markerId: const MarkerId("pickup"),
                      position: LatLng(data['lat'], data['lng']),
                      infoWindow: const InfoWindow(title: "Rider's Location")));
                });
              },
            );
          } else {
            showToast('User data not found.');
          }
        });
      },
    );
  }

  double mylat = 0;
  double mylng = 0;

  bool hasLoaded = false;

  Set<Marker> markers = {};

  GoogleMapController? mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: hasLoaded
            ? StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('Orders')
                    .doc(widget.data['orderId'])
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(child: Text('Loading'));
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Something went wrong'));
                  } else if (snapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  dynamic data = snapshot.data;

                  if (data['status'] == 'Preparing') {
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        showLoadingDialog('assets/images/Group 121 (1).png',
                            'Preparing your Treats', '15 to 20 minutes');
                      },
                    );
                  } else if (data['status'] == 'On the way') {
                    Navigator.pop(context);
                    WidgetsBinding.instance.addPostFrameCallback(
                      (timeStamp) {
                        showLoadingDialog(
                            'assets/images/Group 121 (2).png',
                            'Rider is ongoing on your location',
                            '5 to 15 minutes');
                      },
                    );
                  }

                  return Stack(
                    children: [
                      Expanded(
                        child: GoogleMap(
                          polylines: {_poly},
                          zoomControlsEnabled: false,
                          mapType: MapType.normal,
                          myLocationButtonEnabled: true,
                          myLocationEnabled: true,
                          markers: markers,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(mylat, mylng),
                            zoom: 14.4746,
                          ),
                          onMapCreated: (GoogleMapController controller) {
                            mapController = controller;
                            _controller.complete(controller);
                          },
                        ),
                      ),
                      Container(
                        width: double.infinity,
                        height: 280,
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
                              padding: const EdgeInsets.only(
                                  top: 25, left: 15, right: 15),
                              child: SafeArea(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: 275,
                                      child: TextWidget(
                                        align: TextAlign.start,
                                        text:
                                            'Hi! ${userData!['name']}, Welcome Back!',
                                        fontSize: 22,
                                        fontFamily: 'Bold',
                                        color: Colors.white,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const ProfilePage()),
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
                              padding: const EdgeInsets.only(
                                  left: 15, right: 15, top: 15),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      showComplete();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16.0),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                      child: const Row(
                                        children: [
                                          Icon(Icons.search,
                                              color: Colors.black54),
                                          SizedBox(width: 8.0),
                                          Expanded(
                                            child: TextField(
                                              enabled: false,
                                              decoration: InputDecoration(
                                                  border: InputBorder.none,
                                                  hintText:
                                                      'What are you craving today?',
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
                                  GestureDetector(
                                    onTap: () {
                                      showComplete();
                                    },
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        _buildCravingOption(
                                            Icons.fastfood_outlined,
                                            'Food',
                                            true),
                                        _buildCravingOption(
                                            Icons
                                                .directions_car_filled_outlined,
                                            'Ride',
                                            false),
                                        _buildCravingOption(Icons.card_giftcard,
                                            'Surprise', false),
                                        _buildCravingOption(
                                            Icons.local_shipping_outlined,
                                            'Package',
                                            false),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Visibility(
                        visible: data['status'] == 'On the way',
                        child: Align(
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                              text: 'arriving in 20-30 minutes',
                                              fontSize: 12),
                                        ],
                                      ),
                                      TextWidget(
                                        text:
                                            'Total: ₱${widget.data['total'].toStringAsFixed(2)}',
                                        fontSize: 15,
                                        fontFamily: 'Bold',
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  StreamBuilder<DocumentSnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('Riders')
                                          .doc(widget.data['riderId'])
                                          .snapshots(),
                                      builder: (context,
                                          AsyncSnapshot<DocumentSnapshot>
                                              snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                              child: Text('Loading'));
                                        } else if (snapshot.hasError) {
                                          return const Center(
                                              child:
                                                  Text('Something went wrong'));
                                        } else if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                              child:
                                                  CircularProgressIndicator());
                                        }
                                        dynamic driverData = snapshot.data;
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Card(
                                              elevation: 3,
                                              color: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100),
                                              ),
                                              child: IconButton(
                                                  onPressed: () async {
                                                    await launchUrlString(
                                                        'tel:${driverData['number']}');
                                                  },
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
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatPage(
                                                            driverId:
                                                                widget.data[
                                                                    'riderId'],
                                                            driverName:
                                                                driverData[
                                                                    'number'],
                                                          )),
                                                );
                                              },
                                              child: Container(
                                                width: 240,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
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
                                        );
                                      }),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                })
            : const Center(
                child: CircularProgressIndicator(
                  color: secondary,
                ),
              ));
  }

  showLoadingDialog(String image, String caption, String duration) {
    showDialog(
      context: context,
      barrierDismissible: false,
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

  showComplete() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text(
                'Complete Order Confirmation',
                style:
                    TextStyle(fontFamily: 'QBold', fontWeight: FontWeight.bold),
              ),
              content: const Text(
                'Are you sure you want to complete your order?',
                style: TextStyle(fontFamily: 'QRegular'),
              ),
              actions: <Widget>[
                MaterialButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                        fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Navigator.of(context).pushReplacement(
                      MaterialPageRoute(
                          builder: (context) => CompletedPage(
                                data: widget.data,
                              )),
                    );
                  },
                  child: const Text(
                    'Continue',
                    style: TextStyle(
                        fontFamily: 'QRegular', fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ));
  }
}
