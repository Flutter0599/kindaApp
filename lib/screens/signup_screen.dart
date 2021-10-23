import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/utils/custom_style.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:kindashop/widgets/default_button.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;

    return Container(
      child: SafeArea(
        top: true,
        child: Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Colors.white,
            elevation: 0.25,
            title: Text(""),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceHeight20,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Sign Up ${XController.APP_NAME}",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                spaceHeight10,
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Strong password required\nMin.(6 alphanumeric)",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: greyInput),
                  ),
                ),
                spaceHeight10,
                Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: getProportionateScreenWidth(30)),
                  child: signUpForm(x),
                ),
                spaceHeight10,
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already had account?",
                          style: TextStyle(color: greyInput)),
                      spaceWidth5,
                      InkWell(
                        onTap: () {
                          Get.back();
                        },
                        child: Text(
                          "Sign In",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                spaceHeight50,
                SizedBox(height: 350),
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController repasswordController = TextEditingController();

  final showPassword = true.obs;
  final showRePassword = true.obs;

  Widget signUpForm(final XController x) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Name",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        spaceHeight15,
        TextFormField(
          controller: nameController,
          keyboardType: TextInputType.name,
          validator: (String? value) {
            if (value!.isEmpty) {
              return "Name invalid";
            } else {
              return null;
            }
          },
          cursorColor: mainColor,
          decoration: InputDecoration(
            hintText: "Your name",
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
        spaceHeight15,
        Text(
          "Email",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        spaceHeight15,
        TextFormField(
          controller: emailController,
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            if (value!.isEmpty) {
              return "Email invalid";
            } else {
              return null;
            }
          },
          cursorColor: mainColor,
          decoration: InputDecoration(
            hintText: "abc@gmail.com",
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
        spaceHeight15,
        Text(
          "Password",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        spaceHeight15,
        Obx(
          () => TextFormField(
            controller: passwordController,
            obscureText: showPassword.value,
            keyboardType: TextInputType.text,
            cursorColor: mainColor,
            validator: (String? value) {
              if (value!.isEmpty) {
                return "Password invalid";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                hintText: "******",
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
                suffixIcon: IconButton(
                  icon: showPassword.value
                      ? Icon(Feather.eye)
                      : Icon(Feather.eye_off),
                  onPressed: () {
                    showPassword.value = !showPassword.value;
                  },
                )),
          ),
        ),
        spaceHeight15,
        Text(
          "Re-Password",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        spaceHeight15,
        Obx(
          () => TextFormField(
            controller: repasswordController,
            obscureText: showRePassword.value,
            keyboardType: TextInputType.text,
            cursorColor: mainColor,
            validator: (String? value) {
              if (value!.isEmpty) {
                return "Re-Password invalid";
              } else {
                return null;
              }
            },
            decoration: InputDecoration(
                hintText: "******",
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
                suffixIcon: IconButton(
                  icon: showRePassword.value
                      ? Icon(Feather.eye)
                      : Icon(Feather.eye_off),
                  onPressed: () {
                    showRePassword.value = !showRePassword.value;
                  },
                )),
          ),
        ),
        spaceHeight20,
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          alignment: Alignment.center,
          child: DefaultButton(
            text: "Sign Up",
            press: () {
              String nm = nameController.text;
              String pwd = passwordController.text;
              String em = emailController.text;
              String repwd = repasswordController.text;

              if (nm.isEmpty) {
                EasyLoading.showToast("Name invalid...");
                return;
              }

              if (em.isEmpty || !XController.isValidEmail(em)) {
                EasyLoading.showToast("Email invalid...");
                return;
              }

              if (pwd.isEmpty) {
                EasyLoading.showToast("Password invalid...");
                return;
              }

              if (repwd.isEmpty) {
                EasyLoading.showToast("RePassword invalid...");
                return;
              }

              if (repwd != pwd) {
                EasyLoading.showToast("Password & RePassword invalid...");
                return;
              }

              Future.delayed(Duration(milliseconds: 300), () {
                var dataJson = {
                  "em": em,
                  "ps": pwd,
                  "uuid": x.defUuid.value,
                  "nm": nm
                };
                pushRegister(x, dataJson);
              });

              //Get.back();
            },
          ),
        ),
      ],
    );
  }

  //pushRegister
  pushRegister(final XController x, final dynamic dataJson) async {
    try {
      EasyLoading.show(status: "Loading...");
      await Future.delayed(Duration(milliseconds: 800));

      var dataPush = jsonEncode(dataJson);
      final response = await x.pushResponse("member/register", dataPush);
      //print(response.body);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.body);
        String message = "Error:\n${_result['message']}";
        if (_result['code'] == '200') {
          dynamic _res = _result['result'][0];
          //print(_res);

          x.saveMember(jsonEncode(_res));
          message = "Process register success..\nWelcome to ${_res['name']}";
        }

        Future.delayed(Duration(milliseconds: 1200), () {
          EasyLoading.showToast(message,
              duration: Duration(milliseconds: 2000));
          Get.back();
        });
      } else {
        Future.delayed(Duration(milliseconds: 1200), () {
          EasyLoading.showToast(
              "Failed, Network error, check your connectivity...");
        });
        Get.back();
      }

      EasyLoading.dismiss();
    } catch (e) {
      print("error get home $e");
    }
  }
}
