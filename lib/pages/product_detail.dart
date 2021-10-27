import 'package:bottom_sheet/bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:extended_image/extended_image.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/pages/add_address_page.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/default_button.dart';
import 'package:like_button/like_button.dart';
import 'package:kindashop/widgets/gallery_wrapper.dart';

class ProductDetail extends StatefulWidget {
  final Product product;

  ProductDetail(this.product);

  @override
  State<ProductDetail> createState() => _ProductDetailState();

  static Future<bool> onLikeButtonTap(bool isLiked, Product product) async {
    XController x = XController.to;
    x.toggleFavorites(product);

    return !isLiked;
  }
}

class _ProductDetailState extends State<ProductDetail> {
  var count = 1.obs;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    double borderRadius = 35;
    RxInt count = 1.obs;
    print(count);

    List<String> colors = widget.product.colors!.split('#');
    List<String> sizes = widget.product.sizes!.split('#');
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
                          Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: backgroundBox.withOpacity(.19),
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius),
                                  ),
                                ),
                                margin: EdgeInsets.all(0),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(borderRadius),
                                    bottomRight: Radius.circular(borderRadius),
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
                                      Row(
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
                                                FontAwesome.share_alt,
                                                size: 18,
                                                color: Colors.black38,
                                              ),
                                              onTap: () => {Get.back()},
                                            ),
                                          ),
                                          SizedBox(
                                            width: 20,
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
                                              isLiked: x.isItemFavorite(
                                                  widget.product),
                                              onTap: (bool isLiked) {
                                                return ProductDetail
                                                    .onLikeButtonTap(isLiked,
                                                        widget.product);
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
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
                            text: "Add to cart",
                            press: () {
                              // typeCart.value = 2;
                              // formAddToCart();
                              EasyLoading.showToast(
                                  "+ Item to cart success...");
                              Product cartProduct = widget.product;
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

  final typeCart = 1.obs;

  formAddToCart() {
    itemPrice.value = qtyCounter.value * widget.product.price!;

    showFlexibleBottomSheet<void>(
      minHeight: 0,
      initHeight: 0.51,
      maxHeight: 0.80,
      context: Get.context!,
      builder: _buildBottomSheet,
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
    List<String> colors = widget.product.colors!.split('#');
    List<String> sizes = widget.product.sizes!.split('#');

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
                      print(colorSelected.value);
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
                    itemPrice.value = qtyCounter.value * widget.product.price!;
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
                    itemPrice.value = qtyCounter.value * widget.product.price!;
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
                          Product cartProduct = widget.product;
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
                                  "ip": "${widget.product.id}",
                                  "qty": "${qtyCounter.value}",
                                  "price": "${widget.product.price}",
                                  "curr": "${widget.product.currency}",
                                  "color": "${colors[colorSelected.value]}",
                                  "size": "${sizes[sizeSelected.value]}"
                                }
                              ]
                            };

                            Get.to(AddAddressPage(params));
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

  Widget createSliderImage(final XController x) {
    List<String> images = [];
    if (widget.product.image1 != null && widget.product.image1 != '') {
      images.add(widget.product.image1!);
    }
    if (widget.product.image2 != null && widget.product.image2 != '') {
      images.add(widget.product.image2!);
    }
    if (widget.product.image3 != null && widget.product.image3 != '') {
      images.add(widget.product.image3!);
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
    List<String> sizes = widget.product.sizes!.split('#');
    List<int> colors = [0xfffff6e9, 0xff630b0b, 0xff38761d, 0xff0b5394];
    List<String> colorsx = widget.product.colors!.split('#');

    return Padding(
        padding: EdgeInsets.only(left: 22, right: 20, top: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${widget.product.name}",
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
                  "${x.getCategoryNameFromId(widget.product.idcategory)}",
                  style: TextStyle(color: grey),
                ),
                Text(
                  "${x.defCurrency.value}${widget.product.price}",
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
                    rating: widget.product.rating!,
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
                        child:
                            Icon(Icons.favorite, color: Colors.red, size: 15),
                      ),
                      Text("${widget.product.totalike}",
                          style:
                              TextStyle(fontSize: 11, color: Colors.black87)),
                    ],
                  )
                ],
              ),
            ),
            spaceHeight15,
            // colors
            Text("Colors:", style: TextStyle(fontSize: 16)),
            spaceHeight5,
            Container(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: colors.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsetsDirectional.only(end: 25),
                      child: Stack(
                        children: [
                          Container(
                            height: 90,
                            width: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: mainColor),
                              color: Color(colors[index]),
                            ),
                            // decoration: BoxDecoration(image:DecorationImage(image:AssetImage(pathImage),fit: BoxFit.fill )),
                          ),
                          Transform.translate(
                            offset: Offset(40, 15),
                            child: Container(
                              clipBehavior: Clip.antiAlias,
                              decoration: BoxDecoration(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                  border: Border.all(color: mainColor)),
                              height: 60,
                              child: Column(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      child: Container(
                                        width: 20,
                                        decoration: BoxDecoration(
                                          color: backgroundBox,
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                        ),
                                        child: Icon(
                                          Icons.add,
                                          size: 20,
                                          color: Colors.black,
                                        ),
                                      ),
                                      onTap: () {
                                        count.value++;
                                        print(count);
                                        print('qqqqqqqqq');
                                        print(count);
                                      },
                                    ),
                                    flex: 1,
                                  ),
                                  Obx(
                                    () => Expanded(
                                      child: Container(
                                        width: 20,
                                        decoration:
                                            BoxDecoration(color: mainColor),
                                        child: Center(
                                            child: Text(
                                          count.value.toString(),
                                          style: TextStyle(color: Colors.black),
                                        )),
                                      ),
                                      flex: 1,
                                    ),
                                  ),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () {
                                        count.value--;
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: backgroundBox,
                                          borderRadius: BorderRadius.only(
                                              bottomLeft: Radius.circular(5),
                                              bottomRight: Radius.circular(5)),
                                        ),
                                        width: 20,
                                        child: Icon(
                                          Icons.remove,
                                          size: 20,
                                        ),
                                      ),
                                    ),
                                    flex: 1,
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
            spaceHeight15,

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
            Text("Old color selection:", style: TextStyle(fontSize: 16)),
            spaceHeight5,
            Wrap(
              children: colorsx.map((e) {
                int index = colorsx.indexOf(e);
                return Obx(
                  () => InkWell(
                    onTap: () {
                      colorSelected.value = index;
                      print(colorSelected.value);
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
            spaceHeight15,
            buildDescrption(),
          ],
        ));
  }

  Widget buildDescrption() {
    return Container(
      //height: getProportionateScreenHeight(GetPlatform.isAndroid ? 180 : 200),
      padding: EdgeInsets.only(bottom: 10),
      child: Column(
        children: <Widget>[
          Text("${widget.product.desc} \n\n\n\n"),
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
