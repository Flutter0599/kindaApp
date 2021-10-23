import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:kindashop/main.dart';
import 'package:kindashop/model/product_model.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:intl/intl.dart';
import 'package:photo_view/photo_view.dart';
import 'package:share/share.dart';
import 'package:uuid/uuid.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as Geocoding;

enum AppState { loading, done, error }

class ItemResponse {
  ItemResponse();
  dynamic? result;
  String? title;
  List<dynamic>? datas;
  AppState appState = AppState.loading;
}

class ItemTheme {
  ItemTheme();
  ThemeData themeLight = MyApp.thisTheme;
  ThemeData themeDark = ThemeData.dark();
}

class XController extends GetxController {
  static XController get to => Get.find<XController>();

  static const APP_NAME = "MShopping";
  static const APP_VERSION = "0.9.1";

  static const KEY_HOME = "_keyhome";
  static const KEY_FIRST = "_keyfirst";
  static const KEY_CATEG_CHOSEN = "_keycategchosen";

  static const KEY_MEMBER = "_keymember";
  static const KEY_CART = "_keycart";
  static const KEY_FAVORITE = "_keyfavorite";

  static const KEY_UUID = "_keyuuid";
  static const KEY_LATITUDE = "_keylatitude";
  static const KEY_ADDRESS = "_keyaddress";
  static const KEY_DELIVERY = "_keydelivery";

  Set<Product> _favorites = Set();
  Set<dynamic> _carts = Set();

  final defLatitude = "".obs;

  final box = GetStorage();

  final defUuid = "".obs;
  final defCurrency = "\$".obs;
  final isFirst = true.obs;

  bool get getIsFirst => isFirst.value;
  setIsFirst(final bool? value) {
    if (value != null) {
      isFirst.value = value;
      update();

      box.write(KEY_FIRST, value);
    }
  }

  reloadIsFirst() {
    //check uuid / generate
    defUuid.value = box.read(KEY_UUID) ?? Uuid().v1();
    box.write(KEY_UUID, defUuid.value);
    print(defUuid.value);

    //get location
    defLatitude.value = box.read(KEY_LATITUDE) ?? "";
    box.write(KEY_LATITUDE, defLatitude.value);
    //print(defUuid.value);

    //check member
    getMemberFromStorage();

    var getDataFirst = box.read(KEY_FIRST) ?? "";
    if (getDataFirst != null && getDataFirst != '') {
      isFirst.value = getDataFirst;
      update();
    }

    //load data favorites & carts
    getAllDataSaved();
  }

  Location location = new Location();
  getLocation() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData _locationData = await location.getLocation();
    if (_locationData.latitude != null && _locationData.longitude != null) {
      String _lat = "${_locationData.latitude},${_locationData.longitude}";
      saveLatitude(_lat);
      getAddressFromGeo(_locationData.latitude!, _locationData.longitude!);
    }

    location.onLocationChanged.listen((LocationData currentLocation) {
      // Use current location
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        String _lat =
            "${currentLocation.latitude},${currentLocation.longitude}";
        saveLatitude(_lat);
        getAddressFromGeo(
            currentLocation.latitude!, currentLocation.longitude!);
      }
    });
  }

  final defDelivery = "".obs;
  saveDeliveryAddress(String address) {
    box.write(KEY_DELIVERY, address);
    defDelivery.value = address;
  }

  final defAddress = "".obs;
  getAddressFromGeo(double lat, double lon) async {
    List<Geocoding.Placemark> placemarks =
        await Geocoding.placemarkFromCoordinates(lat, lon);
    Geocoding.Placemark place = placemarks[0];
    String currentAddress =
        "${place.name}, ${place.subLocality}, ${place.locality}, ${place.administrativeArea}, ${place.country}, ${place.postalCode}";
    //print(currentAddress);

    box.write(KEY_ADDRESS, currentAddress);
    defAddress.value = currentAddress;
  }

  saveLatitude(String geolat) {
    box.write(KEY_LATITUDE, geolat);
    defLatitude.value = geolat;
  }

  logout() {
    saveMember(null);
    update();

    EasyLoading.showToast("Logout success...");
  }

  getMemberFromStorage() {
    String getMember = box.read(KEY_MEMBER) ?? "";
    if (getMember != '') {
      member.value = jsonDecode(getMember);
    }

    try {
      if (member['id_member'] == null && isLoggedIn.value) {
        logout();
      }
    } catch (e) {}
  }

  saveMember(String? value) {
    box.write(KEY_MEMBER, value);
  }

  //categories chosen
  final chosenCateg = "".obs;
  setCategChosen(String chosen) {
    box.write(KEY_CATEG_CHOSEN, chosen);
    chosenCateg.value = chosen;
    update();
  }

  final showPasswordLogin = true.obs;
  final emailLogin = "".obs;
  final passLogin = "".obs;

  clearInputLogin() {
    emailLogin.value = "";
    passLogin.value = "";
    update();
  }

  @override
  void onInit() {
    //check isFirst:
    reloadIsFirst();
    super.onInit();

    //check loggin
    checkIsLoggedIn();

    getLocation();

    //get delivery address
    defDelivery.value = box.read(KEY_DELIVERY) ?? "";
    box.write(KEY_DELIVERY, defDelivery.value);

    //get address
    defAddress.value = box.read(KEY_ADDRESS) ?? "";
    box.write(KEY_ADDRESS, defAddress.value);

    //reload categ chosen
    var getChosenCateg = box.read(KEY_CATEG_CHOSEN) ?? "";
    if (getChosenCateg != null && getChosenCateg != '') {
      chosenCateg.value = getChosenCateg;
      update();
    }

    var getDataHome = box.read(KEY_HOME) ?? "";
    if (getDataHome != null && getDataHome != '') {
      dynamic _result = jsonDecode(getDataHome);

      if (_result != null && _result['result'] != null) {
        itemHome.update((val) {
          val!.result = _result;
          val.datas = _result['result'];
        });
      }
    }

    //listen box key storage
    box.listenKey(KEY_FAVORITE, (val) {
      counterFavorite.value = favorites.length;
    });

    box.listenKey(KEY_CART, (val) {
      counterCart.value = carts.length;
    });

    box.listenKey(KEY_MEMBER, (val) {
      if (val != null) {
        member.value = jsonDecode(val);
      } else {
        member.value = {};
      }

      checkIsLoggedIn();
    });

    autoInstall();
  }

  checkIsLoggedIn() {
    isLoggedIn.value = member['id_member'] != null;
    update();

    print("isLoggedIn : ${isLoggedIn.value}");
  }

  autoInstall() async {
    try {
      var dataPush = jsonEncode({
        "uuid": "${defUuid.value}",
        "fid": "", //firebase uid
        "fbt": "", //firebase token
        "lat": "${defLatitude.value}",
        "is_from": GetPlatform.isAndroid ? "Android" : "iOS",
        "em": member['id_member'] != null ? "${member['email']}" : "",
      });

      //print(dataPush);

      final response = await pushResponse("member/install", dataPush);
      //print(response.body);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.body);
        //print(_result);
        if (_result['code'] == '200') {}
      }
    } catch (e) {}
  }

  final member = {}.obs;
  final isLoggedIn = false.obs;

  final counterFavorite = 0.obs;
  final counterCart = 0.obs;

  //utility of favorite & carts
  List<Product> get favorites => _favorites.toList();
  List<dynamic> get carts => _carts.toList();

  bool isItemFavorite(Product item) =>
      _favorites.where((Product product) => product.id == item.id).length == 1;

  bool isItemCart(dynamic item) =>
      _carts
          .where((dynamic cart) => cart['id_product'] == item['id_product'])
          .length ==
      1;

  getAllDataSaved() {
    //favorites
    List<dynamic> itemFavs = box.read(KEY_FAVORITE) ?? [];
    _favorites = Set();
    _favorites.addAll(
        itemFavs.map((element) => Product.fromData(jsonDecode(element))));

    counterFavorite.value = favorites.length;

    _carts = Set();
    _carts
        .addAll(box.read(KEY_CART)?.map((value) => jsonDecode(value)) ?? Set());

    counterCart.value = carts.length;
  }

  Product? getItemFavoriteById(String id) {
    try {
      return _favorites.firstWhere((Product product) => product.id == id);
    } catch (e) {}

    return null;
  }

  toggleFavorites(Product favoriteItem) {
    //print("toggleFavorites ${favoriteItem.toJson()}");

    !isItemFavorite(favoriteItem)
        ? _favorites.add(favoriteItem)
        : _favorites.removeWhere((Product item) => item.id == favoriteItem.id);

    box.write(
        KEY_FAVORITE,
        favorites
            .map((Product itemProduct) => jsonEncode(itemProduct.toJson()))
            .toList());
  }

  clearFavorite() {
    _favorites = Set();
    box.write(
        KEY_FAVORITE,
        favorites
            .map((Product itemProduct) => jsonEncode(itemProduct.toJson()))
            .toList());
  }

  // item cart utility
  addRemoveItemCart(dynamic productItem, bool isRemove) async {
    if (isRemove) {
      _carts.removeWhere(
          (dynamic item) => item['id_product'] == productItem['id_product']);
    } else {
      if (!isItemCart(productItem)) {
        _carts.add(productItem);
      } else {
        dynamic getProduct = getItemCartById(productItem['id_product']);
        Product productExist = Product.fromData(getProduct);

        Product productNew = Product.fromData(productItem);
        productNew.qty = productNew.qty! + productExist.qty!;

        _carts.removeWhere(
            (dynamic item) => item['id_product'] == productItem['id_product']);

        await Future.delayed(Duration(milliseconds: 600));

        _carts.add(productNew.toJson());
      }
    }

    box.write(KEY_CART,
        carts.map((dynamic itemProduct) => jsonEncode(itemProduct)).toList());
  }

  clearCarts() {
    _carts = Set();
    box.write(KEY_CART,
        carts.map((dynamic itemProduct) => jsonEncode(itemProduct)).toList());
  }

  updateQtyProduct(final Product product) {
    Set<dynamic> _tempCarts = Set();
    List<dynamic> itemCarts = [];

    _carts.forEach((item) {
      Product thisProduct = Product.fromData(item);
      if (thisProduct.id == product.id) {
        thisProduct = product;
      }
      itemCarts.add(thisProduct.toJson());
    });

    _tempCarts.addAll(itemCarts.map((element) => element));

    _carts = _tempCarts;
    box.write(KEY_CART,
        carts.map((dynamic itemProduct) => jsonEncode(itemProduct)).toList());
  }

  dynamic? getItemCartById(String id) {
    try {
      return _carts
          .firstWhere((dynamic product) => product['id_product'] == id);
    } catch (e) {}

    return null;
  }

  final menuBottomIndex = 0.obs;
  setMenuBottomIndex(final int index) {
    menuBottomIndex.value = index;
    update();

    if (index == 3) {
      clearInputLogin();
    }
  }

  final menuCategoryIndex = 0.obs;
  setMenuCategoryIndex(final int index) {
    menuCategoryIndex.value = index;
    update();
  }

  final defTheme = ItemTheme().themeLight.obs;
  setDefaultTheme(ThemeData theme) {
    defTheme.value = theme;
    update();
  }

  final itemHome = ItemResponse().obs;
  getHome() async {
    try {
      reloadIsFirst();

      autoInstall();
      String im = member['id_member'] ?? "";

      var dataPush = jsonEncode({"im": "$im"});
      final response = await pushResponse('home/getall?lt=0,100', dataPush);

      //print(response.body);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.body);
        print('&&&&&&&& RESULT &&&&&&');
        print(_result['categories']);
        if (_result['code'] == '200') {
          box.write(KEY_HOME, jsonEncode(_result));

          itemHome.update((val) {
            val!.result = _result;
            val.datas = _result['result'];
          });
        }
      }
    } catch (e) {
      print("error get home $e");
    }
  }

  pushUpdateName(String name) {}

  pushUpdatePassword(String password) {}

  static shareContent(String? path, String addOn) {
    String text = "Download $APP_NAME\n$addOn";

    if (path == null) {
      Share.share(text, subject: 'Share $APP_NAME');
    } else {
      Share.shareFiles([path], subject: "Image Share $APP_NAME", text: text);
    }
  }

  static bool isValidEmail(String email) => RegExp(
          r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
      .hasMatch(email);

  static DateTime? getDatetime(final String? fulldate) {
    if (fulldate != null)
      return DateFormat('yyyy-MM-dd HH:mm:ss').parse(fulldate).toLocal();
    else
      return null;
  }

  static int? getTimestampFromDate(final String? fulldate) {
    if (fulldate != null)
      return getDatetime(fulldate)!.millisecondsSinceEpoch;
    else
      return null;
  }

  static DateTime? convertDateFromTimestamp(final int? timestamp) {
    if (timestamp != null)
      return DateTime.fromMillisecondsSinceEpoch(
        timestamp,
      ).toLocal();
    else
      return null;
  }

  static String? convertStringDateFromTimestamp(final int? timestamp) {
    if (timestamp != null) {
      DateTime datetimeFromTimestamp = DateTime.fromMillisecondsSinceEpoch(
        timestamp,
      ).toLocal();
      return convertStringFromDatetime(datetimeFromTimestamp);
    } else
      return null;
  }

  static String? convertStringFromDatetime(DateTime datetime) {
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(datetime);
  }

  numberFormat(int number) {
    final NumberFormat numberFormat =
        NumberFormat.currency(symbol: "", decimalDigits: 0);

    return numberFormat.format(number);
  }

  numberFormatDec(double number, int digit) {
    final NumberFormat numberFormat =
        NumberFormat.currency(symbol: "", decimalDigits: digit);

    return numberFormat.format(number);
  }

  getCategoryNameFromId(String? idCategory) {
    try {
      if (itemHome.value.datas != null) {
        List<dynamic> categories = itemHome.value.datas![0]['categories'];
        var categ = categories
            .firstWhere((element) => element['id_category'] == idCategory);
        return categ['nm_category'];
      }
    } catch (e) {}

    return "$idCategory";
  }

  static Widget photoView(photoUrl) {
    return Scaffold(
      appBar: AppBar(
        brightness: Get.theme.brightness,
        leading: BackButton(
          color: Colors.white,
          onPressed: () {
            Get.back();
          },
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        color: Get.theme.backgroundColor,
        padding: const EdgeInsets.all(0.0),
        alignment: Alignment.topLeft,
        child: PhotoView(
          loadingBuilder: (context, event) => Center(
            child: Container(
                child: SizedBox(
                    width: 30,
                    height: 30,
                    child: Center(child: CircularProgressIndicator()))),
          ),
          imageProvider: NetworkImage(
            '$photoUrl',
          ),
        ),
      ),
    );
  }

  distanceFormat(double meters) {
    double km = meters;
    if (meters > 0.0) {
      km = meters / 1000;
      return numberFormatDec(km, 2);
    } else {
      return numberFormatDec(km, 0);
    }
  }

  static Widget loading() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(mainColor),
        ),
      ),
    );
  }

  final http.Client _client = http.Client();
  static const String BASE_URL = 'https://api.muslims.id/';
  static const String BASE_URL_API = 'https://api.muslims.id/v1/';
  static const String BASE_URL_TOKEN = 'bXNob3BwaW5nOjIzQXByaWwyMDIx';

  //'https://api.muslims.id/v1/home'
  pushResponse(String path, dynamic body) async {
    try {
      var urlPush = BASE_URL_API + path;
      //print(urlPush);

      final response = await _client.post(
        Uri.parse(urlPush),
        body: body,
        headers: {
          "X-Auth-Token": "$BASE_URL_TOKEN",
          "Content-type": "application/json"
        },
      ).timeout(
        Duration(seconds: 180),
      );
      return response;
    } catch (e) {}

    return null;
  }

  @override
  void onClose() {
    super.onClose();
  }
}
