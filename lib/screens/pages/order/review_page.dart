import 'package:flutter/material.dart';
import 'package:zippy/screens/pages/order/checkout_page.dart';
import 'package:zippy/utils/colors.dart';
import 'package:zippy/utils/const.dart';
import 'package:zippy/widgets/text_widget.dart';
import 'package:zippy/widgets/textfield_widget.dart';

class ReviewPage extends StatefulWidget {
  const ReviewPage({super.key});

  @override
  State<ReviewPage> createState() => _ReviewPageState();
}

class _ReviewPageState extends State<ReviewPage> {
  final remarks = TextEditingController();
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
                      color: secondary,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            for (int i = 0; i < 3; i++)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Center(
                  child: Container(
                    width: 320,
                    height: 56,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: secondary,
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          height: double.infinity,
                          width: 225,
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(18),
                              bottomLeft: Radius.circular(18),
                            ),
                            color: secondary,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20, right: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                TextWidget(
                                  text: '2x     Coffee and Cake',
                                  fontSize: 15,
                                  fontFamily: 'Bold',
                                  color: Colors.white,
                                ),
                                TextWidget(
                                  text: 'Total: ₱ 598',
                                  fontSize: 14,
                                  fontFamily: 'Regular',
                                  color: Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: TextWidget(
                            text: 'Change',
                            fontSize: 15,
                            fontFamily: 'Medium',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextWidget(
                    text: 'Delivery Address',
                    fontSize: 20,
                    fontFamily: 'Bold',
                    color: secondary,
                  ),
                  Center(
                    child: Card(
                      child: Container(
                        width: 320,
                        height: 160,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: secondary),
                          borderRadius: BorderRadius.circular(
                            10,
                          ),
                          image: const DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(
                              'assets/images/Rectangle 3.png',
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                padding:
                                    const EdgeInsets.only(left: 15, right: 15),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    TextWidget(
                                      text: '7th Avenue, 2nd St.',
                                      fontSize: 15,
                                      fontFamily: 'Bold',
                                      color: Colors.white,
                                    ),
                                    TextWidget(
                                      text: 'Edit',
                                      fontSize: 14,
                                      fontFamily: 'Regular',
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
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
                  for (int i = 0; i < 2; i++)
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
                              value: i == 0 ? false : true,
                              groupValue: false,
                              onChanged: (value) {},
                            ),
                            Image.asset(
                              i == 0
                                  ? 'assets/images/image 5.png'
                                  : 'assets/images/image 6.png',
                              width: 80,
                              height: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Container(
                              width: 50,
                              height: 15,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                  color: secondary,
                                ),
                              ),
                              child: Center(
                                child: TextWidget(
                                  text: 'Link now',
                                  fontSize: 8,
                                  color: secondary,
                                ),
                              ),
                            ),
                            const Expanded(
                              child: SizedBox(
                                width: 10,
                              ),
                            ),
                            TextWidget(
                              text: '+ 2% Transfer fee',
                              fontSize: 12,
                              color: secondary,
                              fontFamily: 'Bold',
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                      ),
                    ),
                  for (int i = 0; i < 2; i++)
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
                              groupValue: false,
                              onChanged: (value) {},
                            ),
                            i == 0
                                ? Row(
                                    children: [
                                      Image.asset(
                                        'assets/images/clarity_bank-solid.png',
                                        width: 25,
                                        height: 25,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      TextWidget(
                                        text: 'Bank Transfer',
                                        fontSize: 15,
                                        color: secondary,
                                        fontFamily: 'Bold',
                                      ),
                                    ],
                                  )
                                : TextWidget(
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
                            i != 0
                                ? const SizedBox()
                                : TextWidget(
                                    text: '+ 2% Transfer fee',
                                    fontSize: 12,
                                    color: secondary,
                                    fontFamily: 'Bold',
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
                        text: '₱ 800.00',
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
