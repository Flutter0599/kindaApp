import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/screens/profile_screen.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';

class HistoryPage extends StatelessWidget {
  HistoryPage() {
    XController.to.getHome();
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
        top: true,
        child: Column(
          children: <Widget>[
            topButton(),
            Flexible(
              child: Obx(
                () => x.itemHome.value.datas != null &&
                        x.itemHome.value.datas!.length > 0
                    ? listTrans(x, x.itemHome.value.datas![0]['trans'])
                    : XController.loading(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget listTrans(final XController x, final List<dynamic>? trans) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: trans == null || trans.length < 1
          ? Container(
              margin: EdgeInsets.only(top: Get.height / 4),
              alignment: Alignment.center,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/bag_discount.jpeg",
                    height: getProportionateScreenHeight(200),
                  ),
                  Text("Data history not found.."),
                ],
              ),
            )
          : ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: trans.map((dynamic e) {
                return InkWell(
                  onTap: () {},
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: backgroundBox,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("#${e['no_trans']}",
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text("${e['date_created']}",
                            style: TextStyle(
                                fontSize: 11,
                                color: greyInput,
                                fontWeight: FontWeight.w500)),
                        Container(
                          alignment: Alignment.centerRight,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: 10, right: 10, bottom: 5, top: 1),
                            child: Text(
                              "${x.defCurrency.value}${double.parse(e['price'])}",
                              maxLines: 1,
                              style: Get.theme.textTheme.bodyText1!.copyWith(
                                  color: mainColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        Text("${e['address']}, ${e['city']}, ${e['zip']}"),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                                "${e['nm_payment_method']}, ${e['nm_service']}",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            InkWell(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 2),
                                margin: EdgeInsets.only(bottom: 0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: mainColor,
                                ),
                                child: Row(
                                  children: [
                                    spaceWidth5,
                                    Text(
                                        "${getStatusTrans(int.parse(e['status']))}",
                                        style: TextStyle(color: Colors.white)),
                                    Icon(Feather.chevron_right,
                                        color: Colors.white),
                                  ],
                                ),
                              ),
                              onTap: () async {
                                await pushGetDetailByTrans(x, e['no_trans']);
                                ProfileScreen.showModalSignUpScreen(
                                    x, detailTransScreen(x));
                              },
                            )
                          ],
                        ),
                        spaceHeight10
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
    );
  }

  String getStatusTrans(final int status) {
    String result = "Process";
    switch (status) {
      case 2:
        result = "Done";
        break;
      case 3:
        result = "Void";
        break;
      default:
    }

    return result;
  }

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
            "History",
            textAlign: TextAlign.center,
            style: TextStyle(color: greyInput, fontSize: 19),
          ),
          spaceWidth20,
        ],
      ),
    );
  }

  pushGetDetailByTrans(final XController x, final String no) async {
    try {
      details.value = [];

      EasyLoading.show(status: "Loading...");
      await Future.delayed(Duration(milliseconds: 800));

      var dataPush =
          jsonEncode({"im": "${x.member['id_member']}", "no": "$no"});
      //print(dataPush);

      final response = await x.pushResponse("home/gettrans_byim", dataPush);
      //print(response.body);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.body);
        //print(_result);
        if (_result['code'] == '200') {
          //print(_result['trans'][0]['detail']);
          List<dynamic> dets = _result['result'][0]['trans'][0]['detail'];
          //print(dets);
          details.value = dets;
          //dets.forEach((element) {
          //  details.value.add(element);
          //});
        }
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

  // get detail row
  final details = [].obs;
  Widget detailTransScreen(final XController x) {
    return Container(
      child: Obx(
        () =>
            details.length > 0 ? listDetail(x, details) : XController.loading(),
      ),
    );
  }

  Widget listDetail(final XController x, final List<dynamic> details) {
    return ListView(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      children: details.map((dynamic e) {
        double total =
            double.parse("${e['qty']}") * double.parse("${e['price']}");
        return InkWell(
          onTap: () {},
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            margin: EdgeInsets.only(bottom: 10, left: 15, right: 15),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: softerMainColor,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceHeight10,
                Row(
                  children: [
                    Flexible(
                      child: Text("${e['nm_product']}",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        //sliders[index]['image']
                        child: ExtendedImage.network(
                          "${e['image1']}",
                          width: getProportionateScreenHeight(35),
                          height: getProportionateScreenHeight(35),
                          fit: BoxFit.cover,
                          cache: true,
                        ),
                      ),
                    ),
                  ],
                ),
                Text("QTY: ${e['qty']}",
                    style: TextStyle(
                        fontSize: 14,
                        color: greyInput,
                        fontWeight: FontWeight.w500)),
                Text("${e['scolor']}, ${e['ssize']}",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Container(
                  alignment: Alignment.centerRight,
                  child: Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 1),
                    child: Text(
                      "${x.defCurrency.value}$total",
                      maxLines: 1,
                      style: Get.theme.textTheme.bodyText1!.copyWith(
                          color: mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                spaceHeight10
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
