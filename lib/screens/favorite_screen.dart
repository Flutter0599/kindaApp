import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/pages/product_detail.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/custom_check_box.dart';

class FavoriteScreen extends StatelessWidget {
  final itemFavorites = [].obs;
  FavoriteScreen() {
    itemFavorites.value = XController.to.favorites;
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
            title: Text("Favorite", style: TextStyle(color: Colors.black54)),
            elevation: 0.25,
            centerTitle: true,
            actions: [
              IconButton(
                  icon: Icon(Feather.x, color: mainColor),
                  onPressed: () {
                    //delete all selected
                    String arrayVal = arrayIndexSelected.value;
                    List<String> split = arrayVal.split("#");
                    if (x.favorites.length == split.length - 1) {
                      EasyLoading.showToast("Clear your wishlist...");
                      x.clearFavorite();
                      x.setMenuBottomIndex(0);
                    } else {
                      if (arrayVal != '' && split.length > 0) {
                        split.forEach((String idp) {
                          if (idp != '') {
                            x.toggleFavorites(x.getItemFavoriteById(idp)!);
                          }
                        });
                      } else {
                        EasyLoading.showToast("No item selected...");
                      }
                    }
                  }),
            ],
          ),
          body: Container(
            width: Get.width,
            height: Get.height,
            color: Colors.white,
            child: SingleChildScrollView(
              child: Obx(
                () => x.counterFavorite.value > 0
                    ? createListFavorites(
                        x, x.favorites, arrayIndexSelected.value)
                    : Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        alignment: Alignment.center,
                        height: Get.height / 1.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset("assets/bag_discount.jpeg", width: 180),
                            spaceHeight5,
                            Container(
                              child: Text("Your wishlist not found"),
                            ),
                          ],
                        ),
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final arrayIndexSelected = "".obs;
  bool checkArrayIndexExist(String id) {
    List<String> split = arrayIndexSelected.value.split("#");
    if (split.length > 0) {
      var checked;
      try {
        checked = split.firstWhere((idx) => idx == id);
      } catch (e) {}
      return checked != null;
    }
    return false;
  }

  toggleCheckedItem(String id) {
    bool check = checkArrayIndexExist(id);
    if (!check) {
      arrayIndexSelected.value = "$id#${arrayIndexSelected.value}";
    } else {
      removeSelectedFromId(id);
    }
  }

  removeSelectedFromId(String id) {
    List<String> split = arrayIndexSelected.value.split("#");
    if (split.length > 0) {
      arrayIndexSelected.value = "";

      split.forEach((String idp) {
        if (idp != '' && idp != id) {
          arrayIndexSelected.value = "$idp#${arrayIndexSelected.value}";
        }
      });
    }
  }

  Widget createListFavorites(final XController x, final List<Product> favs,
      final String arraySelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: favs.map((Product product) {
          return Container(
            margin: EdgeInsets.only(bottom: 20),
            child: Row(
              children: [
                Container(
                  child: CustomCheckBox(
                    value: checkArrayIndexExist(product.id!),
                    shouldShowBorder: false,
                    uncheckedFillColor: backgroundBox,
                    borderColor: Colors.red,
                    checkedFillColor: Colors.red,
                    uncheckedIcon: Feather.x,
                    borderRadius: 8,
                    borderWidth: 1,
                    checkBoxSize: 22,
                    onChanged: (val) {
                      //print(val);
                      toggleCheckedItem(product.id!);
                    },
                  ),
                ),
                InkWell(
                  onTap: () {
                    gotoProductDetail(product);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      //sliders[index]['image']
                      child: ExtendedImage.network(
                        "${product.image1}",
                        width: getProportionateScreenHeight(80),
                        height: getProportionateScreenHeight(80),
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    gotoProductDetail(product);
                  },
                  child: Container(
                    width: Get.width / 2.45,
                    margin: EdgeInsets.only(left: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${product.name}",
                          maxLines: 2,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.bold),
                        ),
                        spaceHeight5,
                        Text(
                          "${x.getCategoryNameFromId(product.idcategory)}",
                          maxLines: 1,
                          style: TextStyle(color: Colors.grey),
                        ),
                        spaceHeight5,
                        Text(
                          "${x.defCurrency.value}${product.price}",
                          maxLines: 1,
                          style: Get.theme.textTheme.bodyText1!.copyWith(
                              color: mainColor,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: IconButton(
                    icon: Icon(Feather.trash, color: mainColor),
                    onPressed: () {
                      x.toggleFavorites(product);
                      removeSelectedFromId(product.id!);
                    },
                  ),
                )
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  gotoProductDetail(final Product product) {
    Get.to(ProductDetail(product));
  }
}
