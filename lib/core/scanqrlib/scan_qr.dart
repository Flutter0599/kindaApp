import 'package:flutter/material.dart';

import 'barcode_reader/barcode_reader_page.dart';

class ScanQR {
  /// Opens the barcode scanning page and return scanned data or null if the
  /// Cancel button is pressed or if user dismisses the page.
  static Future<String> scan(
    /// The build context.
    BuildContext context, {

    /// Show a border around the viewfinder cutout borders. If this parameter is
    /// false, all other border configuration parameters will have no effect.
    bool showBorder = true,

    /// The viewfinder border blinking speed, in milliseconds.
    /// Set to zero to disable the blinking effect.
    int borderFlashDuration = 500,

    /// The viewfinder cutout width.
    double viewfinderWidth = 240.0,

    /// The viewfinder cutout height.
    double viewfinderHeight = 240.0,

    /// The viewfinder cutout border radius.
    double borderRadius = 16.0,

    /// The viewfinder shade color.
    Color scrimColor = Colors.black54,

    /// The viewfinder border color.
    Color borderColor = Colors.green,

    /// The viewfinder border stroke width.
    double borderStrokeWidth = 4.0,

    /// The bottom bar buttons color.
    Color buttonColor = Colors.white,

    /// The cancel button text.
    String cancelButtonText = "Cancel",

    /// Emit a beep sound when a barcode is scanned.
    bool successBeep = true,
  }) async {
    final String data = await Navigator.of(context).push(
      MaterialPageRoute(
          builder: (context) => BarcodeReaderPage(
                showBorder: showBorder,
                borderFlashDuration: borderFlashDuration,
                viewfinderWidth: viewfinderWidth,
                viewfinderHeight: viewfinderHeight,
                borderRadius: borderRadius,
                scrimColor: scrimColor,
                borderColor: borderColor,
                borderStrokeWidth: borderStrokeWidth,
                buttonColor: buttonColor,
                cancelButtonText: cancelButtonText,
                successBeep: successBeep,
              )),
    );

    return data;
  }
}
