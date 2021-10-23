import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:scan/scan.dart';

import 'barcode_reader_overlay_painter.dart';

class BarcodeReaderPage extends StatefulWidget {
  final showBorder;
  final borderFlashDuration;
  final viewfinderWidth;
  final viewfinderHeight;
  final borderRadius;
  final scrimColor;
  final borderColor;
  final borderStrokeWidth;
  final buttonColor;
  final cancelButtonText;
  final successBeep;

  BarcodeReaderPage({
    this.showBorder = true,
    this.borderFlashDuration = 500,
    this.viewfinderWidth = 240.0,
    this.viewfinderHeight = 240.0,
    this.borderRadius = 16.0,
    this.scrimColor = Colors.black54,
    this.borderColor = Colors.green,
    this.borderStrokeWidth = 4.0,
    this.buttonColor = Colors.white,
    this.cancelButtonText = "Cancel",
    this.successBeep = true,
  });

  @override
  _BarcodeReaderPageState createState() => _BarcodeReaderPageState();
}

class _BarcodeReaderPageState extends State<BarcodeReaderPage> {
  ScanController controller = ScanController();

  bool _hasTorch = false;
  bool _isTorchOn = false;
  bool _isBorderVisible = false;
  Timer? _borderFlashTimer;

  @override
  void initState() {
    super.initState();

    if (widget.showBorder) {
      setState(() {
        _isBorderVisible = true;
      });

      if (widget.borderFlashDuration > 0) {
        _borderFlashTimer = Timer.periodic(
            Duration(milliseconds: widget.borderFlashDuration), (timer) {
          setState(() {
            _isBorderVisible = !_isBorderVisible;
          });
        });
      }
    }
  }

  @override
  void dispose() {
    _borderFlashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.black.withOpacity(.3),
      child: Scaffold(
        body: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildCaptureView(),
            _buildViewfinder(context),
            _buildButtonBar(),
            _buildButtonBack(),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptureView() {
    return ScanView(
      controller: controller,
// custom scan area, if set to 1.0, will scan full area
      scanAreaScale: .7,
      scanLineColor: Colors.transparent,
      onCapture: (data) {
        // do something
        controller.pause();
        Navigator.of(context).pop(data);
      },
    );
  }

  Widget _buildViewfinder(BuildContext context) {
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: BarcodeReaderOverlayPainter(
        drawBorder: _isBorderVisible,
        viewfinderWidth: widget.viewfinderWidth,
        viewfinderHeight: widget.viewfinderHeight,
        borderRadius: widget.borderRadius,
        scrimColor: widget.scrimColor,
        borderColor: widget.borderColor,
        borderStrokeWidth: widget.borderStrokeWidth,
      ),
    );
  }

  Widget _buildButtonBack() {
    return Align(
      alignment: Alignment.topLeft,
      child: Container(
        margin: EdgeInsets.only(
            top: getProportionateScreenHeight(50),
            left: getProportionateScreenHeight(5)),
        color: Colors.black12,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: Colors.white12.withOpacity(.3),
                borderRadius: BorderRadius.circular(60),
              ),
              margin: EdgeInsets.only(left: 10),
              padding: EdgeInsets.all(10),
              child: InkWell(
                child: Icon(
                  FontAwesome.chevron_left,
                  size: 18,
                  color: Colors.black,
                ),
                onTap: () => {Get.back()},
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildButtonBar() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        color: Colors.black26,
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _buildTorchButton(),
            _buildCancelButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildTorchButton() {
    return (_hasTorch)
        ? IconButton(
            icon: Icon(
              (_isTorchOn) ? Icons.flash_on : Icons.flash_off,
              color: widget.buttonColor,
            ),
            onPressed: () {
              print("toggle.. ");
              controller.toggleTorchMode();
              setState(() {
                _isTorchOn = !_isTorchOn;
              });
            },
          )
        : Container(
            width: 10,
            height: 10,
          );
  }

  Widget _buildCancelButton() {
    return TextButton(
      style: TextButton.styleFrom(
        textStyle: TextStyle(color: widget.buttonColor),
        padding: EdgeInsets.only(right: 10, bottom: 10),
      ),
      onPressed: () {
        controller.pause();
        Navigator.of(context).pop();
      },
      child: Text(widget.cancelButtonText),
    );
  }
}
