import 'package:flutter/material.dart';
import 'package:zippy/screens/home_screen.dart';
import 'package:zippy/services/add_report.dart';
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
                itemButton(Icons.download_sharp, 'Download'),
                itemButton(Icons.share, 'Share'),
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
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
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
}
