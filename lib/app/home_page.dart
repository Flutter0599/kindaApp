import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kindashop/core/scanqrlib/scan_qr.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/screens/cart_screen.dart';
import 'package:kindashop/screens/default_screen.dart';
import 'package:kindashop/screens/favorite_screen.dart';
import 'package:kindashop/screens/home_screen.dart';
import 'package:kindashop/screens/profile_screen.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:icon_badge/icon_badge.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> animation;
  late CurvedAnimation curve;

  final iconList = <IconData>[
    Icons.home,
    Icons.shopping_cart,
    Icons.favorite,
    Icons.person_rounded,
  ];

  @override
  void initState() {
    super.initState();
    setAnimationMenu();
  }

  setAnimationMenu() {
    Future.delayed(Duration(milliseconds: 1200), () {
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarColor: Colors.white,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.light,
        ),
      );
    });

    _animationController = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this,
    );
    curve = CurvedAnimation(
      parent: _animationController,
      curve: Interval(
        0.5,
        1.0,
        curve: Curves.fastOutSlowIn,
      ),
    );
    animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(curve);

    Future.delayed(
      Duration(seconds: 1),
      () => _animationController.forward(),
    );
  }

  final XController x = XController.to;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return WillPopScope(
      onWillPop: () => onBackPress(),
      child: Theme(
        data: x.defTheme.value,
        child: Container(
          width: Get.width,
          height: Get.height,
          color: Colors.white,
          child: SafeArea(
            top: true,
            bottom: false,
            child: Scaffold(
              extendBody: true,
              body: Obx(
                () => switchBodyScreen(x.menuBottomIndex.value),
              ),
              floatingActionButton: ScaleTransition(
                scale: animation,
                child: FloatingActionButton(
                  elevation: 8,
                  backgroundColor: mainColor,
                  child: Icon(
                    Icons.home,
                    color: Colors.white,
                  ),
                  // onPressed: () {

                  //   //EasyLoading.showToast("Coming soon..");
                  //   _animationController.reset();

                  //    scanQR();
                  //   _animationController.forward();
                  // },
                  onPressed: () => x.setMenuBottomIndex(0),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: Obx(
                () => AnimatedBottomNavigationBar.builder(
                  itemCount: iconList.length,
                  tabBuilder: (int index, bool isActive) {
                    final color = isActive ? mainColor : greyButton;
                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Obx(
                          () => createIconNavigation(
                            x,
                            index,
                            x.counterFavorite.value,
                            color,
                            x.counterCart.value,
                          ),
                        ),
                      ],
                    );
                  },
                  activeIndex: x.menuBottomIndex.value,
                  splashColor: backgroundBox,
                  notchAndCornersAnimation: animation,
                  splashSpeedInMilliseconds: 300,
                  notchSmoothness: NotchSmoothness.defaultEdge,
                  gapLocation: GapLocation.center,
                  leftCornerRadius: 32,
                  rightCornerRadius: 32,
                  onTap: (index) => x.setMenuBottomIndex(index),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //scan QR
  scanQR() async {
    final String? data = await ScanQR.scan(
      context,
      viewfinderHeight: Get.height / 3,
      viewfinderWidth: getProportionateScreenWidth(300),
      scrimColor: Color.fromRGBO(0, 0, 0, 0.5), //Color.fromRGBO(128, 0, 0, 0.5)
      borderColor: mainColor,
      borderRadius: 24,
      borderStrokeWidth: 2,
      buttonColor: Colors.white,
      borderFlashDuration: 250,
      cancelButtonText: "Cancel",
      successBeep: true,
    );

    String? _result = data ?? "";
    if (_result.length > 3) {
      int type = 0;
      if (_result.contains("http")) {
        type = 2;
      }
      if (XController.isValidEmail(_result)) {
        type = 4;
      }
      if (_result.substring(0, 1) == "+") {
        type = 3;
      }
      var dataItem = {
        "code": "$_result",
        "note": "-",
        "idx_type": type,
        "path": null,
        "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
      };
      print(dataItem);

      EasyLoading.showToast("Loading...");
      Future.delayed(Duration(milliseconds: 1200), () {
        showBottomResult(x, _result);
      });
    } else {
      EasyLoading.showToast("Nothing to Scan...");
    }
  }

  //scan QR
  static showBottomResult(final XController x, final dynamic result) {
    showCupertinoModalBottomSheet(
      expand: true,
      context: Get.context!,
      topRadius: Radius.circular(10),
      backgroundColor: Colors.transparent,
      barrierColor: Get.theme.primaryColor,
      builder: (context) => Material(
        child: Container(
          color: Colors.white,
          child: Stack(
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: 40,
                  left: 20,
                  right: 20,
                ),
                child: Container(
                  width: Get.width,
                  height: Get.height,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      SizedBox(height: 20),
                      Text(
                        "Scan Result",
                        style: Get.theme.textTheme.headline5!.copyWith(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(bottom: 22),
                        padding: EdgeInsets.only(
                            left: 16, right: 15, top: 12, bottom: 12),
                        child: Text("$result",
                            textAlign: TextAlign.center,
                            style: Get.theme.textTheme.headline6!
                                .copyWith(fontSize: 16)),
                      ),
                      spaceHeight20,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 15, right: 15, bottom: 10),
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                textStyle: TextStyle(color: Colors.white),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15, vertical: 10),
                                shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                              ),
                              onPressed: () {
                                Get.back();
                              },
                              child:
                                  Text("Close", style: TextStyle(fontSize: 18)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 250),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 5,
                top: 5,
                child: IconButton(
                  onPressed: () {
                    Get.back();
                  },
                  icon: Icon(
                    Feather.chevron_down,
                    size: 30,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget createIconNavigation(final XController x, final int index,
      final int totalFavs, final Color color, final int totalCarts) {
    return (totalFavs > 0 || totalCarts > 0) &&
            (index == 1 || index == 2) &&
            (x.menuBottomIndex.value != 2)
        ? iconBadges(index, color, index == 1 ? totalCarts : totalFavs,
            index == 1 ? Colors.purple : Colors.pink)
        : totalCarts > 0 && (index == 1) && (x.menuBottomIndex.value != 1)
            ? iconBadges(index, color, totalCarts, Colors.purple)
            : Icon(
                iconList[index],
                size: 24,
                color: color,
              );
  }

  Widget iconBadges(final int index, final Color color, final int total,
      final Color colorBadge) {
    return IconBadge(
      icon: Icon(
        iconList[index],
        size: 24,
        color: color,
      ),
      itemCount: total, //totalCarts,
      badgeColor: colorBadge, //Colors.purple,
      itemColor: Colors.white,
      maxCount: 99,
      hideZero: true,
      top: 0,
      right: 5,
      onTap: () {
        x.setMenuBottomIndex(index);
      },
    );
  }

  Widget switchBodyScreen(final int index) {
    switch (index) {
      case 0:
        return HomeScreen();
      case 1:
        return CartScreen();
      case 2:
        return FavoriteScreen();
      case 3:
        return ProfileScreen();
      default:
        return DefaultScreen();
    }
  }

  final _channel =
      const MethodChannel('com.erhacorpdotcom.mshopping/app_retain');
  Future<bool> onBackPress() {
    if (GetPlatform.isAndroid) {
      if (Navigator.of(Get.context!).canPop()) {
        return Future.value(true);
      } else {
        _channel.invokeMethod('sendToBackground');
        return Future.value(false);
      }
    } else {
      return Future.value(true);
    }
  }
}
