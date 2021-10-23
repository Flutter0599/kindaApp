import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';

class SharePage extends StatelessWidget {
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
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: Get.height / 4.5,
                    ),
                    createSharePackage(x),
                    spaceHeight10,
                    Divider(),
                    spaceHeight10,
                    createShareReferral(x)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createSharePackage(final XController x) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Tell your friend about MShopping",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Make your own community \nmall shooping online",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: greyInput),
            ),
          ),
          spaceHeight20,
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 70,
              height: 70,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: backgroundBox,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: IconButton(
                  icon: Icon(Feather.share, color: mainColor),
                  onPressed: () {
                    XController.shareContent(null,
                        "Give your website link, Play Store link to install...");
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget createShareReferral(final XController x) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Your referral code: ${x.member['code'].toString().toUpperCase()}",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Get your promo, rewards \nand many more benefits",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: greyInput),
            ),
          ),
          spaceHeight20,
          Container(
            alignment: Alignment.center,
            child: Container(
              width: 70,
              height: 70,
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: mainColor,
                borderRadius: BorderRadius.circular(30),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: IconButton(
                  icon: Icon(Feather.share_2, color: Colors.white),
                  onPressed: () {
                    XController.shareContent(null,
                        "Referral code ${x.member['code'].toString().toUpperCase()}\nTo find more promo an rewards.");
                  },
                ),
              ),
            ),
          )
        ],
      ),
    );
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
            "Share",
            textAlign: TextAlign.center,
            style: TextStyle(color: greyInput, fontSize: 19),
          ),
          spaceWidth50,
        ],
      ),
    );
  }
}
