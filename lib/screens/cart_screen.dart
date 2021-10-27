import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/pages/add_address_page.dart';
import 'package:kindashop/pages/addresses_page.dart';
import 'package:kindashop/pages/product_detail.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/custom_check_box.dart';
import 'package:kindashop/widgets/default_button.dart';
import 'package:kindashop/widgets/mini_default_button.dart';

class CartScreen extends StatelessWidget {
  final itemCarts = [].obs;
  CartScreen() {
    itemCarts.value = XController.to.carts;
  }
  final totalPayment = 0.0.obs;
  final selectedAll = false.obs;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    final double heightBottom = getProportionateScreenHeight(170);

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
            title: Text("Cart", style: TextStyle(color: Colors.black54)),
            elevation: 0.25,
            centerTitle: true,
            actions: [
              Obx(
                () => x.counterCart.value > 0
                    ? IconButton(
                        icon: Icon(Feather.x, color: mainColor),
                        onPressed: () {
                          //delete all selected
                          String arrayVal = arrayIndexSelected.value;
                          List<String> split = arrayVal.split("#");
                          if (x.carts.length == split.length - 1) {
                            EasyLoading.showToast("Clear your carts...");
                            x.clearCarts();
                            x.setMenuBottomIndex(4);
                          } else {
                            if (arrayVal != '' && split.length > 0) {
                              split.forEach((String idp) {
                                if (idp != '') {
                                  x.addRemoveItemCart(
                                      x.getItemCartById(idp)!, true);
                                }
                              });
                            } else {
                              EasyLoading.showToast("No item selected...");
                            }
                          }
                        })
                    : SizedBox.shrink(),
              ),
            ],
          ),
          body: Container(
            width: Get.width,
            height: Get.height,
            color: Colors.white,
            child: Stack(
              children: [
                Container(
                  width: Get.width,
                  height: Get.height - (heightBottom * 2.15),
                  margin: EdgeInsets.only(
                      bottom: getProportionateScreenHeight(30), top: 10),
                  child: SingleChildScrollView(
                    child: Obx(
                      () => x.counterCart.value > 0
                          ? createListCarts(
                              x, x.carts, arrayIndexSelected.value)
                          : SizedBox.shrink(),
                    ),
                  ),
                ),
                Obx(
                  () => x.counterCart.value < 1
                      ? emptyCart(x)
                      : Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            width: Get.width,
                            height: heightBottom,
                            decoration: BoxDecoration(
                              color: Colors.white10,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(33),
                                topRight: Radius.circular(33),
                              ),
                            ),
                            padding: EdgeInsets.symmetric(
                                horizontal: 0, vertical: 0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: backgroundBox.withOpacity(.5),
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(33),
                                  topRight: Radius.circular(33),
                                ),
                              ),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 22, vertical: 10),
                              child: Column(
                                children: [
                                  Container(
                                    width: Get.width / 1.3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text("Select All"),
                                        Obx(
                                          () => Container(
                                            child: CustomCheckBox(
                                              value: selectedAll.value,
                                              shouldShowBorder: false,
                                              uncheckedFillColor: backgroundBox,
                                              borderColor: Colors.red,
                                              checkedFillColor: Colors.red,
                                              uncheckedIcon: Feather.x,
                                              borderRadius: 8,
                                              borderWidth: 1,
                                              checkBoxSize: 22,
                                              onChanged: (val) {
                                                checkUnCheckAll(x, val);
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(top: 10),
                                    width: Get.width / 1.3,
                                    child: Container(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            width: 250,
                                            child: Obx(
                                              () => MiniDefaultButton(
                                                text:
                                                    "Checkout ${x.defCurrency.value}${x.numberFormatDec(totalPayment.value, 2)}",
                                                press: () {
                                                  if (totalPayment.value > 0) {
                                                    gotoCheckoutPage(x);
                                                  } else {
                                                    EasyLoading.showToast(
                                                        'No seleted item...');
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  gotoCheckoutPage(final XController x) {
    if (x.member['id_member'] == null) {
      EasyLoading.showToast("Login required...");
      Get.back();
      x.setMenuBottomIndex(3);
      return;
    } else {
      Map<String, dynamic> params = {};
      List<Map<String, dynamic>> details = [];
      x.carts.forEach((dynamic item) {
        String id = item['id_product'];
        bool checked = checkArrayIndexExist(id);
        if (checked) {
          details.add({
            "ip": "$id",
            "qty": "${item['qty']}",
            "price": "${item['price']}",
            "curr": "${item['currency']}",
            "color": "${item['selected_color']}",
            "size": "${item['selected_size']}"
          });
        }
      });
      params['details'] = details;
      params['total'] = totalPayment.value;

      //Get.to(AddAddressPage(params));
      Get.to(AddressesPage());
    }
  }

  Widget emptyCart(final XController x) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      alignment: Alignment.center,
      height: Get.height / 1.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            "assets/empty_cart.png",
            width: getProportionateScreenWidth(250),
            fit: BoxFit.fitHeight,
          ),
          Text("Your cart is empty"),
          spaceHeight20,
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: DefaultButton(
              text: "Back",
              press: () {
                x.setMenuCategoryIndex(0);
                x.setMenuBottomIndex(4);
              },
            ),
          ),
        ],
      ),
    );
  }

  final arrayIndexSelected = "".obs;
  checkUnCheckAll(final XController x, final bool checkAll) {
    itemCarts.value = x.carts;
    selectedAll.value = checkAll;

    if (checkAll) {
      arrayIndexSelected.value = "";
      x.carts.forEach((dynamic item) {
        String id = item['id_product'];
        if (id != '') {
          arrayIndexSelected.value = "$id#${arrayIndexSelected.value}";
        }
      });

      countSeletedItem(x);
    } else {
      totalPayment.value = 0;
      arrayIndexSelected.value = "";
    }
  }

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

  toggleCheckedItem(
      final XController x, final String id, final bool tobeRemove) async {
    bool check = checkArrayIndexExist(id);

    if (!check) {
      String arrayVal = arrayIndexSelected.value;
      List<String> split = arrayVal.split("#");
      final XController x = XController.to;

      if (x.carts.length == split.length) {
        checkUnCheckAll(x, true);
      } else {
        arrayIndexSelected.value = "$id#${arrayIndexSelected.value}";
        countSeletedItem(x);
      }
    } else {
      if (tobeRemove) {
        selectedAll.value = false;
        removeSelectedFromId(id);
        countSeletedItem(x);
      } else {
        String arrayVal = arrayIndexSelected.value;
        arrayIndexSelected.value = "";
        await Future.delayed(Duration(milliseconds: 300));
        arrayIndexSelected.value = arrayVal;
        countSeletedItem(x);
      }
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

  countSeletedItem(final XController x) {
    List<String> split = arrayIndexSelected.value.split("#");
    totalPayment.value = 0;
    split.forEach((String idp) {
      if (idp != '') {
        dynamic getProductId = x.getItemCartById(idp);
        Product product = Product.fromData(getProductId);
        totalPayment.value =
            totalPayment.value + (product.qty! * product.price!);
      }
    });
  }

  Widget createListCarts(final XController x, final List<dynamic> carts,
      final String arraySelected) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: carts.map((dynamic item) {
          Product product = Product.fromData(item);
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
                      print(val);
                      toggleCheckedItem(x, product.id!, true);
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
                    width: Get.width / 3.4,
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
                          style: TextStyle(color: Colors.grey, fontSize: 11),
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
                        Text(
                          "${product.selectedColor}, ${product.selectedSize}",
                          maxLines: 2,
                          style: Get.theme.textTheme.bodyText1!
                              .copyWith(color: grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  width: Get.width / 3.99,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: () async {
                          int qty = product.qty!;
                          if (qty > 1) {
                            qty--;
                            Product cartProduct = product;
                            cartProduct.qty = qty;
                            x.updateQtyProduct(cartProduct);

                            toggleCheckedItem(x, product.id!, false);
                          } else {
                            x.addRemoveItemCart(product.toJson(), true);

                            await Future.delayed((Duration(milliseconds: 600)));
                            removeSelectedFromId(product.id!);
                            countSeletedItem(x);
                            if (x.carts.length == 1 &&
                                checkArrayIndexExist(product.id!)) {
                              selectedAll.value = true;
                            } else {
                              selectedAll.value = false;
                            }
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 8),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: backgroundBox,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(" - "),
                        ),
                      ),
                      Text(
                        "${product.qty}",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      InkWell(
                        onTap: () {
                          int qty = product.qty!;

                          if (qty < 99) {
                            qty++;
                            Product cartProduct = product;
                            cartProduct.qty = qty;
                            x.updateQtyProduct(cartProduct);

                            toggleCheckedItem(x, product.id!, false);
                          }
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 8),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: backgroundBox,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            " + ",
                            style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
