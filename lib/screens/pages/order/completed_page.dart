import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/services/add_report.dart';
import 'package:zippy/services/add_review.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/widgets/button_widget.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';
import 'package:zippy/widgets/toast_widget.dart';

class CompletedPage extends StatefulWidget {
  Map data;

  CompletedPage({super.key, required this.data});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(
              height: 50,
            ),
            Center(
              child: TextWidget(
                text: 'Delivery Completed',
                fontSize: 22,
                fontFamily: 'Bold',
                color: secondary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Image.asset(
                'assets/images/cat.png',
                width: 140,
                height: 140,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: TextWidget(
                text: 'Enjoy your food!',
                fontSize: 22,
                fontFamily: 'Bold',
                color: secondary,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(
                    color: secondary,
                  ),
                  TextWidget(
                    text: 'Order ID',
                    fontSize: 16,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  TextWidget(
                    text: widget.data['orderId'],
                    fontSize: 16,
                    fontFamily: 'Bold',
                  ),
                  const Divider(
                    color: secondary,
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                    onTap: () {
                      showDownload();
                    },
                    child: itemButton(Icons.download_sharp, 'Download')),
                GestureDetector(
                    onTap: () async {
                      await Share.share(
                          'Booked my order @ZIPPY!\nOrder ID: ${widget.data['orderId']}');
                    },
                    child: itemButton(Icons.share, 'Share')),
                GestureDetector(
                    onTap: () {
                      report(context);
                    },
                    child: itemButton(Icons.warning, 'Report')),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: ButtonWidget(
                width: 310,
                color: secondary,
                label: 'DONE',
                onPressed: () {
                  showInitialRatingDialog();
                  // Navigator.of(context).pushReplacement(
                  //   MaterialPageRoute(builder: (context) => const HomeScreen()),
                  // );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget itemButton(IconData icon, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 66,
          height: 66,
          decoration: BoxDecoration(
            color: secondary,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 40,
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        TextWidget(
          text: label,
          fontSize: 12,
          fontFamily: 'Regular',
        ),
      ],
    );
  }

  final explanation = TextEditingController();

  String? selectedValue;

  report(context) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) {
        return SizedBox(
          height: 500,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Center(
                    child: TextWidget(
                      text: 'Report a Problem',
                      fontSize: 24,
                      fontFamily: 'Bold',
                      color: secondary,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 20, bottom: 10, left: 25, right: 25),
                    child: SizedBox(
                      width: double.infinity,
                      height: 75,
                      child: DropdownButtonFormField<String>(
                        value: selectedValue,
                        items: [
                          "Order Not Received",
                          "Wrong Item Delivered",
                          "Late Delivery",
                          "Damaged Food Packaging",
                          "Incorrect Bill Amount",
                          "Other Issues"
                        ]
                            .map((item) => DropdownMenuItem(
                                  value: item,
                                  child: Text(
                                    item,
                                    style: const TextStyle(
                                      fontFamily: 'Regular',
                                      fontSize: 18,
                                    ),
                                  ),
                                ))
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedValue = value;
                          });
                        },
                        decoration: InputDecoration(
                          labelText: 'Type of problem',
                          labelStyle: const TextStyle(
                            fontFamily: 'Medium',
                            fontSize: 18,
                            color: primary,
                          ),
                          hintText: 'Type of problem',
                          hintStyle: const TextStyle(
                            fontFamily: 'Regular',
                            color: Colors.black,
                            fontSize: 18,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(color: primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: primary),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: const BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFieldWidget(
                    radius: 10,
                    enabled: false,
                    borderColor: primary,
                    label: 'Order ID',
                    controller: TextEditingController(
                      text: widget.data['orderId'],
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextFieldWidget(
                      radius: 10,
                      borderColor: primary,
                      maxLine: 3,
                      height: 100,
                      label: 'Explain what happened',
                      controller: explanation),
                  const SizedBox(
                    height: 30,
                  ),
                  Center(
                    child: ButtonWidget(
                      label: 'DONE',
                      onPressed: () {
                        addReport(widget.data['orderId'], selectedValue,
                            explanation.text, widget.data);
                        Navigator.pop(context);
                        showToast('Report submitted!');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  ScreenshotController screenshotController = ScreenshotController();

  WidgetsToImageController controller = WidgetsToImageController();

  void downloadImage() async {
    try {
      // Capture the widget as an image using the screenshotController
      Uint8List? bytes = await screenshotController.capture();

      if (bytes != null) {
        // Save the image to the gallery or storage
        final result = await ImageGallerySaver.saveImage(bytes);

        if (result['isSuccess']) {
          print("Image saved to gallery!");
        } else {
          print("Failed to save image: ${result['errorMessage']}");
        }
      } else {
        print("Failed to capture the widget as an image.");
      }
    } catch (e) {
      print("Error saving image: $e");
    }
  }

  showDownload() {
    showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: [
                TextWidget(
                    text: "Order Details",
                    fontSize: 25,
                    fontFamily: "Bold",
                    color: secondary),
              ],
            ),
            content: SingleChildScrollView(
              child: Screenshot(
                controller: screenshotController,
                child: WidgetsToImage(
                  controller: controller,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: "Reference Code: ",
                              fontSize: 18,
                              fontFamily: "Bold",
                              color: black),
                          TextWidget(
                              text: '${widget.data['orderId'] ?? 'N/A'}',
                              fontSize: 20,
                              fontFamily: "Bold",
                              color: secondary),
                          const Divider(
                            color: secondary,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: "Shop: ",
                              fontSize: 18,
                              fontFamily: "Bold",
                              color: black),
                          TextWidget(
                              text: '${widget.data['merchantName'] ?? 'N/A'}',
                              fontSize: 20,
                              fontFamily: "Bold",
                              color: secondary),
                          const Divider(
                            color: secondary,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: "Address: ",
                              fontSize: 18,
                              fontFamily: "Bold",
                              color: black),
                          TextWidget(
                              align: TextAlign.start,
                              text: '${widget.data['address'] ?? 'N/A'}',
                              fontSize: 20,
                              fontFamily: "Bold",
                              color: secondary),
                          const Divider(
                            color: secondary,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextWidget(
                              text: "Order List: ",
                              fontSize: 23,
                              fontFamily: "Bold",
                              color: secondary),
                          Column(
                            children: widget.data['items'] != null
                                ? (widget.data['items'] as List<dynamic>)
                                    .fold<Map<String, int>>({}, (acc, order) {
                                      acc.update(
                                          order['name'], (value) => value + 1,
                                          ifAbsent: () => 1);
                                      return acc;
                                    })
                                    .entries
                                    .map((entry) {
                                      final order = widget.data['items']
                                          .firstWhere((item) =>
                                              item['name'] == entry.key);
                                      final totalPrice =
                                          (order['price'] as num) * entry.value;
                                      return Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          TextWidget(
                                              text:
                                                  'x${entry.value} ${entry.key} ',
                                              fontSize: 20,
                                              fontFamily: "Bold",
                                              color: black),
                                          TextWidget(
                                              text: totalPrice != ''
                                                  ? '₱ ${totalPrice.toStringAsFixed(2)}'
                                                  : 'N/A',
                                              fontSize: 20,
                                              fontFamily: "Bold",
                                              color: secondary),
                                        ],
                                      );
                                    })
                                    .toList()
                                : [
                                    TextWidget(
                                        text: 'No order details available',
                                        fontSize: 18,
                                        fontFamily: "Medium",
                                        color: black)
                                  ],
                          ),
                          const Divider(
                            color: secondary,
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  text: "Payment: ",
                                  fontSize: 18,
                                  fontFamily: "Bold",
                                  color: black),
                              TextWidget(
                                  text: '${widget.data['mop'] ?? 'N/A'}',
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: secondary),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  text: 'Subtotal: ',
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: black),
                              TextWidget(
                                  text: widget.data['subtotal'] != null
                                      ? '₱${(widget.data['subtotal'] as num).toStringAsFixed(2)}'
                                      : 'N/A',
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: secondary),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  text: "Delivery Fee: ",
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: black),
                              TextWidget(
                                  text: widget.data['deliveryFee'] != null
                                      ? '₱${(widget.data['deliveryFee'] as num).toStringAsFixed(2)}'
                                      : 'N/A',
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: secondary),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  text: "Tip: ",
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: black),
                              TextWidget(
                                  text: widget.data['tip'] != null
                                      ? '₱${(widget.data['tip'] as num).toStringAsFixed(2)}'
                                      : 'N/A',
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: secondary),
                            ],
                          ),
                          const Divider(
                            color: secondary,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextWidget(
                                  text: "Amount to pay: ",
                                  fontSize: 20,
                                  fontFamily: "Bold",
                                  color: black),
                              TextWidget(
                                text: widget.data['total'] != null
                                    ? '₱${(widget.data['total'] as num).toStringAsFixed(2)}'
                                    : 'N/A',
                                fontSize: 20,
                                fontFamily: "Bold",
                                color: secondary,
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
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 35, vertical: 10),
                    decoration: BoxDecoration(
                        color: secondary,
                        border: Border.all(color: Colors.white, width: 1),
                        borderRadius: BorderRadius.circular(100)),
                    child: GestureDetector(
                      onTap: () {
                        downloadImage();
                        Navigator.of(context).pop();
                      },
                      child: TextWidget(
                        text: 'Download',
                        fontSize: 18,
                        color: Colors.white,
                        fontFamily: "Medium",
                      ),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  showInitialRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Subtract.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(
                  height: 5,
                ),
                TextWidget(
                  text: 'Help us improve!',
                  fontSize: 18,
                  color: secondary,
                  fontFamily: 'Bold',
                ),
                TextWidget(
                  text: 'leave us a rating',
                  fontSize: 12,
                  color: Colors.black,
                  fontFamily: 'Regular',
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    for (int i = 0; i < 5; i++)
                      const Icon(
                        Icons.star_border_rounded,
                        size: 45,
                      ),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    showRatingDialog();
                  },
                  child: TextWidget(
                    decoration: TextDecoration.underline,
                    text: 'rate now',
                    fontSize: 18,
                    color: secondary,
                    fontFamily: 'Bold',
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  double rider = 5;
  double food = 5;
  double experience = 5;

  final comments = TextEditingController();

  showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: TextWidget(
                      text: 'Rating',
                      fontSize: 24,
                      color: secondary,
                      fontFamily: 'Bold',
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: 'Rider',
                    fontSize: 14,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  const Divider(
                    color: secondary,
                  ),
                  RatingBar.builder(
                    initialRating: rider,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: secondary,
                    ),
                    onRatingUpdate: (newRating) async {
                      setState(() {
                        rider = newRating;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: 'Food',
                    fontSize: 14,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  const Divider(
                    color: secondary,
                  ),
                  RatingBar.builder(
                    initialRating: food,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: secondary,
                    ),
                    onRatingUpdate: (newRating) async {
                      setState(() {
                        food = newRating;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  TextWidget(
                    text: 'Experience',
                    fontSize: 14,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  const Divider(
                    color: secondary,
                  ),
                  RatingBar.builder(
                    initialRating: experience,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: false,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
                    itemBuilder: (context, _) => const Icon(
                      Icons.star,
                      color: secondary,
                    ),
                    onRatingUpdate: (newRating) async {
                      setState(() {
                        experience = newRating;
                      });
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFieldWidget(
                      width: double.infinity,
                      radius: 10,
                      borderColor: secondary,
                      maxLine: 3,
                      height: 100,
                      label: 'Comments',
                      controller: comments),
                  const SizedBox(
                    height: 20,
                  ),
                  Center(
                    child: ButtonWidget(
                      width: 310,
                      color: secondary,
                      label: 'DONE',
                      onPressed: () {
                        addReview(
                            rider,
                            food,
                            experience,
                            comments.text,
                            widget.data['orderId'],
                            widget.data['riderId'],
                            widget.data['merchantId']);
                        Navigator.pop(context);
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(
                              builder: (context) => const HomeScreen()),
                          (route) => false,
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
