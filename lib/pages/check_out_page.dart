import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/utils/dimension_color.dart';

class CheckoutPage extends StatefulWidget {
  CheckoutPage({Key? key}) : super(key: key);

  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: [
          topButton(),
        ],
      )),
    );
  }
}

Widget topButton() {
  //final XController x = XController.to;
  return Container(
    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          width: Get.width / 1.1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Feather.chevron_left, size: 25, color: greyInput),
                onPressed: () {
                  Get.back();
                },
              ),
              Container(
                child: Text(
                  "Checkout",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: greyInput, fontSize: 19),
                ),
              ),
              spaceWidth20,
            ],
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: backgroundBox,
          ),
          child: SizedBox.shrink(),
        ),
      ],
    ),
  );
}
