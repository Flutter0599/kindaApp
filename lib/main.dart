import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:kindashop/screens/splash_screen.dart';
import 'app/home_page.dart';
import 'core/xcontroller.dart';
import 'screens/intro_screen.dart';
import 'utils/dimension_color.dart';
import 'package:google_fonts/google_fonts.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();
  Get.lazyPut<XController>(() => XController());

  await SystemChrome.setPreferredOrientations(<DeviceOrientation>[
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]).then((_) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: softMainColor,
        statusBarColor: Colors.transparent,
        //for Android statusBarIconBrightness
        statusBarIconBrightness: Brightness.dark,
        // For iOS.
        // Use [dark] for white status bar and [light] for black status bar.
        statusBarBrightness: Brightness.light,
      ),
    );

    final XController x = XController.to;
    x.getHome();
    Timer.periodic(const Duration(minutes: 18), (_t) {
      x.getHome();
    });

    return runApp(MyApp());
  });
}

class MyApp extends StatelessWidget {
  static ThemeData thisTheme = ThemeData(
    primaryColor: mainColor,
    fontFamily: GoogleFonts.montserrat().fontFamily,
    backgroundColor: Colors.white,
    accentColor: softMainColor,
    textSelectionTheme: const TextSelectionThemeData(cursorColor: mainColor),
  );

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: XController.APP_NAME,
      theme: thisTheme,
      home: const SplashPage(),
      builder: (BuildContext? context, Widget? child) {
        /// make sure that loading can be displayed in front of all other widgets
        return FlutterEasyLoading(child: child);
      },
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final XController x = XController.to;
    return Obx(
      () => x.getIsFirst ? IntroScreen() : HomePage(),
    );
  }
}

class HexColor extends Color {
  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));

  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF' + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }
}
