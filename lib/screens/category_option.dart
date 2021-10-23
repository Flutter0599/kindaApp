import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kindashop/app/home_page.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/default_button.dart';
import 'package:kindashop/widgets/transparent_image.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ItemCategory {
  ItemCategory();
  dynamic categ;
  bool selected = false;
}

class ListItemCategory {
  ListItemCategory();
  List<ItemCategory> itemCategories = [];
}

class CategoryOption extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: true,
        child: SizedBox(
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 3,
                child: Container(
                  child: Column(
                    children: [
                      SizedBox(height: Get.mediaQuery.padding.top),
                      Text("Choose your favorite\nshopping categories",
                          style: Get.theme.textTheme.headline5!
                              .copyWith(fontWeight: FontWeight.bold)),
                      spaceHeight10,
                      Text(
                        "You can choose more tharn one",
                        style: TextStyle(color: greyInputSoft),
                      ),
                      spaceHeight15,
                      Obx(
                        () => x.itemHome.value.datas != null &&
                                x.itemHome.value.datas!.length > 0
                            ? Flexible(
                                child: createGridCategories(x,
                                    x.itemHome.value.datas![0]['categories']),
                              )
                            : XController.loading(),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Column(
                    children: <Widget>[
                      Spacer(),
                      Spacer(flex: 3),
                      DefaultButton(
                        text: "Continue",
                        press: () {
                          gotoHomePage(false);
                        },
                      ),
                      spaceHeight10,
                      InkWell(
                          onTap: () {
                            gotoHomePage(true);
                          },
                          child: Text("Skip for now",
                              style: TextStyle(color: greyInputSoft))),
                      Spacer(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  gotoHomePage(bool isSkip) {
    final XController x = XController.to;

    if (!isSkip) {
      String getSelectedIds = "";
      listItemCategs.value.itemCategories.forEach((ItemCategory element) {
        if (element.selected) {
          getSelectedIds = "${element.categ['id_category']},$getSelectedIds";
        }
      });

      if (getSelectedIds == '') {
        EasyLoading.showToast("Pick at least one item category");
        return;
      }
      var selectedCategory =
          getSelectedIds.trim().substring(0, getSelectedIds.trim().length - 1);
      print("selectedCategory: $selectedCategory");

      x.setCategChosen(selectedCategory);
    }

    x.setIsFirst(false);
    x.getHome();
    Get.offAll(HomePage());
  }

  final listItemCategs = ListItemCategory().obs;
  Widget createGridCategories(final XController x, final List<dynamic> datas) {
    List<ItemCategory> itemCategs = [];
    datas.forEach((dynamic element) {
      int index = datas.indexOf(element);
      bool selected = true;
      if (index > 0) selected = false;

      itemCategs.add(ItemCategory()
        ..categ = element
        ..selected = selected);
    });

    listItemCategs.update((val) {
      val!.itemCategories = itemCategs;
    });

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: GridView.builder(
        shrinkWrap: true,
        itemCount: datas.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 3,
            mainAxisSpacing: 20,
            crossAxisSpacing: 10),
        itemBuilder: (BuildContext context, int index) {
          //ItemCategory itemCateg = itemCategs[index];
          return Obx(
            () => InkWell(
              onTap: () {
                itemCategs.elementAt(index).selected =
                    !itemCategs.elementAt(index).selected;

                listItemCategs.update((val) {
                  val!.itemCategories = itemCategs;
                });
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                      color: listItemCategs.value.itemCategories[index].selected
                          ? Colors.transparent
                          : Colors.black12),
                  color: listItemCategs.value.itemCategories[index].selected
                      ? mainColor
                      : Colors.white,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 5),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: FadeInImage.memoryNetwork(
                          placeholder: kTransparentImage,
                          image: itemCategs[index].categ['image'],
                          width: 22,
                          height: 22,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      width: Get.width / 3.7,
                      child: Text(itemCategs[index].categ['nm_category'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: itemCategs[index].selected
                                  ? Colors.white
                                  : Colors.black87)),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
