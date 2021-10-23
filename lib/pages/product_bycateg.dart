import 'dart:convert';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/category_model.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/pages/product_detail.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/fade_up.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:kindashop/widgets/transparent_image.dart';

class ProductByCateg extends StatelessWidget {
  final Category? category;
  final bool? isBrand;

  ProductByCateg(this.category, this.isBrand) {
    if (this.category != null) {
      Future.delayed(Duration(milliseconds: 600), () async {
        getDataResponse(XController.to, false);
      });
    }
  }

  final paging = 0.obs;
  final itemProductCateg = ItemResponse().obs;
  final pagePerPaging = 10;
  final appStateLoading = false.obs;

  getDataResponse(final XController x, final bool isScroll) async {
    try {
      List<dynamic> results = [];
      if (isScroll) {
        results = itemProductCateg.value.datas!;
        appStateLoading.value = true;
      } else {
        itemProductCateg.update((val) {
          val!.appState = AppState.loading;
        });
      }
      String limit = "${paging.value},$pagePerPaging";
      //print(limit);

      var dataPush = jsonEncode({"ic": "${this.category!.id}"});
      if (this.isBrand != null && this.isBrand!) {
        dataPush = jsonEncode({"br": "${this.category!.id}"});
      }

      if (this.category!.typee == 2 && this.category!.desc != '') {
        dataPush = jsonEncode({"qy": "${this.category!.desc}"});
      }

      final response =
          await x.pushResponse("home/getproduct?lt=$limit", dataPush);
      //print(response.body);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.body);
        //print(_result);
        if (_result['code'] == '200') {
          results.addAll(_result['result']);
          itemProductCateg.update((val) {
            val!.result = _result;
            val.datas = results;
          });

          paging.value = paging.value + pagePerPaging;
        }
      }
    } catch (e) {
      print("error get home $e");
    }

    if (!isScroll) {
      itemProductCateg.update((val) {
        val!.appState = AppState.done;
      });
    } else {
      appStateLoading.value = false;
    }
  }

  final ScrollController _controller = ScrollController();
  final XController x = XController.to;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    Future.delayed(Duration(seconds: 2), () {
      _controller.addListener(_scrollListener);
    });

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
              child: RefreshIndicator(
                onRefresh: () async {
                  final XController x = XController.to;
                  x.getHome();
                  await Future.delayed(Duration(seconds: 1));
                  return Future.value(true);
                },
                child: SingleChildScrollView(
                  controller: _controller,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      spaceHeight5,
                      Obx(
                        () => itemProductCateg.value.appState == AppState.done
                            ? itemProductCateg.value.datas != null &&
                                    itemProductCateg.value.datas!.length > 0
                                ? staggeredContent(
                                    x, itemProductCateg.value.datas!)
                                : Container(
                                    height: Get.height / 1.5,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 40, vertical: 5),
                                    child: Center(
                                        child: Image.asset(
                                            "assets/coming_soon.jpeg")),
                                  )
                            : XController.loading(),
                      ),
                      Obx(
                        () => appStateLoading.value && paging.value > 0
                            ? Center(
                                child: SizedBox(
                                  width: 25,
                                  height: 25,
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : SizedBox.shrink(),
                      ),
                      spaceHeight50
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _scrollListener() {
    try {
      /*Future.delayed(Duration(milliseconds: 10), () async {
        x.setSearchTop(_controller.offset);
      });*/

      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange) {
        getDataResponse(x, true);

        //print("reach the bottom.... reach the bottom....");
      }
      if (_controller.offset <= _controller.position.minScrollExtent &&
          !_controller.position.outOfRange) {
        //message = "reach the top";

        //print("reach the top.... reach the top....");
      }
    } catch (e) {}
  }

  gotoProductDetail(final dynamic itemProduct) {
    Get.to(ProductDetail(Product.fromData(itemProduct)));
  }

  Widget staggeredContent(final XController x, final List<dynamic> products) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: StaggeredGridView.countBuilder(
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
            var item = products[index];
            return InkWell(
              onTap: () {
                gotoProductDetail(item);
              },
              child: FadeUp(
                0.6,
                Container(
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
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15)),
                                child: ExtendedImage.network(
                                  "${item['image1']}",
                                  fit: BoxFit.cover,
                                  cache: true,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: Text(
                                "${item['nm_product']}",
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
                              padding: EdgeInsets.only(
                                  left: 10, right: 10, bottom: 5, top: 1),
                              child: Text(
                                "${x.defCurrency.value}${double.parse(item['price'])}",
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
                        top: isEven ? 10 : 15,
                        right: 10,
                        child: Container(
                          width: 25,
                          height: 25,
                          padding: EdgeInsets.only(left: 3),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: LikeButton(
                            size: 12,
                            isLiked: x.isItemFavorite(Product.fromData(item)),
                            circleColor: CircleColor(
                                start: Color(0xff00ddff),
                                end: Color(0xff0099cc)),
                            bubblesColor: BubblesColor(
                              dotPrimaryColor: Color(0xff33b5e5),
                              dotSecondaryColor: Color(0xff0099cc),
                            ),
                            onTap: (bool isLiked) {
                              Product product = Product.fromData(item);
                              return ProductDetail.onLikeButtonTap(
                                  isLiked, product);
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.fit(1);
          }),
    );
  }

  Widget topButton() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            width: Get.width / 1.1,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Feather.chevron_left, size: 25, color: greyInput),
                  onPressed: () {
                    Get.back();
                  },
                ),
                Container(
                  color: Colors.transparent,
                  margin: EdgeInsets.only(right: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: category!.image == null
                        ? Container(
                            child: Image.asset(
                              "assets/ms_default_40.png",
                              width: 22,
                              height: 22,
                            ),
                          )
                        : FadeInImage.memoryNetwork(
                            placeholder: kTransparentImage,
                            image: category!.image.toString(),
                            width: 30,
                            height: 30,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                Container(
                  width: Get.width / 1.6,
                  child: Text(
                    "${this.category!.name}",
                    style: TextStyle(color: greyInput, fontSize: 19),
                  ),
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: backgroundBox,
            ),
            child: SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
