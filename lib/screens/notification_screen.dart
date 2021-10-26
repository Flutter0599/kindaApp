import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/utils/size_config.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 15),
            child: IconButton(
              icon: Icon(Feather.chevron_left, color: Colors.black54),
              onPressed: () {
                x.setMenuBottomIndex(4);
              },
            ),
          ),
          backgroundColor: Colors.white,
          title: Text("Notifications", style: TextStyle(color: Colors.black54)),
          elevation: 0.25,
          centerTitle: true,
        ),
        body: SafeArea(
            child: Center(
          child: Text('Notifications empty at the moment'),
        )),
      ),
    );
  }
}
