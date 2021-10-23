import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/service_model.dart';
import 'package:kindashop/pages/input_card_page.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/default_button.dart';

class OrdernowPage extends StatelessWidget {
  final Map<String, dynamic> params;
  OrdernowPage(this.params) {
    print(this.params);
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topButton(x),
            spaceHeight10,
            Flexible(
              child: createPaymentForm(x),
            ),
          ],
        ),
      ),
    );
  }

  Widget createPaymentForm(final XController x) {
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
                  "Payment Method",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => listMenuPayment(
                      x,
                      x.itemHome.value.datas![0]['payment_methods'],
                      indexPayment.value),
                ),
                spaceHeight15,
                spaceHeight15,
                Text(
                  "Shipping Services",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                Obx(
                  () => listMenuServices(
                      x,
                      x.itemHome.value.datas![0]['services'],
                      indexService.value),
                ),
                spaceHeight15,
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
                text: "Order Now",
                press: () async {
                  Map<String, dynamic> post = {
                    "id_payment": x.itemHome.value.datas![0]['payment_methods']
                        [indexPayment.value]['id_pay_method'],
                    "id_service": x.itemHome.value.datas![0]['services']
                        [indexService.value]['id_service']
                  };

                  if (indexPayment.value == 2) {
                    final String? getParams =
                        await Get.to(InputCardPage(params));

                    if (getParams != null) {
                      //print(getParams);
                      Map<String, dynamic> newparams = jsonDecode(getParams);
                      newparams['payment'] = post;
                      newparams['im'] = x.member['id_member'];
                      //print(newparams);

                      pushOrderNow(x, newparams);
                    }
                  } else {
                    params['payment'] = post;
                    params['im'] = x.member['id_member'];
                    pushOrderNow(x, params);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  pushOrderNow(final XController x, final Map<String, dynamic> dataJson) async {
    //print(json);

    try {
      EasyLoading.show(status: "Loading...");
      await Future.delayed(Duration(milliseconds: 800));

      var dataPush = jsonEncode(dataJson);
      //print(dataPush);

      final response = await x.pushResponse("home/insert_trans", dataPush);
      //print(response.body);

      if (response != null && response.statusCode == 200) {
        //dynamic _result = jsonDecode(response.body);
        //print(_result);
        String message = "Process success..\nThank you";

        Get.back();
        Future.delayed(Duration(milliseconds: 1200), () async {
          Get.back();
          x.clearCarts();

          showModalSuccess(x);

          await EasyLoading.showToast(message,
              duration: Duration(milliseconds: 1500));
          x.getHome();
          x.setMenuBottomIndex(0);
        });
      } else {
        Future.delayed(Duration(milliseconds: 1200), () {
          EasyLoading.showToast(
              "Failed, Network error, check your connectivity...");
        });
      }

      EasyLoading.dismiss();
    } catch (e) {
      print("error get home $e");
    }
  }

  final indexPayment = 0.obs;
  Widget listMenuPayment(
      final XController x, final List<dynamic> payments, final int indexMenu) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      height: 50,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: payments.map((dynamic e) {
          int index = payments.indexOf(e);
          return InkWell(
            onTap: () {
              indexPayment.value = index;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 0,
                  right: (index >= payments.length - 1) ? 15 : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: indexPayment.value == index
                    ? softMainColor.withOpacity(.5)
                    : backgroundBox,
              ),
              child: Row(
                children: [
                  Container(
                    width: 55,
                    height: 30,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ExtendedImage.network(
                        "${e['logo_pay_method']}",
                        fit: BoxFit.contain,
                        cache: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  final indexService = 0.obs;
  Widget listMenuServices(
      final XController x, final List<dynamic>? temps, final int indexMenu) {
    List<Service> services = [];
    try {
      if (temps != null && temps.length > 0) {
        temps.forEach((element) {
          Map<String, dynamic> service = element;
          services.add(Service.fromData(service));
        });
      }
    } catch (e) {}

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      height: 40,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: services.map((Service e) {
          int index = services.indexOf(e);
          //print(e.logo);
          return InkWell(
            onTap: () {
              indexService.value = index;
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              margin: EdgeInsets.only(
                  left: index == 0 ? 0 : 0,
                  right: (index >= services.length - 1) ? 15 : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: indexService.value == index
                    ? softMainColor.withOpacity(.5)
                    : backgroundBox,
              ),
              child: Row(
                children: [
                  Container(
                    width: 75,
                    height: 30,
                    margin: EdgeInsets.only(right: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: ExtendedImage.network(
                        "${e.logo}",
                        fit: BoxFit.contain,
                        cache: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget topButton(final XController x) {
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
                    "Payment ${x.defCurrency.value}${x.numberFormatDec(params['total'], 2)}",
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

  static showModalSuccess(final XController x) {
    showCupertinoModalBottomSheet(
      expand: true,
      context: Get.context!,
      backgroundColor: Colors.transparent,
      barrierColor: backgroundBox.withOpacity(.6),
      builder: (context) => Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Get.mediaQuery.padding.top * 2,
              ),
              child: Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: Image.asset(
                          "assets/img_success.jpg",
                          width: Get.width / 1.3,
                          height: Get.height / 3.2,
                        ),
                      ),
                      Container(
                        child: Text(
                          "Order Success",
                          style: Get.theme.textTheme.headline6!.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      spaceHeight10,
                      Container(
                        child: Text(
                          "Your package will be sent to your\naddress, thanks for order.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: greyInput),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 5,
              top: 5,
              child: IconButton(
                onPressed: () {
                  Get.back();
                },
                icon: Icon(
                  Feather.chevron_down,
                  size: 28,
                  color: Colors.black54,
                ),
              ),
            ),
            Positioned(
              bottom: getProportionateScreenHeight(20),
              left: getProportionateScreenHeight(20),
              right: getProportionateScreenHeight(20),
              child: Container(
                alignment: Alignment.center,
                width: Get.width / 1.2,
                height: 70,
                child: DefaultButton(
                  text: "Back to Home",
                  press: () {
                    Get.back();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
