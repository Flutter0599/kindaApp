import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/pages/checkout_page.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/default_button.dart';
import 'package:like_button/like_button.dart';
import 'package:kindashop/widgets/gallery_wrapper.dart';

class ProductDetail extends StatelessWidget {
  final Product product;
  ProductDetail(this.product);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    double borderRadius = 35;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: SizedBox(
          width: Get.width,
          height: Get.height,
          child: Stack(
            children: [
              SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      color: Colors.transparent,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            child: Stack(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: backgroundBox.withOpacity(.19),
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(borderRadius),
                                      bottomRight:
                                          Radius.circular(borderRadius),
                                    ),
                                  ),
                                  margin: EdgeInsets.all(0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(borderRadius),
                                      bottomRight:
                                          Radius.circular(borderRadius),
                                    ),
                                    child: createSliderImage(x),
                                  ),
                                ),
                                Positioned(
                                  top: Get.mediaQuery.padding.top + 10,
                                  left: 5,
                                  right: 0,
                                  child: Container(
                                    width: Get.width,
                                    padding: EdgeInsets.only(right: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      mainAxisSize: MainAxisSize.max,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(60),
                                          ),
                                          margin: EdgeInsets.only(left: 10),
                                          padding: EdgeInsets.all(10),
                                          child: InkWell(
                                            child: Icon(
                                              FontAwesome.chevron_left,
                                              size: 18,
                                              color: Colors.black38,
                                            ),
                                            onTap: () => {Get.back()},
                                          ),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          margin: EdgeInsets.only(right: 10),
                                          padding: EdgeInsets.only(
                                              left: 9,
                                              right: 8,
                                              top: 8,
                                              bottom: 8),
                                          child: LikeButton(
                                            size: 18,
                                            isLiked: x.isItemFavorite(product),
                                            onTap: (bool isLiked) {
                                              return onLikeButtonTap(
                                                  isLiked, product);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          generateContent(x),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: GetPlatform.isAndroid ? 0 : 15,
                left: 0,
                right: 0,
                child: Container(
                  height: getProportionateScreenHeight(80),
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: backgroundBox,
                          borderRadius: BorderRadius.circular(22),
                        ),
                        margin: EdgeInsets.only(left: 10, right: 15),
                        child: IconButton(
                          padding: EdgeInsets.all(18),
                          iconSize: 20,
                          icon: Icon(FontAwesome.shopping_cart),
                          color: Colors.red,
                          onPressed: () {
                            typeCart.value = 1;
                            formAddToCart();
                          },
                        ),
                      ),
                      Flexible(
                        child: Container(
                          width: Get.width / 1.2,
                          child: DefaultButton(
                            text: "Buy Now",
                            press: () {
                              typeCart.value = 2;
                              formAddToCart();
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
    );
  }

  // 1 == add to cart, 2 == buy now
  final typeCart = 1.obs;

  formAddToCart() {
    itemPrice.value = qtyCounter.value * product.price!;

    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.51,
      maxHeight: 0.80,
      context: Get.context!,
      builder: _buildBottomSheet,
      anchors: [0, 0.5, 1],
    );
  }

  final colorSelected = 0.obs;
  final sizeSelected = 0.obs;
  final qtyCounter = 1.obs;
  final itemPrice = 0.0.obs;

  Widget _buildBottomSheet(
    BuildContext context,
    ScrollController scrollController,
    double bottomSheetOffset,
  ) {
    List<String> colors = product.colors!.split('#');
    List<String> sizes = product.sizes!.split('#');

    final XController x = XController.to;

    return SafeArea(
      bottom: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          controller: scrollController,
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 20),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.transparent,
              ),
              width: 20,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: BorderRadius.circular(20),
                ),
                width: 40,
                height: 6,
              ),
            ),
            Text("Color:", style: TextStyle(fontSize: 16)),
            spaceHeight5,
            Wrap(
              children: colors.map((e) {
                int index = colors.indexOf(e);
                return Obx(
                  () => InkWell(
                    onTap: () {
                      colorSelected.value = index;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == colorSelected.value
                            ? mainColor
                            : backgroundBox,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 0, right: 10, bottom: 10),
                      child: Text("$e",
                          style: TextStyle(
                              color: index == colorSelected.value
                                  ? Colors.white
                                  : Colors.black54)),
                    ),
                  ),
                );
              }).toList(),
            ),
            spaceHeight5,
            Text("Size:", style: TextStyle(fontSize: 16)),
            spaceHeight5,
            Wrap(
              children: sizes.map((e) {
                int index = sizes.indexOf(e);
                return Obx(
                  () => InkWell(
                    onTap: () {
                      sizeSelected.value = index;
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: index == sizeSelected.value
                            ? mainColor
                            : backgroundBox,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.all(10),
                      margin: EdgeInsets.only(left: 0, right: 10, bottom: 10),
                      child: Text("$e",
                          style: TextStyle(
                              color: index == sizeSelected.value
                                  ? Colors.white
                                  : Colors.black54)),
                    ),
                  ),
                );
              }).toList(),
            ),
            Text("Qty:", style: TextStyle(fontSize: 16)),
            spaceHeight5,
            Row(
              children: [
                spaceWidth10,
                InkWell(
                  onTap: () {
                    int qty = qtyCounter.value;
                    qty--;

                    if (qty < 1) {
                      qty = 1;
                    }

                    qtyCounter.value = qty;
                    itemPrice.value = qtyCounter.value * product.price!;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundBox,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 0, right: 10, bottom: 10),
                    child: Text(
                      " - ",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ),
                Obx(
                  () => Container(
                    decoration: BoxDecoration(
                      color: mainColor,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 0, right: 0, bottom: 10),
                    child: Text(" ${qtyCounter.value} ",
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                  ),
                ),
                InkWell(
                  onTap: () {
                    int qty = qtyCounter.value;
                    qty++;

                    if (qty > 90) {
                      qty = 90;
                    }

                    qtyCounter.value = qty;
                    itemPrice.value = qtyCounter.value * product.price!;
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: backgroundBox,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    padding: EdgeInsets.all(10),
                    margin: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                    child: Text(
                      " + ",
                      style: TextStyle(color: Colors.black54, fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
            if (typeCart.value == 1)
              Container(
                alignment: Alignment.bottomRight,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      width: 90,
                      child: DefaultButton(
                        text: "+ Cart",
                        press: () {
                          EasyLoading.showToast("+ Item to cart success...");
                          Product cartProduct = product;
                          cartProduct.selectedColor =
                              '${colors[colorSelected.value]}';
                          cartProduct.selectedSize =
                              '${sizes[sizeSelected.value]}';

                          cartProduct.qty = qtyCounter.value;

                          dynamic jsonProduct = cartProduct.toJson();
                          x.addRemoveItemCart(jsonProduct, false);
                          Get.back();
                          Future.delayed(Duration(milliseconds: 1200), () {
                            Get.back();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            if (typeCart.value == 2)
              Obx(
                () => Container(
                  alignment: Alignment.bottomRight,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Container(
                        width: 160,
                        child: DefaultButton(
                          text:
                              "Pay ${x.defCurrency.value}${x.numberFormatDec(itemPrice.value, 2)}",
                          press: () {
                            Get.back();
                            if (x.member['id_member'] == null) {
                              EasyLoading.showToast("Login required...");
                              Get.back();
                              x.setMenuBottomIndex(3);
                              return;
                            }

                            final Map<String, dynamic> params = {
                              "total": itemPrice.value,
                              "details": [
                                {
                                  "ip": "${product.id}",
                                  "qty": "${qtyCounter.value}",
                                  "price": "${product.price}",
                                  "curr": "${product.currency}",
                                  "color": "${colors[colorSelected.value]}",
                                  "size": "${sizes[sizeSelected.value]}"
                                }
                              ]
                            };

                            Get.to(CheckoutPage(params));
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
          ],
        ),
      ),
    );
  }

  static Future<bool> onLikeButtonTap(bool isLiked, Product product) async {
    XController x = XController.to;
    x.toggleFavorites(product);

    return !isLiked;
  }

  Widget createSliderImage(final XController x) {
    List<String> images = [];
    if (product.image1 != null && product.image1 != '') {
      images.add(product.image1!);
    }
    if (product.image2 != null && product.image2 != '') {
      images.add(product.image2!);
    }
    if (product.image3 != null && product.image3 != '') {
      images.add(product.image3!);
    }
    return Container(
      width: Get.width,
      height: Get.height / 1.9,
      padding: EdgeInsets.symmetric(horizontal: 0),
      child: Swiper(
        autoplay: true,
        autoplayDelay: 1000 * 35,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              openGallery(images, index);
            },
            child: Container(
              child: ExtendedImage.network(
                "${images[index]}",
                width: Get.width,
                fit: BoxFit.fill,
                cache: true,
              ),
            ),
          );
        },
        itemCount: images.length,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.all(0.0),
          builder: new SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
              return new ConstrainedBox(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    config.itemCount,
                    (index) => DefaultButton.buildDot(config.activeIndex,
                        index: index),
                  ),
                ),
                constraints: new BoxConstraints.expand(height: 45.0),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget generateContent(final XController x) {
    return Padding(
      padding: EdgeInsets.only(left: 22, right: 20, top: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${product.name}",
            maxLines: 3,
            style: Get.theme.textTheme.headline6!.copyWith(
              fontSize: 17,
              height: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 3),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${x.getCategoryNameFromId(product.idcategory)}",
                style: TextStyle(color: grey),
              ),
              Text(
                "${x.defCurrency.value}${product.price}",
                style: Get.theme.textTheme.bodyText1!.copyWith(
                    color: mainColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Container(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                RatingBarIndicator(
                  rating: product.rating!,
                  itemCount: 5,
                  itemSize: 22.0,
                  unratedColor: Colors.amber.withAlpha(50),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 5),
                      child: Icon(Icons.favorite, color: Colors.red, size: 15),
                    ),
                    Text("${product.totalike}",
                        style: TextStyle(fontSize: 11, color: Colors.black87)),
                  ],
                )
              ],
            ),
          ),
          spaceHeight10,
          buildDescrption(),
        ],
      ),
    );
  }

  Widget buildDescrption() {
    return Container(
      //height: getProportionateScreenHeight(GetPlatform.isAndroid ? 180 : 200),
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Text("${product.desc} \n\n\n\n"),
        ],
      ),
    );
  }

  void openGallery(final List<String> galleryItems, final int index) {
    Navigator.push(
      Get.context!,
      MaterialPageRoute(
        builder: (context) => GalleryPhotoViewWrapper(
          galleryItems: galleryItems,
          backgroundDecoration: const BoxDecoration(
            color: Colors.black,
          ),
          initialIndex: index,
          scrollDirection: Axis.vertical,
        ),
      ),
    );
  }
}