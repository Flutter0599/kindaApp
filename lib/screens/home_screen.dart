import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/model/brand_model.dart';
import 'package:kindashop/model/category_model.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/pages/product_bycateg.dart';
import 'package:kindashop/pages/product_detail.dart';
import 'package:kindashop/pages/search_page.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/fade_animation.dart';
import 'package:kindashop/widgets/fade_up.dart';
import 'package:kindashop/widgets/transparent_image.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomeScreen extends StatelessWidget {
  final XController x = XController.to;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: RefreshIndicator(
        onRefresh: () async {
          x.getHome();
          await Future.delayed(Duration(seconds: 1));
          return Future.value(true);
        },
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //top button
              topButton(),

              spaceHeight5,

              //slider
              Obx(
                () => x.itemHome.value.datas != null &&
                        x.itemHome.value.datas!.length > 0
                    ? createSliderAds(x.itemHome.value.datas![0]['sliders'])
                    : XController.loading(),
              ),
              spaceHeight5,

              //horizontal menu
              Obx(
                () => listMenu(x, x.menuCategoryIndex.value),
              ),

              ///home grid
              Obx(
                () => x.itemHome.value.datas != null &&
                        x.itemHome.value.datas!.length > 0
                    ? swicthIndexMenu(x, x.menuCategoryIndex.value)
                    : XController.loading(),
              ),
              spaceHeight50
            ],
          ),
        ),
      ),
    );
  }

  ///end of build///

  static gotoProductDetail(final dynamic itemProduct) {
    Get.to(ProductDetail(Product.fromData(itemProduct)));
  }

  Widget swicthIndexMenu(final XController x, final int index) {
    try {
      switch (index) {
        case 0:
          return staggeredContent(x, x.itemHome.value.datas![0]['products']);
        case 1:
          return listCategories(x, x.itemHome.value.datas![0]['categories']);
        case 2:
          return staggeredContent(
              x, x.itemHome.value.datas![0]['top_products']);
        case 3:

          /// recent section now empty ///
          return staggeredContent(x, []);
        default:
          return staggeredContent(x, x.itemHome.value.datas![0]['products']);
      }
    } catch (e) {}

    return Container();
  }

  Widget listCategories(final XController x, final List<dynamic>? temps) {
    List<Category> categories = [];
    try {
      if (temps != null && temps.length > 0) {
        temps.forEach((element) {
          Map<String, dynamic> categ = element;
          categories.add(Category.fromData(categ));
          print(x.itemHome.value.datas![0]['categories']);
        });
      }
    } catch (e) {}
///////////////////////////////////////////////////////////////////////////////
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 10),
      child: ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: categories.map((item) {
          //int index = categories.indexOf(item);
          return FadeAnimation(
            0.6,
            InkWell(
              onTap: () {
                Get.to(ProductByCateg(item, false));
              },
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 10, right: 10, top: 10, bottom: 10),
                    margin: EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: backgroundBox,
                    ),
                    child: Row(
                      children: [
                        Container(
                          color: Colors.transparent,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: FadeInImage.memoryNetwork(
                              placeholder: kTransparentImage,
                              image: item.image.toString(),
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Padding(
                            padding: EdgeInsets.only(left: 20, right: 5),
                            child: Text("${item.name}",
                                maxLines: 1,
                                style: Get.theme.textTheme.headline6!
                                    .copyWith(fontSize: 15)))
                      ],
                    ),
                  ),
                  Positioned(
                    right: 15,
                    bottom: 10,
                    top: 0,
                    child: InkWell(
                      child: Icon(Feather.chevron_right,
                          size: 18, color: mainColor),
                      onTap: () {},
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  final List<String> dataImages = [
    "assets/slide_01.jpg",
    "assets/slide_02.jpeg"
  ];

  Widget createSliderAds(final List<dynamic> sliders) {
    return Container(
      width: Get.width,
      height: Get.height / 5.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Swiper(
        autoplay: true,
        autoplayDelay: 1000 * 35,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            width: Get.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              //sliders[index]['image']
              child: ExtendedImage.network(
                "${sliders[index]['image']}",
                //width: Get.width,
                //height: getProportionateScreenHeight(Get.height / 2.1),
                fit: BoxFit.cover,
                cache: true,
              ),
            ),
          );
        },
        itemCount: sliders.length,
        pagination: new SwiperPagination(
          margin: new EdgeInsets.all(0.0),
          builder: new SwiperCustomPagination(
            builder: (BuildContext context, SwiperPluginConfig config) {
              return new ConstrainedBox(
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: backgroundBox,
                      ),
                      child: Text(
                        "${config.activeIndex + 1}/${config.itemCount}",
                        style: TextStyle(fontSize: 11.0),
                      ),
                    ),
                  ],
                ),
                constraints: new BoxConstraints.expand(height: 45.0),
              );
            },
          ),
        ),
        //control: new SwiperControl(),
      ),
    );
  }

  Widget staggeredBrand(final XController x, final List<dynamic>? temps) {
    List<Brand> brands = [];

    if (temps != null && temps.length > 0) {
      temps.forEach((element) {
        Map<String, dynamic> brand = element;
        brands.add(Brand.fromData(brand));
      });
    }

    return Container(
        margin: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
        child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: brands.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              crossAxisSpacing: 5,
              mainAxisSpacing: 5,
              childAspectRatio: 0.75,
            ),
            itemBuilder: (BuildContext context, int index) {
              Brand brand = brands[index];
              return FadeUp(
                0.6,
                InkWell(
                  onTap: () {
                    Get.to(ProductByCateg(
                        Category(
                            id: "${brand.code}",
                            name: "${brand.title}",
                            image: "${brand.logo}"),
                        true));
                  },
                  child: Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.all(
                        Radius.circular(55),
                      ),
                    ),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        Container(
                          width: Get.width / 4.1,
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                width: getProportionateScreenHeight(91),
                                height: getProportionateScreenHeight(91),
                                padding: EdgeInsets.all(5),
                                decoration: BoxDecoration(
                                  color: mainColor,
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(95),
                                  ),
                                ),
                                //margin: EdgeInsets.only(left: 5, right: 5),
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(95),
                                    ),
                                    image: DecorationImage(
                                      image: NetworkImage("${brand.logo!}"),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width / 1.45,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, top: 10),
                                child: Text(
                                  "${brand.title}",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style:
                                      Get.theme.textTheme.bodyText1!.copyWith(
                                    fontSize: 10,
                                    height: 1.1,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Container(
                                width: Get.width / 1.5,
                                padding: EdgeInsets.only(
                                    left: 10, right: 10, bottom: 5, top: 1),
                                child: Text(
                                  "${x.numberFormat(brand.totalProduct!)} items",
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  style: Get.theme.textTheme.bodyText1!
                                      .copyWith(
                                          color: mainColor,
                                          fontSize: 11,
                                          fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 24,
                          right: 15,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 5),
                            decoration: BoxDecoration(
                              color: backgroundBox,
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            child: Row(
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(right: 5),
                                  child: Icon(Icons.favorite,
                                      color: Colors.red, size: 15),
                                ),
                                Text("${brand.totalLike}",
                                    style: TextStyle(
                                        fontSize: 11, color: Colors.black87)),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));
  }

  /// grid item widget ///
  Widget staggeredContent(final XController x, final List<dynamic> products) {
    if (products.isEmpty) {
      return Center(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          height: 350,
          child: Text('Comming soon'),
        ),
      );
    }
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      child: StaggeredGridView.countBuilder(
          padding: EdgeInsets.only(bottom: getProportionateScreenHeight(120)),
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 0,
          itemCount: x.menuCategoryIndex.value == 0
              ? products.length + 1
              : products.length,
          itemBuilder: (context, index) {
            bool isEven = index % 2 == 0;
            double heightItem = isEven
                ? getProportionateScreenHeight(270)
                : getProportionateScreenHeight(285);
            var item =
                x.menuCategoryIndex.value == 0 && index == products.length
                    ? null
                    : products[index];
            return FadeUp(
              0.6,
              (x.menuCategoryIndex.value == 0 && index == products.length)
                  ? InkWell(
                      onTap: () {
                        Get.to(ProductByCateg(
                            Category(id: "", name: "All Categories"), false));
                      },
                      child: Container(
                        height: heightItem / 1.3,
                        decoration: BoxDecoration(
                          color: backgroundBox,
                          borderRadius: BorderRadius.all(
                            Radius.circular(15),
                          ),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                  left: 8, right: 5, top: 4, bottom: 4),
                              decoration: BoxDecoration(
                                color: mainColor,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "More",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Icon(Feather.chevron_right,
                                      color: Colors.white, size: 16),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : createOneItemProduct(x, item, heightItem, isEven),
            );
          },
          staggeredTileBuilder: (index) {
            return StaggeredTile.fit(1);
          }),
    );
  }

  /// product item widget///
  Widget createOneItemProduct(final XController x, final dynamic item,
      final double heightItem, final bool isEven) {
    return InkWell(
      onTap: () {
        gotoProductDetail(item);
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
                        "${item['image1']}",
                        fit: BoxFit.cover,
                        cache: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10, right: 10, top: 10),
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
                    padding:
                        EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 1),
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
                  isLiked: x.isItemFavorite(Product.fromData(item)),
                  circleColor: CircleColor(
                      start: Color(0xff00ddff), end: Color(0xff0099cc)),
                  bubblesColor: BubblesColor(
                    dotPrimaryColor: Color(0xff33b5e5),
                    dotSecondaryColor: Color(0xff0099cc),
                  ),
                  onTap: (bool isLiked) {
                    Product product = Product.fromData(item);
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

  final List<String> horizontalMenu = [
    "All",
    "Category",
    "Top",
    "Recent",
  ];

  final ScrollController _controller = new ScrollController();
  Widget listMenu(final XController x, final int indexMenu) {
    List<Category> categories = [];
    final List<dynamic>? temps = x.itemHome.value.datas![0]['categories'];
    try {
      if (temps != null && temps.length > 0) {
        temps.forEach((element) {
          Map<String, dynamic> categ = element;
          categories.add(Category.fromData(categ));
          // print(categories.map((e) => e.name));
        });
      }
    } catch (e) {}

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 20),
      height: 40,
      child: ListView(
        controller: _controller,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: categories.map((item) {
          int index = categories.indexOf(item);
          return InkWell(
            onTap: () {
              x.setMenuCategoryIndex(index);
              _controller.animateTo(
                (50.0 * index),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              margin: EdgeInsets.only(
                  left: index == 0 ? 25 : 0,
                  right: (index >= categories.length - 1) ? 15 : 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: indexMenu == index ? mainColor : backgroundBox,
              ),
              child: index < 10
                  ? Text(
                      item.name.toString(),
                      style: TextStyle(
                          fontSize: 15,
                          color: indexMenu == index
                              ? Colors.white
                              : Colors.black45),
                    )
                  : Text(
                      'See more',
                      style: TextStyle(
                          fontSize: 15,
                          color: indexMenu == index
                              ? Colors.white
                              : Colors.black45),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget topButton() {
    //final XController x = XController.to;
    return InkWell(
      onTap: () {
        Get.to(SearchPage());
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: Get.width / 1.39,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: backgroundBox,
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Feather.search, size: 20, color: greyInput),
                    onPressed: () {
                      Get.to(SearchPage());
                    },
                  ),
                  Text("Find your product", style: TextStyle(color: greyInput))
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: backgroundBox,
              ),
              child: IconButton(
                icon: Icon(Icons.notifications_outlined, color: greyInput),
                onPressed: () {
                  x.setMenuBottomIndex(0);
                  /*x.setDefaultTheme(x.defTheme.value == ItemTheme().themeLight
                    ? ItemTheme().themeDark
                    : ItemTheme().themeLight);*/
                },
              ),
            ),
          ],
        ),
      ),
    );
  } // Search widget
}
