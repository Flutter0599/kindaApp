import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/pages/ordernow_page.dart';
import 'package:kindashop/utils/custom_style.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/default_button.dart';

class CheckoutPage extends StatelessWidget {
  final Map<String, dynamic> params;
  CheckoutPage(this.params) {
    final XController x = XController.to;
    if (x.member['id_member'] == null) {
      EasyLoading.showToast(
        "Login required, please Sign in your account...\nGo to Menu User Profile...\nThank you",
        duration: Duration(seconds: 5),
      );

      Future.delayed(Duration(milliseconds: 1500), () {
        Get.back();
        Future.delayed(Duration(milliseconds: 1500), () {
          Get.back();
          x.setMenuBottomIndex(3);
        });
      });
    } else {
      String? dataDelivery = x.defDelivery.value;
      if (dataDelivery.length > 5) {
        Future.delayed(Duration(milliseconds: 600), () {
          //$add#$city#$zip
          var split = dataDelivery.split("#");
          addressController.text = split[0];
          cityController.text = split[1];
          zipController.text = split[2];
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.yellow,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topButton(),
            spaceHeight10,
            Flexible(
              child: createAddressForm(x),
            ),
          ],
        ),
      ),
    );
  }

  final TextEditingController addressController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final isChecked = false.obs;

  Widget createAddressForm(final XController x) {
    return Container(
      width: Get.width,
      height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delivery",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                spaceHeight15,
                TextFormField(
                  controller: addressController,
                  keyboardType: TextInputType.multiline,
                  maxLines: 1,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Delivery invalid";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Residence State",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    labelStyle: CustomStyle.textStyle,
                    filled: true,
                    fillColor: backgroundBox,
                    hintStyle: CustomStyle.textStyle,
                    focusedBorder: CustomStyle.focusBorder,
                    enabledBorder: CustomStyle.focusErrorBorder,
                    focusedErrorBorder: CustomStyle.focusErrorBorder,
                    errorBorder: CustomStyle.focusErrorBorder,
                  ),
                ),
                spaceHeight15,
                Text(
                  "City",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                spaceHeight15,
                TextFormField(
                  controller: cityController,
                  keyboardType: TextInputType.text,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "City invalid";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "Jakarta Indonesia",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    labelStyle: CustomStyle.textStyle,
                    filled: true,
                    fillColor: backgroundBox,
                    hintStyle: CustomStyle.textStyle,
                    focusedBorder: CustomStyle.focusBorder,
                    enabledBorder: CustomStyle.focusErrorBorder,
                    focusedErrorBorder: CustomStyle.focusErrorBorder,
                    errorBorder: CustomStyle.focusErrorBorder,
                  ),
                ),
                spaceHeight15,
                Text(
                  "Zip Code",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                spaceHeight15,
                TextFormField(
                  controller: zipController,
                  keyboardType: TextInputType.number,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return "Zip Code invalid";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                    hintText: "12750",
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0,
                      horizontal: 10.0,
                    ),
                    labelStyle: CustomStyle.textStyle,
                    filled: true,
                    fillColor: backgroundBox,
                    hintStyle: CustomStyle.textStyle,
                    focusedBorder: CustomStyle.focusBorder,
                    enabledBorder: CustomStyle.focusErrorBorder,
                    focusedErrorBorder: CustomStyle.focusErrorBorder,
                    errorBorder: CustomStyle.focusErrorBorder,
                  ),
                ),
                Row(
                  children: [
                    Obx(
                      () => Checkbox(
                        value: isChecked.value,
                        onChanged: (value) {
                          isChecked.value = !isChecked.value;
                        },
                      ),
                    ),
                    Text("Billing Address same as Delivery")
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              alignment: Alignment.center,
              width: Get.width / 1.2,
              height: 70,
              child: DefaultButton(
                text:
                    "Payment ${x.defCurrency.value}${x.numberFormatDec(params['total'], 2)}",
                press: () {
                  String add = addressController.text;
                  String city = cityController.text;
                  String zip = zipController.text;

                  if (add.isEmpty) {
                    EasyLoading.showToast("Delivery Address invalid...");
                    return;
                  }

                  if (city.isEmpty) {
                    EasyLoading.showToast("Delivery City invalid...");
                    return;
                  }

                  if (zip.isEmpty) {
                    EasyLoading.showToast("Delivery Zip Code invalid...");
                    return;
                  }

                  x.saveDeliveryAddress("$add#$city#$zip");

                  Map<String, dynamic> post = {
                    "add": "$add",
                    "city": "$city",
                    "zip": "$zip",
                  };

                  params['address'] = post;

                  gotoPayOrder(params);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  gotoPayOrder(final Map<String, dynamic> post) {
    Get.to(OrdernowPage(post));
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
                    "Address",
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
}
