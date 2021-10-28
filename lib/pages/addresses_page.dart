import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/address_model.dart';
import 'package:kindashop/pages/add_address_page.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/widgets/default_button.dart';
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
        body: Obx(
          () => SafeArea(
              child: x.addresses.isEmpty
                  ? showEmptyAddresses()
                  : showAddressesList()),
        ));
  }

  Widget showEmptyAddresses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Spacer(),
        Icon(
          Feather.alert_triangle,
          size: 120,
          color: mainColor,
        ),
        spaceHeight20,
        SizedBox(
            width: double.infinity,
            child: Text(
              'You have no address ...',
              textAlign: TextAlign.center,
            )),
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
    return Padding(
      padding: const EdgeInsets.all(12),
      child: SizedBox(
        width: Get.width,
        height: Get.height,
        child: Stack(
          children: [
            ListView.builder(
              padding: EdgeInsets.only(bottom: 40),
              physics: ScrollPhysics(),
              shrinkWrap: true,
              itemCount: x.addresses.length,
              itemBuilder: (context, index) => buildAddressCard(
                  x.addresses[index],
                  () => x.toggleAddressSelection(x.addresses[index])),
            ),
            Positioned(
                bottom: 2,
                left: 50,
                right: 50,
                child: MiniDefaultButton(
                  press: () {
                    EasyLoading.showToast('Comming Soon ...');
                  },
                  text: 'Proceed',
                ))
          ],
        ),
      ),
    );
  }

  Widget buildAddressCard(Address address, Function() ontap) {
    return InkWell(
      onTap: ontap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        margin: EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: address.isSelected
              ? Border.all(color: mainColor, width: 2)
              : null,
          borderRadius: BorderRadius.circular(20),
          color: backgroundBox,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    address.fisrtName + ' ' + address.lastName,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text("phone", style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    address.phone,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text("City", style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    address.city,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            Row(
              children: [
                Text("Zip Code", style: TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Text(
                    address.zipCode,
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            ),
            spaceHeight10
          ],
        ),
      ),
    );
  }
}
