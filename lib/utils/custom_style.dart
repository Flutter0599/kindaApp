import 'package:flutter/material.dart';
import 'package:kindashop/utils/dimension_color.dart';

class CustomStyle {
  static double defaultTextSize = 14.00;
  static double smallTextSize = 12.00;
  static double extraSmallTextSize = 10.00;
  static double largeTextSize = 16.00;
  static double extraLargeTextSize = 20.00;

  static var textStyle =
      TextStyle(color: greyButton, fontSize: defaultTextSize * 1.2);

  static var hintTextStyle =
      TextStyle(color: Colors.grey.withOpacity(0.5), fontSize: defaultTextSize);

  static var listStyle =
      TextStyle(color: Colors.white, fontSize: defaultTextSize);

  static var defaultStyle =
      TextStyle(color: Colors.black, fontSize: largeTextSize);

  static var focusBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 0.5),
  );

  static var focusErrorBorder = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(30.0)),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 0.5),
  );

  static var searchBox = OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(10.0)),
    borderSide: BorderSide(color: Colors.black.withOpacity(0.1), width: 0.5),
  );
}
