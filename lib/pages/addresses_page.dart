import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/pages/add_address_page.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/widgets/mini_default_button.dart';

class AddressesPage extends StatefulWidget {
  AddressesPage({Key? key}) : super(key: key);

  @override
  _AddressesPageState createState() => _AddressesPageState();
}

class _AddressesPageState extends State<AddressesPage> {
  final x = XController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 15),
            child: IconButton(
              icon: Icon(Feather.chevron_left, color: Colors.black54),
              onPressed: () {
                Get.back();
              },
            ),
          ),
          backgroundColor: Colors.white,
          title: Text("Addresses", style: TextStyle(color: Colors.black54)),
          elevation: 0.25,
          centerTitle: true,
          actions: [
            IconButton(
                icon: Icon(Feather.plus_circle, color: mainColor),
                onPressed: () {
                  Get.to(AddAddressPage({}));
                })
          ],
        ),
        body: SafeArea(
            child: x.addresses.isEmpty
                ? showEmptyAddresses()
                : showAddressesList()));
  }

  Widget showEmptyAddresses() {
    return Column(
      children: [
        Spacer(),
        Icon(
          Feather.alert_triangle,
          size: 120,
          color: mainColor,
        ),
        spaceHeight20,
        Text('You have no address ...'),
        spaceHeight15,
        SizedBox(
          width: 250,
          child: MiniDefaultButton(
            text: "Add new Address",
            press: () => Get.to(AddAddressPage({})),
          ),
        ),
        Spacer(),
      ],
    );
  }

  Widget showAddressesList() {
    return Obx(
      () => Column(
        children: [
          ListView.builder(
            shrinkWrap: true,
            itemCount: x.addresses.length,
            itemBuilder: (context, index) => Text(x.addresses[index].fisrtName),
          ),
        ],
      ),
    );
  }
}
