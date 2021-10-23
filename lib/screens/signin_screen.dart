import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/screens/signup_screen.dart';
import 'package:kindashop/utils/custom_style.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:get/get.dart';
import 'package:kindashop/widgets/default_button.dart';

class SignInScreen extends StatelessWidget {
  final XController x = XController.to;
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);

    return Container(
      child: SafeArea(
        top: true,
        child: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                spaceHeight20,
                Container(
                  alignment: Alignment.center,
                  child: Container(
                    width: 70,
                    height: 70,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: backgroundBox,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: Image.asset("assets/logo_1024.png",
                          width: 50, fit: BoxFit.cover),
                    ),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "v. ${XController.APP_VERSION}",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 10),
                  ),
                ),
                spaceHeight10,

                Container(
                  alignment: Alignment.center,
                  child: Text(
                    "Login in to ${XController.APP_NAME}",
                    textAlign: TextAlign.center,
                    style: Get.theme.textTheme.headline6!
                        .copyWith(fontWeight: FontWeight.bold),
                  ),
                ),
                spaceHeight5,
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Don't have any account?",
                          style: TextStyle(color: greyInput)),
                      spaceWidth5,
                      InkWell(
                        onTap: () {
                          Get.to(SignUpScreen());
                        },
                        child: Text(
                          "Sign Up",
                          style: TextStyle(color: Colors.red),
                        ),
                      )
                    ],
                  ),
                ),
                spaceHeight20,
                spaceHeight10,
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {
                          EasyLoading.showToast("Dummy action...");
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          margin: EdgeInsets.only(right: 20),
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                            color: Colors.blue[900],
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Icon(FontAwesome.facebook_f,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          EasyLoading.showToast("Dummy action...");
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Icon(FontAwesome.google_plus,
                                size: 15, color: Colors.white),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          EasyLoading.showToast("Dummy action...");
                        },
                        child: Container(
                          width: 40,
                          height: 40,
                          padding: EdgeInsets.all(5),
                          margin: EdgeInsets.only(right: 0),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(60),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(60),
                            child: Icon(FontAwesome.apple,
                                size: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // or
                spaceHeight10,
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(right: 10),
                        color: Colors.black38,
                        width: Get.width / 3.3,
                        height: 0.5,
                      ),
                      Text("Or", style: TextStyle(color: greyInput)),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        color: Colors.black38,
                        width: Get.width / 3.3,
                        height: 0.5,
                      ),
                    ],
                  ),
                ),

                // login email & password
                spaceHeight20,
                spaceHeight5,
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 30,
                  ),
                  child: loginForm(x),
                ),
                spaceHeight50,
                spaceHeight20,
              ],
            ),
          ),
        ),
      ),
    );
  }

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Widget loginForm(final XController x) {
    emailController.text = x.emailLogin.value;
    passwordController.text = x.passLogin.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Email",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        spaceHeight15,
        TextFormField(
          controller: emailController,
          onChanged: (String? text) {
            x.emailLogin.value = text!;
            //x.update();
            //print('onchange text');
          },
          keyboardType: TextInputType.emailAddress,
          validator: (String? value) {
            if (value!.isEmpty) {
              return "Email invalid";
            } else {
              return null;
            }
          },
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
            obscureText: x.showPasswordLogin.value,
            keyboardType: TextInputType.text,
            onChanged: (String? text) {
              x.passLogin.value = text!;
              //x.update();
            },
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
                  icon: x.showPasswordLogin.value
                      ? Icon(Feather.eye)
                      : Icon(Feather.eye_off),
                  onPressed: () {
                    x.showPasswordLogin.value = !x.showPasswordLogin.value;
                    x.update();
                  },
                )),
          ),
        ),
        spaceHeight20,
        Container(
          margin: EdgeInsets.symmetric(horizontal: 0),
          alignment: Alignment.center,
          child: DefaultButton(
            text: "Sign In",
            press: () async {
              String em = emailController.text;
              String pwd = passwordController.text;

              if (em.isEmpty) {
                EasyLoading.showToast("Email invalid...");
                return;
              }

              if (pwd.isEmpty) {
                EasyLoading.showToast("Password invalid...");
                return;
              }

              Future.delayed(Duration(milliseconds: 300), () {
                var dataJson = {"em": em, "ps": pwd};
                pushLogin(x, dataJson);
              });
            },
          ),
        ),
      ],
    );
  }

  //pushLogin
  pushLogin(final XController x, final dynamic dataJson) async {
    try {
      EasyLoading.show(status: "Loading...");
      await Future.delayed(Duration(milliseconds: 800));

      var dataPush = jsonEncode(dataJson);
      final response = await x.pushResponse("member/login", dataPush);
      //print(response.body);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.body);
        String message = "Error:\n${_result['message']}";
        if (_result['code'] == '200') {
          dynamic _res = _result['result'][0];
          //print(_res);

          x.saveMember(jsonEncode(_res));
          message = "Process login success..\nWelcome to ${_res['name']}";
        }

        Future.delayed(Duration(milliseconds: 1200), () {
          EasyLoading.showToast(message,
              duration: Duration(milliseconds: 2000));
        });
      } else {
        Future.delayed(Duration(milliseconds: 1200), () {
          EasyLoading.showToast(
              "Failed, Network error, check your connectivity...");
        });
      }

      EasyLoading.dismiss();
    } catch (e) {
      print("error get home $e");
    }
  }
}
