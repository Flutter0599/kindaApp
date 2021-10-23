import 'package:flutter/material.dart';

const Color mainColor = Color(0xffef7263);
const Color softMainColor = Color(0xffF2A900);
const Color backgroundBox = Color(0xfff7f8fb);
const Color softerMainColor = Color(0xfffef8f0);

const Color softGrey = Color(0xfff2e2e2);
const Color grey = Color(0xffc4c4c4);
const Color greyButton = Color(0xffd8d8d8);
const Color greyInput = Color(0xff8c8c8c);
const Color greyInputSoft = Color(0xffacacac);

const spaceHeight5 = SizedBox(height: 5);
const spaceHeight10 = SizedBox(height: 10);
const spaceHeight15 = SizedBox(height: 15);
const spaceHeight20 = SizedBox(height: 20);
const spaceHeight50 = SizedBox(height: 50);

const spaceWidth5 = SizedBox(width: 5);
const spaceWidth10 = SizedBox(width: 10);
const spaceWidth15 = SizedBox(width: 15);
const spaceWidth20 = SizedBox(width: 20);
const spaceWidth50 = SizedBox(width: 50);

const BoxDecoration boxDecoration = BoxDecoration(
  gradient: LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [
      Color(0xffEB4C00),
      softMainColor, //Color(0xffF2A900),
    ],
  ),
);
