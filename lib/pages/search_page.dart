import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/category_model.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/pages/product_bycateg.dart';
import 'package:kindashop/pages/product_detail.dart';
import 'package:kindashop/screens/home_screen.dart';
import 'package:kindashop/utils/custom_style.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/fade_up.dart';

class SearchPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    indexSuggestion.value = -1;

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SafeArea(
        top: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            topButton(),
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    listSuggestion(),
                    spaceHeight15,
                    Divider(),
                    spaceHeight15,
                    Obx(
                      () => x.itemHome.value.datas != null &&
                              x.itemHome.value.datas!.length > 0
                          ? createRecommended(x,
                              x.itemHome.value.datas![0]['recomend_products'])
                          : XController.loading(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget createRecommended(final XController x, final List<dynamic>? datas) {
    List<Product> products = [];
    try {
      if (datas != null && datas.length > 0) {
        datas.forEach((element) {
          Map<String, dynamic> product = element;
          products.add(Product.fromData(product));
        });
      }
    } catch (e) {}

    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              "Recommended",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
          spaceHeight15,
          staggeredProduct(x, products),
        ],
      ),
    );
  }

  final TextEditingController queryController = TextEditingController();
  Widget topButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Feather.chevron_left, size: 25, color: greyInput),
            onPressed: () {
              Get.back();
            },
          ),
          Container(
            width: Get.width / 1.30,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: backgroundBox,
            ),
            child: TextFormField(
              controller: queryController,
              onFieldSubmitted: (String? text) {
                searchQuery(text);
              },
              autofocus: true,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: "Dress, Shoes, Apparel, Bag",
                contentPadding: EdgeInsets.symmetric(
                  vertical: 10.0,
                  horizontal: 10.0,
                ),
                labelStyle: CustomStyle.textStyle,
                filled: true,
                fillColor: backgroundBox,
                hintStyle: CustomStyle.textStyle,
                focusedBorder: CustomStyle.focusBorder,
                enabledBorder: CustomStyle.focusErrorBorder,
                focusedErrorBorder: CustomStyle.focusErrorBorder,
                errorBorder: CustomStyle.focusErrorBorder,
              ),
            ),
          ),
          spaceWidth5,
        ],
      ),
    );
  }

  searchQuery(String? text) {
    String query = text!;
    if (query.isNotEmpty && query.length > 2) {
      Get.to(
        ProductByCateg(
          Category(id: "", name: "Search '$query'", typee: 2, desc: query),
          false,
        ),
      );
    }
  }

  final List<String> quickSearch = [
    "Dress",
    "Shoes",
    "Casual",
    "Men",
    "Women",
    "Kids",
    "Mostuire",
    "T-Shirt",
    "Mobile",
    "Gadget",
    "Bag"
  ];

  final indexSuggestion = 0.obs;
  Widget listSuggestion() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      child: Wrap(
        children: quickSearch.map((e) {
          int index = quickSearch.indexOf(e);
          return InkWell(
            onTap: () {
              indexSuggestion.value = index;
              String text = "$e";
              queryController.text = text;
              searchQuery(text);
            },
            child: Obx(
              () => Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                margin: EdgeInsets.only(right: 5, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: indexSuggestion.value == index
                      ? softMainColor
                      : backgroundBox,
                ),
                child: Text("$e",
                    style: TextStyle(
                        color: indexSuggestion.value == index
                            ? Colors.white
                            : Colors.black)),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  static Widget staggeredProduct(
      final XController x, final List<Product> products) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.only(bottom: getProportionateScreenHeight(120)),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 0,
          itemCount: products.length,
          itemBuilder: (context, index) {
            bool isEven = index % 2 == 0;
            double heightItem = isEven
                ? getProportionateScreenHeight(270)
                : getProportionateScreenHeight(285);
            Product item = products[index];
            return FadeUp(
              0.6,
              createOneProduct(x, item, heightItem, isEven),
            );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.fit(1);
          }),
    );
  }

  static Widget createOneProduct(final XController x, final Product product,
      final double heightItem, final bool isEven) {
    return InkWell(
      onTap: () {
        HomeScreen.gotoProductDetail(product.toJson());
      },
      child: Container(
        height: heightItem,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(
            Radius.circular(15),
          ),
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: Get.width / 2.1,
              height: heightItem,
              margin: EdgeInsets.only(top: isEven ? 0 : 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: Get.width / 2.1,
                    height: heightItem / 1.49,
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      child: ExtendedImage.network(
                        "${product.image1}",
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
                    child: Text(
                      "${product.name}",
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Get.theme.textTheme.bodyText1!.copyWith(
                        fontSize: 12,
                        height: 1.1,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 1),
                    child: Text(
                      "${x.defCurrency.value}${product.price}",
                      maxLines: 1,
                      style: Get.theme.textTheme.bodyText1!.copyWith(
                          color: mainColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: isEven ? 10 : 20,
              right: 10,
              child: Container(
                width: 30,
                height: 30,
                padding: EdgeInsets.only(left: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: LikeButton(
                  size: 15,
                  isLiked: x.isItemFavorite(product),
                  circleColor: CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  onTap: (bool isLiked) {
                    return ProductDetail.onLikeButtonTap(isLiked, product);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
