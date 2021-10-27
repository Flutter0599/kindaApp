import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/address_model.dart';
import 'package:kindashop/pages/ordernow_page.dart';
import 'package:kindashop/utils/custom_style.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/default_button.dart';

class AddAddressPage extends StatelessWidget {
  final Map<String, dynamic> params;
  AddAddressPage(this.params) {
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
      // String? dataDelivery = x.defDelivery.value;
      // if (dataDelivery.length > 5) {
      //   Future.delayed(Duration(milliseconds: 600), () {
      //     //$add#$city#$zip
      //     var split = dataDelivery.split("#");
      //     // addressController.text = split[0];
      //     cityController.text = split[1];
      //     zipController.text = split[2];
      //   });
      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    return Scaffold(
      body: Container(
        width: Get.width,
        height: Get.height,
        color: Colors.white,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                topButton(),
                spaceHeight10,
                createAddressForm(x),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController zipController = TextEditingController();

  final isChecked = false.obs;

  String? countryCode = '+962';

  Widget createAddressForm(final XController x) {
    return Container(
      width: Get.width,
      //height: Get.height,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "First Name",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          spaceHeight15,
          TextFormField(
            controller: firstNameController,
            keyboardType: TextInputType.name,
            maxLines: 1,
            validator: (String? value) {
              if (value!.isEmpty) {
                return "invalid name";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "Enter first name",
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
            "Last Name",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          spaceHeight15,
          TextFormField(
            controller: lastNameController,
            keyboardType: TextInputType.name,
            validator: (String? value) {
              if (value!.isEmpty) {
                return "invalid name";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "Enter last name",
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
            "Phone number",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          spaceHeight15,
          SizedBox(
            height: 48,
            child: Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Colors.black.withOpacity(0.1), width: 0.5),
                      color: backgroundBox,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(30),
                        topLeft: Radius.circular(30),
                      )),
                  child: buildCountryPicker(),
                ),
                Expanded(
                  child: TextFormField(
                    textAlignVertical: TextAlignVertical.center,
                    controller: phoneController,
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      if (value!.isEmpty) {
                        return "Zip Code invalid";
                      } else {
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                        vertical: 10.0,
                        horizontal: 10.0,
                      ),
                      hintText: "Enter phone number",
                      labelStyle: CustomStyle.textStyle,
                      filled: true,
                      fillColor: backgroundBox,
                      hintStyle: CustomStyle.textStyle,
                      focusedBorder: CustomStyle.cityFocusBorder,
                      enabledBorder: CustomStyle.cityFocusBorder,
                      focusedErrorBorder: CustomStyle.cityFocusBorder,
                      errorBorder: CustomStyle.cityFocusBorder,
                    ),
                  ),
                ),
              ],
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
            keyboardType: TextInputType.name,
            validator: (String? value) {
              if (value!.isEmpty) {
                return "invalid city";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
              hintText: "Enter your city",
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
            textAlignVertical: TextAlignVertical.center,
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
              hintText: "Enter zip code",
              contentPadding: EdgeInsets.only(
                left: 10.0,
                right: 10.0,
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
          // Row(
          //   children: [
          //     Obx(
          //       () => Checkbox(
          //         value: isChecked.value,
          //         onChanged: (value) {
          //           isChecked.value = !isChecked.value;
          //         },
          //       ),
          //     ),
          //     Text("Billing Address same as Delivery")
          //   ],
          // ),
          spaceHeight20,
          spaceHeight10,
          Container(
            alignment: Alignment.center,
            width: Get.width / 1.2,
            height: 70,
            child: DefaultButton(
              text:
                  //"Payment ${x.defCurrency.value}${x.numberFormatDec(params['total'], 2)}",
                  "Add Address",
              press: () {
                String firstName = firstNameController.text;
                String lastName = lastNameController.text;
                String phone = phoneController.text;
                String city = cityController.text;
                String zipCode = zipController.text;

                if (firstName.isEmpty) {
                  EasyLoading.showToast("First name is empty...");
                  return;
                }

                if (lastName.isEmpty) {
                  EasyLoading.showToast("Last name is empty...");
                  return;
                }

                if (zipCode.isEmpty) {
                  EasyLoading.showToast(" Zip Code is empty...");
                  return;
                }
                if (phone.isEmpty) {
                  EasyLoading.showToast("Phone is empty...");
                  return;
                }
                if (city.isEmpty) {
                  EasyLoading.showToast("City is empty...");
                  return;
                }

                ///save to getStorage

                x.saveNewAddress(Address(
                    fisrtName: firstName,
                    lastName: lastName,
                    phone: countryCode! + phone,
                    city: city,
                    zipCode: zipCode));

                // Map<String, dynamic> post = {
                //   "add": "$add",
                //   "city": "$city",
                //   "zip": "$zip",
                // };

                // params['address'] = post;

                // gotoPayOrder(params);
                EasyLoading.showToast('New addredd added');
                Get.back();
              },
            ),
          ),
        ],
      ),
    );
  }

  gotoPayOrder(final Map<String, dynamic> post) {
    Get.to(OrdernowPage(post));
  }

  Widget buildCountryPicker() {
    return CountryCodePicker(
      padding: EdgeInsets.zero,
      onChanged: (x) {
        countryCode = x.dialCode;
      },
      textStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
        fontSize: 16,
      ),
      hideMainText: false,
      // Initial selection and favorite can be one of code ('IT') OR dial_code('+39')
      initialSelection: 'JO',
      favorite: ['PS', 'DE'],
      // optional. Shows only country name and flag
      showCountryOnly: false,
      // optional. Shows only country name and flag when popup is closed.
      showOnlyCountryWhenClosed: false,
      // optional. aligns the flag and the Text left
      alignLeft: false,
      //countryFilter: ['JO', 'PS'],
      flagDecoration: BoxDecoration(
        borderRadius: BorderRadius.circular(3),
      ),
      backgroundColor: Colors.grey.withOpacity(0.2),
      closeIcon: Icon(Feather.x, color: mainColor),
      boxDecoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(18)),
    );
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
