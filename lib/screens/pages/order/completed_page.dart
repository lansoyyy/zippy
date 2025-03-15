import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:saver_gallery/saver_gallery.dart';
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
  final Map<String, dynamic> data;

  const CompletedPage({super.key, required this.data});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  final TextEditingController _explanationController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  final ScreenshotController _screenshotController = ScreenshotController();
  final WidgetsToImageController _widgetsToImageController =
      WidgetsToImageController();

  String? _selectedReportType;
  double _riderRating = 5;
  double _foodRating = 5;
  double _experienceRating = 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),
              _buildHeader(),
              const SizedBox(height: 20),
              _buildImage(),
              const SizedBox(height: 20),
              _buildEnjoyText(),
              const SizedBox(height: 20),
              _buildOrderDetails(),
              const SizedBox(height: 50),
              _buildActionButtons(),
              const SizedBox(height: 20),
              _buildDoneButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Center(
      child: TextWidget(
        text: 'Delivery Completed',
        fontSize: 22,
        fontFamily: 'Bold',
        color: secondary,
      ),
    );
  }

  Widget _buildImage() {
    return Center(
      child: Image.asset(
        widget.data['type'] == 'Purchase'
            ? 'assets/images/Group 121 (1).png'
            : 'assets/images/cat.png',
        width: 140,
        height: 140,
      ),
    );
  }

  Widget _buildEnjoyText() {
    return Center(
      child: TextWidget(
        text: widget.data['type'] == 'Purchase'
            ? 'Thank you for your purchase!'
            : 'Enjoy your food!',
        fontSize: 22,
        fontFamily: 'Bold',
        color: secondary,
      ),
    );
  }

  Widget _buildOrderDetails() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          const Divider(color: secondary),
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
          const Divider(color: secondary),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionButton(
            Icons.download_sharp, 'Download', _showDownloadDialog),
        _buildActionButton(Icons.share, 'Share', _shareOrderDetails),
        _buildActionButton(Icons.warning, 'Report', _showReportBottomSheet),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 66,
            height: 66,
            decoration: BoxDecoration(
              color: secondary,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: Colors.white, size: 40),
          ),
          const SizedBox(height: 5),
          TextWidget(
            text: label,
            fontSize: 12,
            fontFamily: 'Regular',
          ),
        ],
      ),
    );
  }

  Widget _buildDoneButton() {
    return Center(
      child: ButtonWidget(
        width: 310,
        color: secondary,
        label: 'DONE',
        onPressed: _showInitialRatingDialog,
      ),
    );
  }

  void _showDownloadDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: TextWidget(
            text: "Order Details",
            fontSize: 25,
            fontFamily: "Bold",
            color: secondary,
          ),
          content: SingleChildScrollView(
            child: Screenshot(
              controller: _screenshotController,
              child: WidgetsToImage(
                controller: _widgetsToImageController,
                child: _buildOrderSummary(),
              ),
            ),
          ),
          actions: [
            Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                decoration: BoxDecoration(
                  color: secondary,
                  border: Border.all(color: Colors.white, width: 1),
                  borderRadius: BorderRadius.circular(100),
                ),
                child: GestureDetector(
                  onTap: () {
                    _downloadImage();
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
            ),
          ],
        );
      },
    );
  }

  Widget _buildOrderSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildOrderDetail('Reference Code', widget.data['orderId']),
        _buildOrderDetail('Shop', widget.data['merchantName']),
        _buildOrderDetail('Address', widget.data['address']),
        _buildOrderList(),
        _buildPaymentDetails(),
      ],
    );
  }

  Widget _buildOrderDetail(String label, String? value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: "$label: ",
          fontSize: 18,
          fontFamily: "Bold",
          color: black,
        ),
        TextWidget(
          text: value ?? 'N/A',
          fontSize: 20,
          fontFamily: "Bold",
          color: secondary,
        ),
        const Divider(color: secondary),
      ],
    );
  }

  Widget _buildOrderList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: "Order List: ",
          fontSize: 23,
          fontFamily: "Bold",
          color: secondary,
        ),
        Column(
          children: widget.data['items'] != null
              ? (widget.data['items'] as List<dynamic>)
                  .fold<Map<String, int>>({}, (acc, order) {
                    acc.update(order['name'], (value) => value + 1,
                        ifAbsent: () => 1);
                    return acc;
                  })
                  .entries
                  .map((entry) {
                    final order = widget.data['items']
                        .firstWhere((item) => item['name'] == entry.key);
                    final totalPrice = (order['price'] as num) * entry.value;
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextWidget(
                          text: 'x${entry.value} ${entry.key} ',
                          fontSize: 20,
                          fontFamily: "Bold",
                          color: black,
                        ),
                        TextWidget(
                          text: totalPrice != ''
                              ? '₱ ${totalPrice.toStringAsFixed(2)}'
                              : 'N/A',
                          fontSize: 20,
                          fontFamily: "Bold",
                          color: secondary,
                        ),
                      ],
                    );
                  })
                  .toList()
              : [
                  TextWidget(
                    text: 'No order details available',
                    fontSize: 18,
                    fontFamily: "Medium",
                    color: black,
                  )
                ],
        ),
        const Divider(color: secondary),
      ],
    );
  }

  Widget _buildPaymentDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildPaymentDetailRow("Payment", widget.data['mop']),
        _buildPaymentDetailRow("Subtotal", widget.data['subtotal']),
        _buildPaymentDetailRow("Delivery Fee", widget.data['deliveryFee']),
        _buildPaymentDetailRow("Tip", widget.data['tip']),
        const Divider(color: secondary),
        _buildPaymentDetailRow("Amount to pay", widget.data['total']),
      ],
    );
  }

  Widget _buildPaymentDetailRow(String label, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextWidget(
          text: "$label: ",
          fontSize: 20,
          fontFamily: "Bold",
          color: black,
        ),
        TextWidget(
          text: value != null ? '₱${(value as num).toStringAsFixed(2)}' : 'N/A',
          fontSize: 20,
          fontFamily: "Bold",
          color: secondary,
        ),
      ],
    );
  }

  Future<void> _downloadImage() async {
    try {
      Uint8List? bytes = await _screenshotController.capture();
      if (bytes != null) {
        final result = await SaverGallery.saveImage(bytes,
            fileName: DateTime.now().toString(), skipIfExists: true);
        if (result.isSuccess) {
          showToast('Image saved to gallery!');
        } else {
          showToast('Failed to save image: ${result.errorMessage}');
        }
      } else {
        showToast('Failed to capture the widget as an image.');
      }
    } catch (e) {
      showToast('Error saving image: $e');
    }
  }

  void _shareOrderDetails() async {
    await Share.share(
        'Booked my order @ZIPPY!\nOrder ID: ${widget.data['orderId']}');
  }

  void _showReportBottomSheet() {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      builder: (context) {
        return SizedBox(
          height: 500,
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: TextWidget(
                      text: 'Report a Problem',
                      fontSize: 24,
                      fontFamily: 'Bold',
                      color: secondary,
                    ),
                  ),
                  _buildReportDropdown(),
                  _buildOrderIdField(),
                  _buildExplanationField(),
                  const SizedBox(height: 30),
                  _buildReportDoneButton(),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildReportDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 25),
      child: DropdownButtonFormField<String>(
        value: _selectedReportType,
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
                    style: const TextStyle(fontFamily: 'Regular', fontSize: 18),
                  ),
                ))
            .toList(),
        onChanged: (value) => setState(() => _selectedReportType = value),
        decoration: InputDecoration(
          labelText: 'Type of problem',
          labelStyle: const TextStyle(
              fontFamily: 'Medium', fontSize: 18, color: primary),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: primary),
          ),
        ),
      ),
    );
  }

  Widget _buildOrderIdField() {
    return TextFieldWidget(
      radius: 10,
      enabled: false,
      borderColor: primary,
      label: 'Order ID',
      controller: TextEditingController(text: widget.data['orderId']),
    );
  }

  Widget _buildExplanationField() {
    return TextFieldWidget(
      radius: 10,
      borderColor: primary,
      maxLine: 3,
      height: 100,
      label: 'Explain what happened',
      controller: _explanationController,
    );
  }

  Widget _buildReportDoneButton() {
    return Center(
      child: ButtonWidget(
        label: 'DONE',
        onPressed: () {
          addReport(
            widget.data['orderId'],
            _selectedReportType,
            _explanationController.text,
            widget.data,
          );
          Navigator.pop(context);
          showToast('Report submitted!');
        },
      ),
    );
  }

  void _showInitialRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/Subtract.png',
                  width: 150,
                  height: 150,
                ),
                const SizedBox(height: 5),
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
                const SizedBox(height: 5),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                        5,
                        (index) =>
                            const Icon(Icons.star_border_rounded, size: 45))),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _showRatingDialog();
                  },
                  child: TextWidget(
                    decoration: TextDecoration.underline,
                    text: 'rate now',
                    fontSize: 18,
                    color: secondary,
                    fontFamily: 'Bold',
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showRatingDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(25, 15, 25, 15),
              child: SingleChildScrollView(
                child: Column(
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
                    _buildRatingSection('Rider', _riderRating,
                        (rating) => _riderRating = rating),
                    _buildRatingSection(
                        'Food', _foodRating, (rating) => _foodRating = rating),
                    _buildRatingSection('Experience', _experienceRating,
                        (rating) => _experienceRating = rating),
                    const SizedBox(height: 10),
                    TextFieldWidget(
                      width: double.infinity,
                      radius: 10,
                      borderColor: secondary,
                      maxLine: 3,
                      height: 100,
                      label: 'Comments',
                      controller: _commentsController,
                    ),
                    const SizedBox(height: 20),
                    Center(
                      child: ButtonWidget(
                        width: 310,
                        color: secondary,
                        label: 'DONE',
                        onPressed: () {
                          addReview(
                            _riderRating,
                            _foodRating,
                            _experienceRating,
                            _commentsController.text,
                            widget.data['orderId'],
                            widget.data['riderId'],
                            widget.data['merchantId'],
                          );
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
          ),
        );
      },
    );
  }

  Widget _buildRatingSection(
      String label, double rating, Function(double) onRatingUpdate) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextWidget(
          text: label,
          fontSize: 14,
          fontFamily: 'Bold',
          color: secondary,
        ),
        const Divider(color: secondary),
        RatingBar.builder(
          initialRating: rating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: false,
          itemCount: 5,
          itemPadding: const EdgeInsets.symmetric(horizontal: 0.0),
          itemBuilder: (context, _) => const Icon(Icons.star, color: secondary),
          onRatingUpdate: onRatingUpdate,
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
