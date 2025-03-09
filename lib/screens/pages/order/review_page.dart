import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/pages/order/checkout_page.dart';
import 'package:zippy/screens/pages/order/location_picker_page.dart';
import 'package:zippy/services/add_order.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class ReviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final int basketCount;
  final Function(List<Map<String, dynamic>>) onUpdateCart;
  final double merchantLat;
  final double merchantLng;
  final String merchantId;
  final String merchantName;

  const ReviewPage({
    super.key,
    required this.selectedItems,
    required this.basketCount,
    required this.onUpdateCart,
    required this.merchantLat,
    required this.merchantLng,
    required this.merchantId,
    required this.merchantName,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final TextEditingController _remarksController =
      TextEditingController(text: '');
  final TextEditingController _tipController = TextEditingController(text: '');
  String _tips = '0';
  final Map<String, dynamic> _itemCounts = {};
  double _totalPrice = 0;
  bool _isHome = true;
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();
  Set<Marker> _markers = {};
  final String _nearestDriverId = '';

  @override
  void initState() {
    super.initState();
    _initializeItemCounts();
    _calculateTotalPrice();
  }

  void _initializeItemCounts() {
    for (var item in widget.selectedItems) {
      double price = double.tryParse(item['price'].toString()) ?? 0.0;
      if (_itemCounts.containsKey(item['name'])) {
        _itemCounts[item['name']]!['count']++;
      } else {
        _itemCounts[item['name']] = {'price': price, 'count': 1};
      }
    }
  }

  void _calculateTotalPrice() {
    setState(() {
      _totalPrice = _itemCounts.entries.fold(
        0,
        (sum, entry) => sum + entry.value['price'] * entry.value['count'],
      );
    });
  }

  void _addItem(String name) {
    setState(() {
      _itemCounts[name]!['count']++;
      widget.selectedItems
          .add({'name': name, 'price': _itemCounts[name]!['price']});
      widget.onUpdateCart(widget.selectedItems);
      _calculateTotalPrice();
    });
  }

  void _removeItem(String name) {
    setState(() {
      if (_itemCounts.containsKey(name) && _itemCounts[name]!['count'] > 0) {
        _itemCounts[name]!['count']--;
        widget.selectedItems.removeWhere((item) => item['name'] == name);
        if (_itemCounts[name]!['count'] == 0) {
          _itemCounts.remove(name);
        }
        widget.onUpdateCart(widget.selectedItems);
        _calculateTotalPrice();
      }
    });
  }

  void _deleteItem(String name) {
    setState(() {
      _itemCounts.remove(name);
      widget.selectedItems.removeWhere((item) => item['name'] == name);
      widget.onUpdateCart(widget.selectedItems);
      _calculateTotalPrice();
    });
  }

  Future<void> _updateMapMarker(
      LatLng position, String markerId, String title) async {
    final GoogleMapController controller = await _mapController.future;
    await controller.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(target: position, zoom: 18),
    ));
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          position: position,
          markerId: MarkerId(markerId),
          infoWindow: InfoWindow(title: title, snippet: '$title Location'),
        ),
      );
    });
  }

  void _showAddressSelectionSheet(BuildContext context, dynamic userData) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: 200,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, color: Colors.red),
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await _updateMapMarker(
                      LatLng(userData['homeLat'], userData['homeLng']),
                      'home',
                      'Home',
                    );
                    setState(() => _isHome = true);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.home, color: secondary),
                  title: TextWidget(
                    text: 'Home',
                    fontSize: 16,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                ),
                ListTile(
                  onTap: () async {
                    await _updateMapMarker(
                      LatLng(userData['officeLat'], userData['officeLng']),
                      'office',
                      'Work',
                    );
                    setState(() => _isHome = false);
                    Navigator.pop(context);
                  },
                  leading: const Icon(Icons.work, color: secondary),
                  title: TextWidget(
                    text: 'Work',
                    fontSize: 16,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAppBar(),
            const SizedBox(height: 20),
            _buildItemList(),
            const SizedBox(height: 10),
            _buildDeliveryAddressSection(),
            const SizedBox(height: 10),
            _buildRemarksAndTipSection(),
            const SizedBox(height: 10),
            _buildPaymentSection(),
            const SizedBox(height: 10),
            _buildBillingSummary(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new,
                      color: secondary, size: 18),
                  const SizedBox(width: 10),
                  TextWidget(
                    text: 'Back',
                    fontSize: 15,
                    color: secondary,
                    fontFamily: 'Medium',
                  ),
                ],
              ),
            ),
            TextWidget(
              text: 'Review',
              fontSize: 20,
              color: secondary,
              fontFamily: 'Bold',
            ),
            const Icon(Icons.delete, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildItemList() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        children: _itemCounts.entries.map((entry) {
          final itemName = entry.key;
          final itemCount = entry.value['count'];
          final itemPrice = entry.value['price'];

          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: secondary,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextWidget(
                  text: 'x$itemCount',
                  fontSize: 15,
                  color: white,
                  fontFamily: 'Bold',
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextWidget(
                      text: itemName,
                      fontSize: 15,
                      fontFamily: 'Bold',
                      color: Colors.white,
                    ),
                    TextWidget(
                      text:
                          'Total ₱ ${(itemPrice * itemCount).toStringAsFixed(2)}',
                      fontSize: 14,
                      fontFamily: 'Regular',
                      color: Colors.white,
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      iconSize: 20,
                      onPressed: () => _removeItem(itemName),
                      icon: const Icon(Icons.remove),
                      color: Colors.white,
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: () => _addItem(itemName),
                      icon: const Icon(Icons.add),
                      color: Colors.white,
                    ),
                    IconButton(
                      iconSize: 20,
                      onPressed: () => _deleteItem(itemName),
                      icon: const Icon(Icons.delete),
                      color: Colors.white,
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDeliveryAddressSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Delivery Address',
            fontSize: 20,
            fontFamily: 'Bold',
            color: secondary,
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading'));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final userData = snapshot.data!;
              return _buildAddressCard(userData);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAddressCard(dynamic userData) {
    return Card(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 180,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: secondary),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Stack(
          children: [
            GoogleMap(
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  _isHome ? userData['homeLat'] : userData['officeLat'],
                  _isHome ? userData['homeLng'] : userData['officeLng'],
                ),
                zoom: 15,
              ),
              onMapCreated: (controller) => _mapController.complete(controller),
              markers: _markers.isEmpty
                  ? {
                      Marker(
                        position:
                            LatLng(userData['homeLat'], userData['homeLng']),
                        markerId: const MarkerId('home'),
                        infoWindow: const InfoWindow(
                            title: 'Home', snippet: 'Home Location'),
                      ),
                    }
                  : _markers,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(),
                Container(
                  width: double.infinity,
                  height: 36,
                  decoration: const BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(bottom: Radius.circular(7.5)),
                    color: secondary,
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(
                        width: 250,
                        child: TextWidget(
                          text: _isHome
                              ? userData['homeAddress']
                              : userData['officeAddress'],
                          fontSize: 15,
                          maxLines: 1,
                          fontFamily: 'Bold',
                          color: Colors.white,
                        ),
                      ),
                      GestureDetector(
                        onTap: () async {
                          LatLng? newLocation = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LocationPickerScreen(
                                initialLatLng: LatLng(
                                  _isHome
                                      ? userData['homeLat']
                                      : userData['officeLat'],
                                  _isHome
                                      ? userData['homeLng']
                                      : userData['officeLng'],
                                ),
                              ),
                            ),
                          );

                          if (newLocation != null) {
                            setState(() {
                              if (_isHome) {
                                userData.reference.update({
                                  'homeLat': newLocation.latitude,
                                  'homeLng': newLocation.longitude,
                                  'homeAddress': newLocation
                                      .toString(), // Update with selected location
                                });
                              } else {
                                userData.reference.update({
                                  'officeLat': newLocation.latitude,
                                  'officeLng': newLocation.longitude,
                                  'officeAddress': newLocation
                                      .toString(), // Update with selected location
                                });
                              }

                              _markers = {
                                Marker(
                                  markerId: const MarkerId("selected"),
                                  position: newLocation,
                                  infoWindow: const InfoWindow(
                                      title: "Selected Location"),
                                ),
                              };
                            });
                          }
                        },
                        child: TextWidget(
                          text: 'Edit',
                          fontSize: 14,
                          fontFamily: 'Regular',
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemarksAndTipSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 150,
          child: TextFieldWidget(
            maxLine: 20,
            height: 65,
            radius: 10,
            borderColor: secondary,
            label: 'Remarks',
            controller: _remarksController,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 80,
              child: TextFieldWidget(
                onChanged: (value) => setState(() => _tips = value),
                inputType: TextInputType.number,
                height: 65,
                radius: 10,
                borderColor: secondary,
                label: 'Tip (optional)',
                controller: _tipController,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Mode of Payment',
            fontSize: 20,
            fontFamily: 'Bold',
            color: secondary,
          ),
          const SizedBox(height: 5),
          Container(
            width: MediaQuery.of(context).size.width,
            height: 45,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: secondary),
            ),
            child: Row(
              children: [
                Radio(
                  activeColor: secondary,
                  value: true,
                  groupValue: true,
                  onChanged: (value) {},
                ),
                TextWidget(
                  text: 'Cash on Delivery',
                  fontSize: 15,
                  color: secondary,
                  fontFamily: 'Bold',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBillingSummary() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextWidget(
            text: 'Billing Summary',
            fontSize: 20,
            fontFamily: 'Bold',
            color: secondary,
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: 'Subtotal',
                fontSize: 18,
                fontFamily: 'Bold',
                color: secondary,
              ),
              TextWidget(
                text: '₱ ${_totalPrice.toStringAsFixed(2)}',
                fontSize: 18,
                fontFamily: 'Bold',
                color: secondary,
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextWidget(
                text: 'Tip',
                fontSize: 18,
                fontFamily: 'Bold',
                color: secondary,
              ),
              TextWidget(
                text: '₱ ${(double.tryParse(_tips) ?? 0).toStringAsFixed(2)}',
                fontSize: 18,
                fontFamily: 'Bold',
                color: secondary,
              ),
            ],
          ),
          StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(userId)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: Text('Loading'));
              } else if (snapshot.hasError) {
                return const Center(child: Text('Something went wrong'));
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              final userData = snapshot.data!;
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Delivery fee',
                        fontSize: 18,
                        fontFamily: 'Bold',
                        color: secondary,
                      ),
                      TextWidget(
                        text:
                            '₱ ${_calculateDeliveryFee(userData).toStringAsFixed(2)}',
                        fontSize: 18,
                        fontFamily: 'Bold',
                        color: secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Total:',
                        fontSize: 20,
                        fontFamily: 'Bold',
                        color: secondary,
                      ),
                      TextWidget(
                        text:
                            '₱ ${_calculateTotal(userData).toStringAsFixed(2)}',
                        fontSize: 20,
                        fontFamily: 'Bold',
                        color: secondary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildCheckoutButton(userData),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  double _calculateDeliveryFee(dynamic userData) {
    return ((calculateDistance(
              _isHome ? userData['homeLat'] : userData['officeLat'],
              _isHome ? userData['homeLng'] : userData['officeLng'],
              widget.merchantLat,
              widget.merchantLng,
            ) *
            10) +
        50);
  }

  double _calculateTotal(dynamic userData) {
    return _totalPrice +
        (double.tryParse(_tips) ?? 0) +
        _calculateDeliveryFee(userData);
  }

  Widget _buildCheckoutButton(dynamic userData) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('Riders')
          .where('isActive', isEqualTo: true)
          .snapshots(),
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Center(child: Text('Error'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.black));
        }

        final sortedData =
            List<QueryDocumentSnapshot>.from(snapshot.data!.docs);
        sortedData.sort((a, b) {
          final double lat1 = a['lat'];
          final double long1 = a['lng'];
          final double lat2 = b['lat'];
          final double long2 = b['lng'];

          final double distance1 = calculateDistance(
            widget.merchantLat,
            widget.merchantLng,
            lat1,
            long1,
          );
          final double distance2 = calculateDistance(
            widget.merchantLat,
            widget.merchantLng,
            lat2,
            long2,
          );

          return distance1.compareTo(distance2);
        });

        return Center(
          child: GestureDetector(
            onTap: (_isHome && userData['homeAddress'].isEmpty) ||
                    (!_isHome && userData['officeAddress'].isEmpty)
                ? null
                : () async {
                    if (sortedData.isNotEmpty) {
                      final double deliveryFee =
                          _calculateDeliveryFee(userData);
                      final double tipValue = double.tryParse(_tips) ?? 0;
                      final double total = _calculateTotal(userData);

                      final String orderId = await addOrder(
                        widget.selectedItems,
                        widget.merchantId,
                        widget.merchantName,
                        _isHome
                            ? userData['homeAddress']
                            : userData['officeAddress'],
                        _totalPrice,
                        _isHome,
                        _remarksController.text,
                        tipValue,
                        'Cash',
                        deliveryFee,
                        total,
                        sortedData.first.id,
                      );

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(
                            data: {
                              'riderId': sortedData.first.id,
                              'items': widget.selectedItems,
                              'merchantId': widget.merchantId,
                              'merchantName': widget.merchantName,
                              'address': _isHome
                                  ? userData['homeAddress']
                                  : userData['officeAddress'],
                              'subtotal': _totalPrice,
                              'isHome': _isHome,
                              'remarks': _remarksController.text,
                              'tip': tipValue,
                              'mop': 'Cash',
                              'deliveryFee': deliveryFee,
                              'total': total,
                              'orderId': orderId,
                            },
                          ),
                        ),
                        (route) => false,
                      );
                    } else {
                      showToast(
                          "We're sorry, but there are currently no available riders to take your order. Please try again later or check back soon. Thank you for your patience!");
                    }
                  },
            child: Container(
              width: 280,
              height: 75,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: secondary,
                border: Border.all(color: secondary),
              ),
              child: Center(
                child: TextWidget(
                  text: 'Checkout',
                  fontSize: 20,
                  fontFamily: 'Bold',
                  color: Colors.white,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
