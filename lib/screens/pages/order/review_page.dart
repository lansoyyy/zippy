import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:zippy/screens/pages/order/checkout_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

class ReviewPage extends StatefulWidget {
  final List<Map<String, dynamic>> selectedItems;
  final int basketCount;
  final Function(List<Map<String, dynamic>>) onUpdateCart;

  const ReviewPage({
    super.key,
    required this.selectedItems,
    required this.basketCount,
    required this.onUpdateCart,
  });

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final remarks = TextEditingController();
  // late Map<String, Map<String, dynamic>> itemCounts;
  Map<String, dynamic> itemCounts = {};

  double totalPrice = 0;

  void calculateTotalPrice() {
    setState(() {
      totalPrice = itemCounts.entries.fold(
          0, (sum, entry) => sum + entry.value['price'] * entry.value['count']);
    });
  }

  @override
  void initState() {
    super.initState();
    itemCounts = {};
    for (var item in widget.selectedItems) {
      double price = double.tryParse(item['price'].toString()) ?? 0.0;
      if (itemCounts.containsKey(item['name'])) {
        itemCounts[item['name']]!['count']++;
      } else {
        itemCounts[item['name']] = {'price': price, 'count': 1};
      }
    }
    calculateTotalPrice();
  }

  void addItem(String name) {
    setState(() {
      itemCounts[name]!['count']++;
      widget.selectedItems
          .add({'name': name, 'price': itemCounts[name]!['price']});
      widget.onUpdateCart(widget.selectedItems); // Notify ShopPage
      calculateTotalPrice();
    });
  }

  void removeItem(String name) {
    setState(() {
      if (itemCounts.containsKey(name) && itemCounts[name]!['count'] > 0) {
        itemCounts[name]!['count']--;

        final index =
            widget.selectedItems.indexWhere((item) => item['name'] == name);
        if (index != -1) {
          widget.selectedItems.removeAt(index);
        }

        if (itemCounts[name]!['count'] == 0) {
          itemCounts.remove(name);
        }
        widget.onUpdateCart(widget.selectedItems);
      }
      calculateTotalPrice();
    });
  }

  bool isHome = true;

  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 25, 20, 0),
              child: SafeArea(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_back_ios_new,
                            color: secondary,
                            size: 18,
                          ),
                          const SizedBox(
                            width: 10,
                          ),
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
                    const Icon(
                      Icons.delete,
                      color: Colors.white,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
              child: Center(
                child: Column(
                  children: itemCounts.entries.map((entry) {
                    String itemName = entry.key;
                    int itemCount = entry.value['count'];
                    double itemPrice = entry.value['price'];

                    return Container(
                      margin: const EdgeInsets.only(bottom: 10),
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(18)),
                        color: secondary,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 20, right: 20, top: 10, bottom: 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
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
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                IconButton(
                                  iconSize: 20,
                                  onPressed: () => removeItem(itemName),
                                  icon: const Icon(Icons.remove),
                                  color: Colors.white,
                                ),
                                IconButton(
                                  iconSize: 20,
                                  onPressed: () => addItem(itemName),
                                  icon: const Icon(Icons.add),
                                  color: Colors.white,
                                ),
                                IconButton(
                                  iconSize: 20,
                                  onPressed: () {
                                    setState(() {
                                      itemCounts.remove(itemName);
                                      widget.selectedItems.removeWhere(
                                          (item) => item['name'] == itemName);
                                      widget.onUpdateCart(widget
                                          .selectedItems); // Notify ShopPage
                                      calculateTotalPrice();
                                    });
                                  },
                                  icon: const Icon(Icons.delete),
                                  color: Colors.white,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
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
                      builder:
                          (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(child: Text('Loading'));
                        } else if (snapshot.hasError) {
                          return const Center(
                              child: Text('Something went wrong'));
                        } else if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        }
                        dynamic data = snapshot.data;

                        return Center(
                          child: Card(
                            child: Container(
                              width: 340,
                              height: 180,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                border: Border.all(color: secondary),
                                borderRadius: BorderRadius.circular(
                                  10,
                                ),
                                // image: const DecorationImage(
                                //   fit: BoxFit.cover,
                                //   image: AssetImage(
                                //     'assets/images/Rectangle 3.png',
                                //   ),
                                // ),
                              ),
                              child: Stack(
                                children: [
                                  Expanded(
                                    child: GoogleMap(
                                      zoomControlsEnabled: false,
                                      mapType: MapType.normal,
                                      initialCameraPosition: CameraPosition(
                                        target: isHome
                                            ? LatLng(data['homeLat'],
                                                data['homeLng'])
                                            : LatLng(data['officeLat'],
                                                data['officeLng']),
                                        zoom: 15,
                                      ),
                                      onMapCreated:
                                          (GoogleMapController controller) {
                                        _controller.complete(controller);
                                      },
                                      markers: markers.isEmpty
                                          ? {
                                              Marker(
                                                position: LatLng(
                                                    data['homeLat'],
                                                    data['homeLng']),
                                                markerId:
                                                    const MarkerId('home'),
                                                infoWindow: const InfoWindow(
                                                  title: 'Home',
                                                  snippet: 'Home Location',
                                                ),
                                              ),
                                            }
                                          : markers,
                                    ),
                                  ),
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const SizedBox(),
                                      Container(
                                        width: double.infinity,
                                        height: 36,
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(
                                              7.5,
                                            ),
                                            bottomRight: Radius.circular(
                                              7.5,
                                            ),
                                          ),
                                          color: secondary,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15, right: 15),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                width: 250,
                                                child: TextWidget(
                                                  text: isHome
                                                      ? data['homeAddress']
                                                      : data['officeAddress'],
                                                  fontSize: 15,
                                                  maxLines: 1,
                                                  fontFamily: 'Bold',
                                                  color: Colors.white,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  showBottomSheet(
                                                    context: context,
                                                    builder: (context) {
                                                      return SizedBox(
                                                        height: 200,
                                                        width: double.infinity,
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12.0),
                                                          child: Column(
                                                            children: [
                                                              Align(
                                                                alignment:
                                                                    Alignment
                                                                        .topRight,
                                                                child:
                                                                    IconButton(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  icon:
                                                                      const Icon(
                                                                    Icons.close,
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                                ),
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  final GoogleMapController
                                                                      controller =
                                                                      await _controller
                                                                          .future;
                                                                  await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                                                      target: LatLng(
                                                                          data[
                                                                              'homeLat'],
                                                                          data[
                                                                              'homeLng']),
                                                                      zoom:
                                                                          18)));
                                                                  setState(() {
                                                                    isHome =
                                                                        true;

                                                                    markers
                                                                        .clear();

                                                                    markers.add(
                                                                      Marker(
                                                                        position: LatLng(
                                                                            data['homeLat'],
                                                                            data['homeLng']),
                                                                        markerId:
                                                                            const MarkerId('home'),
                                                                        infoWindow:
                                                                            const InfoWindow(
                                                                          title:
                                                                              'Home',
                                                                          snippet:
                                                                              'Home Location',
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });

                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                leading:
                                                                    const Icon(
                                                                  Icons.home,
                                                                  color:
                                                                      secondary,
                                                                ),
                                                                title:
                                                                    TextWidget(
                                                                  text: 'Home',
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Bold',
                                                                  color:
                                                                      secondary,
                                                                ),
                                                              ),
                                                              ListTile(
                                                                onTap:
                                                                    () async {
                                                                  final GoogleMapController
                                                                      controller =
                                                                      await _controller
                                                                          .future;
                                                                  await controller.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
                                                                      target: LatLng(
                                                                          data[
                                                                              'officeLat'],
                                                                          data[
                                                                              'officeLng']),
                                                                      zoom:
                                                                          18)));
                                                                  setState(() {
                                                                    isHome =
                                                                        false;

                                                                    markers
                                                                        .clear();

                                                                    markers.add(
                                                                      Marker(
                                                                        position: LatLng(
                                                                            data['officeLat'],
                                                                            data['officeLng']),
                                                                        markerId:
                                                                            const MarkerId('office'),
                                                                        infoWindow:
                                                                            const InfoWindow(
                                                                          title:
                                                                              'Work',
                                                                          snippet:
                                                                              'Work Location',
                                                                        ),
                                                                      ),
                                                                    );
                                                                  });
                                                                  Navigator.pop(
                                                                      context);
                                                                },
                                                                leading:
                                                                    const Icon(
                                                                  Icons.work,
                                                                  color:
                                                                      secondary,
                                                                ),
                                                                title:
                                                                    TextWidget(
                                                                  text: 'Work',
                                                                  fontSize: 16,
                                                                  fontFamily:
                                                                      'Bold',
                                                                  color:
                                                                      secondary,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  );
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
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Address:',
                        fontSize: 20,
                        fontFamily: 'Bold',
                        color: secondary,
                      ),
                      const SizedBox(
                        width: 15,
                      ),
                      TextWidget(
                        text: '999 Blk. 11 Lot 9 7th Avenue, 22nd Street',
                        fontSize: 12,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextWidget(
                        text: 'Remarks:',
                        fontSize: 20,
                        fontFamily: 'Bold',
                        color: secondary,
                      ),
                      SizedBox(
                          width: 230,
                          height: 65,
                          child: TextFieldWidget(
                              height: 65,
                              radius: 10,
                              borderColor: secondary,
                              label: 'Remarks',
                              controller: remarks))
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Mode of Payment',
                    fontSize: 20,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  // for (int i = 0; i < 2; i++)
                  //   Padding(
                  //     padding: const EdgeInsets.only(bottom: 10),
                  //     child: Container(
                  //       width: 320,
                  //       height: 45,
                  //       decoration: BoxDecoration(
                  //         borderRadius: BorderRadius.circular(10),
                  //         border: Border.all(color: secondary),
                  //       ),
                  //       child: Row(
                  //         mainAxisAlignment: MainAxisAlignment.start,
                  //         crossAxisAlignment: CrossAxisAlignment.center,
                  //         children: [
                  //           Radio(
                  //             activeColor: secondary,
                  //             value: i == 0 ? false : true,
                  //             groupValue: false,
                  //             onChanged: (value) {},
                  //           ),
                  //           Image.asset(
                  //             i == 0
                  //                 ? 'assets/images/image 5.png'
                  //                 : 'assets/images/image 6.png',
                  //             width: 80,
                  //             height: 30,
                  //           ),
                  //           const SizedBox(
                  //             width: 10,
                  //           ),
                  //           Container(
                  //             width: 50,
                  //             height: 15,
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(5),
                  //               border: Border.all(
                  //                 color: secondary,
                  //               ),
                  //             ),
                  //             child: Center(
                  //               child: TextWidget(
                  //                 text: 'Link now',
                  //                 fontSize: 8,
                  //                 color: secondary,
                  //               ),
                  //             ),
                  //           ),
                  //           const Expanded(
                  //             child: SizedBox(
                  //               width: 10,
                  //             ),
                  //           ),
                  //           TextWidget(
                  //             text: '+ 2% Transfer fee',
                  //             fontSize: 12,
                  //             color: secondary,
                  //             fontFamily: 'Bold',
                  //           ),
                  //           const SizedBox(
                  //             width: 10,
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //   ),
                  // for (int i = 0; i < 2; i++)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      width: 320,
                      height: 45,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: secondary),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
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
                          const Expanded(
                            child: SizedBox(
                              width: 10,
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextWidget(
                    text: 'Billing Summary',
                    fontSize: 20,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Subtotal amount',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                      TextWidget(
                        text: '₱ ${totalPrice.toStringAsFixed(2)}',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Voucher',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                      TextWidget(
                        text: '₱ 1495.00',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Delivery fee',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                      TextWidget(
                        text: '₱ 1495.00',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextWidget(
                        text: 'Sales tax',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                      TextWidget(
                        text: '₱ 1495.00',
                        fontSize: 15,
                        fontFamily: 'Regular',
                        color: secondary,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 5,
                  ),
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
                        text: '₱ ${totalPrice.toStringAsFixed(2)}',
                        fontSize: 20,
                        fontFamily: 'Bold',
                        color: secondary,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (context) => const CheckoutPage()),
                        );
                      },
                      child: Container(
                        width: 280,
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: secondary,
                          border: Border.all(
                            color: secondary,
                          ),
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
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
