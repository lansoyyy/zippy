import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/screens/main_home_screen.dart';
import 'package:zippy/screens/pages/order/checkout_page.dart';
import 'package:zippy/screens/pages/profile_page.dart';
import 'package:zippy/screens/pages/search_page.dart';
import 'package:zippy/screens/ride_screen.dart';
import 'package:zippy/screens/surprise_screen.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/utils/keys.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';
import 'package:google_maps_webservice/places.dart' as location;
import 'dart:async';
import 'package:google_api_headers/google_api_headers.dart';

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
  final itemsController = TextEditingController();
  final selectedDate = TextEditingController();
  final selectedTime = TextEditingController();
  final deliveryOfferController = TextEditingController();
  var deliveryLat = 0.0;
  var deliveryLng = 0.0;

  @override
  void initState() {
    super.initState();

    _fetchUser();
  }

  DateTime? selectedDateAndTime;

  void updateSelectedDateAndTime() {
    if (selectedDate.text.isNotEmpty && selectedTime.text.isNotEmpty) {
      // Parse the selected date
      final dateParts = selectedDate.text.split('-');
      final year = int.parse(dateParts[0]);
      final month = int.parse(dateParts[1]);
      final day = int.parse(dateParts[2]);

      // Parse the selected time
      final timeParts = selectedTime.text.split(' ');
      final time = timeParts[0].split(':');
      final hour = int.parse(time[0]) + (timeParts[1] == 'PM' ? 12 : 0);
      final minute = int.parse(time[1]);

      // Create a DateTime object
      selectedDateAndTime = DateTime(year, month, day, hour, minute);
    } else {
      selectedDateAndTime = null;
    }
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
                  padding: const EdgeInsets.only(bottom: 20),
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
                                  width: MediaQuery.of(context).size.width - 70,
                                  height: 55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
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
                                            const Duration(milliseconds: 150),
                                        child: Container(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              250,
                                          height: 55,
                                          decoration: BoxDecoration(
                                            color: secondary,
                                            borderRadius:
                                                BorderRadius.circular(5),
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
                                                  text: 'now',
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
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  if (!isNowSelected)
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25, right: 25),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                DateTime? pickedDate =
                                                    await showDatePicker(
                                                  context: context,
                                                  initialDate: DateTime.now(),
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime(2101),
                                                );
                                                if (pickedDate != null) {
                                                  setState(() {
                                                    selectedDate.text =
                                                        "${pickedDate.toLocal()}"
                                                            .split(' ')[0];
                                                    // Update the combined date and time field
                                                    updateSelectedDateAndTime();
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  border:
                                                      Border.all(color: black),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      text: selectedDate
                                                              .text.isEmpty
                                                          ? 'Select Date'
                                                          : selectedDate.text,
                                                      fontSize: 14,
                                                      color: secondary,
                                                      fontFamily: "Medium",
                                                    ),
                                                    const Icon(
                                                        Icons.calendar_today,
                                                        color: secondary),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          Expanded(
                                            child: GestureDetector(
                                              onTap: () async {
                                                TimeOfDay? pickedTime =
                                                    await showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now(),
                                                );
                                                if (pickedTime != null) {
                                                  setState(() {
                                                    selectedTime.text =
                                                        pickedTime
                                                            .format(context);
                                                    // Update the combined date and time field
                                                    updateSelectedDateAndTime();
                                                  });
                                                }
                                              },
                                              child: Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 15,
                                                        horizontal: 10),
                                                decoration: BoxDecoration(
                                                  border:
                                                      Border.all(color: black),
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    TextWidget(
                                                      text: selectedTime
                                                              .text.isEmpty
                                                          ? 'Select Time'
                                                          : selectedTime.text,
                                                      fontSize: 14,
                                                      color: secondary,
                                                      fontFamily: "Medium",
                                                    ),
                                                    const Icon(
                                                        Icons.access_time,
                                                        color: secondary),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  TextFieldWidget(
                                    textCapitalization:
                                        TextCapitalization.words,
                                    borderColor: black,
                                    height: 55,
                                    width: MediaQuery.of(context).size.width,
                                    radius: 10,
                                    color: secondary,
                                    label: 'Name of Recipient',
                                    fontSize: 14,
                                    onChanged: (value) {
                                      setState(() {
                                        namecontroller.text = value;
                                      });
                                    },
                                    controller: namecontroller,
                                  ),
                                  // Container(
                                  //   width: MediaQuery.of(context)
                                  //           .size
                                  //           .width -
                                  //       55,
                                  //   decoration: BoxDecoration(
                                  //     borderRadius:
                                  //         BorderRadius.circular(5),
                                  //     border: Border.all(
                                  //         color: black, width: 1.5),
                                  //   ),
                                  //   child: TextFieldWidget(
                                  //     height: 55,
                                  //     width: MediaQuery.of(context)
                                  //         .size
                                  //         .width,
                                  //     radius: 10,
                                  //     color: secondary,
                                  //     label: 'Name of Recipient',
                                  //     fontSize: 14,
                                  //     onChanged: (value) {
                                  //       setState(() {
                                  //         namecontroller.text = value;
                                  //       });
                                  //     },
                                  //     controller: namecontroller,
                                  //   ),
                                  // ),
                                  TextFieldWidget(
                                      borderColor: black,
                                      inputType: TextInputType.number,
                                      length: 11,
                                      height: 55,
                                      width: MediaQuery.of(context).size.width,
                                      radius: 10,
                                      color: secondary,
                                      label: 'Mobile Number',
                                      fontSize: 14,
                                      controller: mobileNumber),
                                  TextFieldWidget(
                                    borderColor: black,
                                    height: 55,
                                    width: MediaQuery.of(context).size.width,
                                    radius: 10,
                                    color: secondary,
                                    label: 'Delivery Address',
                                    fontSize: 14,
                                    controller: deliveryAddress,
                                    suffix: IconButton(
                                      onPressed: () async {
                                        location.Prediction? p =
                                            await PlacesAutocomplete.show(
                                          mode: Mode.overlay,
                                          context: context,
                                          apiKey: kGoogleApiKey,
                                          language: 'en',
                                          strictbounds: false,
                                          types: [""],
                                          decoration: InputDecoration(
                                            hintText: 'Search Address',
                                            focusedBorder: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              borderSide: const BorderSide(
                                                  color: Colors.white),
                                            ),
                                          ),
                                          components: [
                                            location.Component(
                                                location.Component.country,
                                                "ph")
                                          ],
                                        );

                                        if (p != null) {
                                          location.GoogleMapsPlaces places =
                                              location.GoogleMapsPlaces(
                                            apiKey: kGoogleApiKey,
                                            apiHeaders:
                                                await const GoogleApiHeaders()
                                                    .getHeaders(),
                                          );

                                          location.PlacesDetailsResponse
                                              detail =
                                              await places.getDetailsByPlaceId(
                                                  p.placeId!);

                                          // Extract latitude and longitude from the details
                                          final double deliveryLat = detail
                                              .result.geometry!.location.lat;
                                          final double deliveryLng = detail
                                              .result.geometry!.location.lng;

                                          setState(() {
                                            deliveryAddress.text =
                                                detail.result.name;
                                            this.deliveryLat = deliveryLat;
                                            this.deliveryLng = deliveryLng;
                                          });
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.location_on,
                                        color: secondary,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25, right: 25),
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      child: DropdownButtonFormField<String>(
                                        // borderRadius: BorderRadius.circular(5),
                                        value: typesOfPurchase.text.isEmpty
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
                                            .map((label) => DropdownMenuItem(
                                                  value: label,
                                                  child: TextWidget(
                                                    text: label,
                                                    fontSize: 14,
                                                    color: secondary,
                                                    fontFamily: 'Medium',
                                                  ),
                                                ))
                                            .toList(),
                                        hint: TextWidget(
                                          text: 'Types of Purchase',
                                          fontSize: 16,
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
                                            borderSide:
                                                BorderSide(color: black),
                                          ),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: black),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide:
                                                BorderSide(color: black),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please select types of purchase.';
                                          }
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                  TextFieldWidget(
                                      inputType: TextInputType.multiline,
                                      borderColor: black,
                                      maxLine: null,
                                      height: null,
                                      width: MediaQuery.of(context).size.width,
                                      radius: 10,
                                      color: secondary,
                                      label: 'List of items',
                                      fontSize: 14,
                                      controller: itemsController),
                                  TextFieldWidget(
                                      borderColor: black,
                                      maxLine:
                                          null, // Set to null to allow unlimited lines
                                      // minLines: 1, // Start with 1 line
                                      height:
                                          null, // Remove fixed height to allow auto-expansion
                                      width: MediaQuery.of(context).size.width,
                                      radius: 10,
                                      color: secondary,
                                      label: 'Note to rider',
                                      fontSize: 14,
                                      controller: riderNoteController),
                                  TextFieldWidget(
                                      inputType: TextInputType.number,
                                      borderColor: black,
                                      maxLine: 50,
                                      prefix: TextWidget(
                                        text: '₱',
                                        fontSize: 14,
                                        color: black,
                                      ),
                                      height: 55,
                                      width: MediaQuery.of(context).size.width,
                                      radius: 10,
                                      color: secondary,
                                      label:
                                          'Delivery Fee Offer (excluding the amount of purchase items)',
                                      fontSize: 14,
                                      controller: deliveryOfferController),
                                ],
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
                    GestureDetector(
                      onTap: () async {
                        if (namecontroller.text.isEmpty) {
                          showToast('Please enter name of recipient.');
                        } else if (mobileNumber.text.isEmpty ||
                            mobileNumber.text.length != 11 ||
                            mobileNumber.text.startsWith('9')) {
                          showToast('Please enter a valid mobile number.');
                        } else if (deliveryAddress.text.isEmpty) {
                          showToast('Please enter delivery address.');
                        } else if (typesOfPurchase.text.isEmpty) {
                          showToast('Please select types of purchase.');
                        } else if (deliveryOfferController.text.isEmpty ||
                            double.parse(deliveryOfferController.text) <= 0) {
                          showToast('Please enter amount of delivery offer.');
                        } else if (itemsController.text.isEmpty) {
                          showToast('Please enter list of items.');
                        } else {
                          try {
                            QuerySnapshot riderSnapshot =
                                await FirebaseFirestore.instance
                                    .collection('Riders')
                                    .where('isActive', isEqualTo: true)
                                    .limit(1)
                                    .get();

                            if (riderSnapshot.docs.isNotEmpty) {
                              DocumentSnapshot riderDoc =
                                  riderSnapshot.docs.first;
                              Map<String, dynamic> riderData =
                                  riderDoc.data() as Map<String, dynamic>;

                              // Add purchase order with rider information
                              DocumentReference purchaseOrderRef =
                                  await FirebaseFirestore.instance
                                      .collection('Purchase')
                                      .add({
                                'deliveryFeeOffer':
                                    deliveryOfferController.text,
                                'type': 'Purchase',
                                'orderType': isNowSelected ? 'now' : 'reserve',
                                'name': namecontroller.text,
                                'mobile': mobileNumber.text,
                                'typesOfPurchase': typesOfPurchase.text,
                                'deliveryAddress': deliveryAddress.text,
                                'deliveryLat': deliveryLat,
                                'deliveryLng': deliveryLng,
                                'items': itemsController.text,
                                'riderNote': riderNoteController.text,
                                'status': 'Pending',
                                'userId': userId,
                                'riderId': riderDoc.id,
                                'riderName': riderData['name'],
                                'riderContact': riderData['number'],
                                'createdAt': FieldValue.serverTimestamp(),
                                if (!isNowSelected) ...{
                                  'selectedDateAndTime': selectedDateAndTime !=
                                          null
                                      ? Timestamp.fromDate(
                                          selectedDateAndTime!) // Convert to Timestamp
                                      : null,
                                }
                              });

                              showToast('Order placed successfully.');

                              // Navigate to CheckoutPage with the necessary data
                              Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(
                                  builder: (context) => CheckoutPage(
                                    data: {
                                      'riderId': riderDoc.id,
                                      'riderName': riderData['name'],
                                      'riderContact': riderData['number'],
                                      'deliveryFeeOffer':
                                          deliveryOfferController.text,
                                      'type': 'Purchase',
                                      'orderType':
                                          isNowSelected ? 'now' : 'reserve',
                                      'name': namecontroller.text,
                                      'mobile': mobileNumber.text,
                                      'typesOfPurchase': typesOfPurchase.text,
                                      'deliveryAddress': deliveryAddress.text,
                                      'deliveryLat': deliveryLat,
                                      'deliveryLng': deliveryLng,
                                      'items': itemsController.text,
                                      'riderNote': riderNoteController.text,
                                      'status': 'Pending',
                                      'userId': userId,
                                      'createdAt': FieldValue.serverTimestamp(),
                                      'orderId': purchaseOrderRef
                                          .id, // Pass the order ID
                                      if (!isNowSelected) ...{
                                        'selectedDateAndTime':
                                            selectedDateAndTime != null
                                                ? Timestamp.fromDate(
                                                    selectedDateAndTime!)
                                                : null,
                                      }
                                    },
                                  ),
                                ),
                                (route) => false,
                              );

                              // Clear the form fields
                              namecontroller.clear();
                              mobileNumber.clear();
                              address.clear();
                              typesOfPurchase.clear();
                              deliveryAddress.clear();
                              itemsController.clear();
                              riderNoteController.clear();
                              deliveryOfferController.clear();
                              setState(() {
                                selectedDate.clear();
                                selectedTime.clear();
                                selectedDateAndTime =
                                    null; // Clear the DateTime object
                              });
                            } else {
                              showToast('No active rider available.');
                            }
                          } catch (error) {
                            showToast('Error placing order.');
                          }
                        }
                      },
                      child: Container(
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
              true,
            ),
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
