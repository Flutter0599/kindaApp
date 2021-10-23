import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/default_button.dart';

class ItemCreditCard {
  ItemCreditCard();
  String? cardNumber = '';
  String? expiryDate = '';
  String? cardHolderName = '';
  String? cvvCode = '';
  bool? isCvvFocused = false;
}

class InputCardPage extends StatelessWidget {
  final Map<String, dynamic> params;
  InputCardPage(this.params);

  final itemCreditCard = ItemCreditCard().obs;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    //final XController x = XController.to;

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SafeArea(
        top: true,
        child: Column(
          children: <Widget>[
            topButton(),
            CreditCardWidget(
              cardNumber: itemCreditCard.value.cardNumber!,
              expiryDate: itemCreditCard.value.expiryDate!,
              cardHolderName: itemCreditCard.value.cardHolderName!,
              cvvCode: itemCreditCard.value.cvvCode!,
              showBackView: itemCreditCard.value.isCvvFocused!,
              obscureCardNumber: true,
              obscureCardCvv: true, onCreditCardWidgetChange: (CreditCardBrand ) {  },
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: SingleChildScrollView(
                  child: Column(
                    children: <Widget>[
                      CreditCardForm(
                        formKey: formKey,
                        obscureCvv: true,
                        obscureNumber: true,
                        cardNumber: itemCreditCard.value.cardNumber!,
                        cvvCode: itemCreditCard.value.cvvCode!,
                        cardHolderName: itemCreditCard.value.cardHolderName!,
                        expiryDate: itemCreditCard.value.expiryDate!,
                        themeColor: mainColor,
                        cardNumberDecoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundBox,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.black12.withOpacity(0.1),
                                width: 0.5),
                          ),
                          labelText: 'Number',
                          hintText: 'XXXX XXXX XXXX XXXX',
                        ),
                        expiryDateDecoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundBox,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.black12.withOpacity(0.1),
                                width: 0.5),
                          ),
                          labelText: 'Expired Date',
                          hintText: 'XX/XX',
                        ),
                        cvvCodeDecoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundBox,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.black12.withOpacity(0.1),
                                width: 0.5),
                          ),
                          labelText: 'CVV',
                          hintText: 'XXX',
                        ),
                        cardHolderDecoration: InputDecoration(
                          filled: true,
                          fillColor: backgroundBox,
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(30.0)),
                            borderSide: BorderSide(
                                color: Colors.black12.withOpacity(0.1),
                                width: 0.5),
                          ),
                          labelText: 'Card Holder',
                        ),
                        onCreditCardModelChange: onCreditCardModelChange,
                      ),
                      Container(
                        width: Get.width / 1.5,
                        margin: EdgeInsets.only(top: 10),
                        child: DefaultButton(
                            text: "Validate",
                            press: () {
                              if (formKey.currentState!.validate()) {
                                print('valid!');
                                this.params['card'] = {
                                  "no": "${itemCreditCard.value.cardNumber}",
                                  "exp": "${itemCreditCard.value.expiryDate}",
                                  "nm":
                                      "${itemCreditCard.value.cardHolderName}",
                                  "cvv": "${itemCreditCard.value.cvvCode}",
                                };
                                //print(this.params);
                                Get.back(result: jsonEncode(this.params));
                              } else {
                                print('invalid!');
                                EasyLoading.showToast(
                                    "Please check your input...");
                              }
                            }),
                      ),
                      SizedBox(height: 350),
                      SizedBox(height: 350),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void onCreditCardModelChange(CreditCardModel? creditCardModel) {
    /*setState(() {
      cardNumber = creditCardModel!.cardNumber;
      expiryDate = creditCardModel.expiryDate;
      cardHolderName = creditCardModel.cardHolderName;
      cvvCode = creditCardModel.cvvCode;
      isCvvFocused = creditCardModel.isCvvFocused;
    });*/

    itemCreditCard.update((val) {
      val!.cardNumber = "${creditCardModel!.cardNumber}";
      val.expiryDate = "${creditCardModel.expiryDate}";
      val.cardHolderName = "${creditCardModel.cardHolderName}";
      val.cvvCode = "${creditCardModel.cvvCode}";
      val.isCvvFocused = creditCardModel.isCvvFocused;
    });
  }

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Widget topButton() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, top: 10),
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
          Text(
            "Credit Card",
            textAlign: TextAlign.center,
            style: TextStyle(color: greyInput, fontSize: 19),
          ),
          spaceWidth20,
        ],
      ),
    );
  }
}
