import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:kindashop/core/xcontroller.dart';
import 'package:kindashop/pages/feedback_page.dart';
import 'package:kindashop/pages/history_page.dart';
import 'package:kindashop/pages/share_page.dart';
import 'package:kindashop/screens/signin_screen.dart';
import 'package:kindashop/utils/dimension_color.dart';
import 'package:kindashop/utils/size_config.dart';
import 'package:kindashop/widgets/update_image.dart';

class ProfileScreen extends StatelessWidget {
  final itemCarts = [].obs;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final XController x = XController.to;
    

    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: EdgeInsets.only(left: 15),
            child: IconButton(
              icon: Icon(Feather.chevron_left, color: Colors.black54),
              onPressed: () {
                x.setMenuBottomIndex(0);
              },
            ),
          ),
          backgroundColor: Colors.white,
          title: Text("Profile", style: TextStyle(color: Colors.black54)),
          elevation: 0.25,
          centerTitle: true,
        ),
        body: Obx(
          () => Container(
            child: !x.isLoggedIn.value
                ? notLoginYet(x)
                : alreadyLogin(x, x.member),
          ),
        ),
      ),
    );
  }

  Widget notLoginYet(final XController x) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SignInScreen(),
    );
  }

  Widget alreadyLogin(final XController x, final dynamic member) {
    return Container(
      width: Get.width,
      height: Get.height,
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            spaceHeight20,
            Container(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    padding: EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: backgroundBox,
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(30),
                      child: member['image'] == null || member['image'] == ''
                          ? Image.asset(
                              "assets/def_profile.png",
                              width: 50,
                              fit: BoxFit.cover,
                            )
                          : InkWell(
                              onTap: () {
                                print("clicked image...");
                                Get.dialog(
                                    XController.photoView(member['image']));
                              },
                              child: Image.network(
                                member['image'],
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                  Positioned(
                      bottom: 0,
                      right: 3,
                      child: UpdateImage(
                        callback: () {},
                      ))
                ],
              ),
            ),
            spaceHeight20,
            Container(
              alignment: Alignment.center,
              child: Text(
                "${member['name']}",
                textAlign: TextAlign.center,
                style: Get.theme.textTheme.headline6!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
            ),
            spaceHeight5,
            Container(
              alignment: Alignment.center,
              child: Text(
                "${member['email']}",
                style: TextStyle(color: greyInput),
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text(
                "Since: ${member['date_created']}",
                style: TextStyle(color: softMainColor, fontSize: 11),
              ),
            ),
            spaceHeight20,
            Container(
                margin: EdgeInsets.symmetric(vertical: 20),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: createListProfile(x)),
            spaceHeight50,
          ],
        ),
      ),
    );
  }

  Widget createListProfile(final XController x) {
    List<dynamic> menus = [
      {"title": "Update Fullname", "icon": Icon(Feather.user)},
      {"title": "Change Password", "icon": Icon(Feather.lock)},
      {"title": "History", "icon": Icon(Feather.activity)},
      {"title": "Feedback", "icon": Icon(Feather.message_square)},
      {"title": "Share", "icon": Icon(Feather.share_2)},
      {"title": "Logout", "icon": Icon(Feather.log_out)},
      {"title": "v. ${XController.APP_VERSION}", "icon": Icon(Feather.grid)},
    ];
    return ListView.separated(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        var menu = menus[index];
        return InkWell(
          onTap: () {
            clickMenuIndex(x, index);
          },
          child: Container(
            child: ListTile(
              title: Text(
                "${menu['title']}",
              ),
              leading: menu['icon'],
              trailing: Icon(Feather.chevron_right),
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => Divider(),
      itemCount: menus.length,
    );
  }

  clickMenuIndex(final XController x, final int index) {
    switch (index) {
      case 0:
        changeName(x, x.member['name']);
        break;
      case 1:
        changePassword(x);
        break;
      case 2:
        Get.to(HistoryPage());
        break;
      case 3:
        Get.to(FeedbackPage());
        break;
      case 4:
        Get.to(SharePage());
        break;
      case 5:
        showLogout(x);
        break;
      default:
    }
  }

  static showLogout(final XController x) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Dialog(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: backgroundBox,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 160.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Are you sure to Logout?\n",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  height: 8.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[400],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        Get.back();
                        EasyLoading.show(status: 'Loading...');
                        await Future.delayed(Duration(milliseconds: 800),
                            () async {
                          var dataPush =
                              jsonEncode({"id": x.member['id_member']});
                          await x.pushResponse("member/logout", dataPush);
                        });

                        await Future.delayed(Duration(milliseconds: 1000),
                            () async {
                          x.logout();
                          EasyLoading.dismiss();
                          EasyLoading.showSuccess('Logout success...');
                        });
                      },
                      child: Container(
                        width: (Get.width / 3.5),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static showModalSignUpScreen(final XController x, final Widget screen) {
    showCupertinoModalBottomSheet(
      expand: true,
      context: Get.context!,
      backgroundColor: Colors.transparent,
      barrierColor: backgroundBox.withOpacity(.6),
      builder: (context) => Container(
        color: Colors.white,
        child: Stack(
          fit: StackFit.expand,
          children: [
            Padding(
              padding: EdgeInsets.only(
                top: Get.mediaQuery.padding.top,
              ),
              child: Container(child: screen),
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
                  size: 28,
                  color: Colors.black54,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  final TextEditingController nameController = TextEditingController();
  changeName(final XController x, final String nm) {
    nameController.text = nm;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: 200.0,
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Update Fullname",
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Input Fullname',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: Get.width / 3.5,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        String name = nameController.text.trim();
                        print(name);
                        if (name == '' || name.length < 3) {
                          EasyLoading.showError("Fullname invalid...");
                          return;
                        }

                        Get.back();
                        EasyLoading.showToast("Loading...");
                        await Future.delayed(Duration(milliseconds: 1200),
                            () async {
                          var dataPush = jsonEncode({
                            "action": "update_name",
                            "id": "${x.member['id_member']}",
                            "nm": name
                          });

                          //print(dataPush);

                          final response =
                              await x.pushResponse('member/update', dataPush);
                          //print(response.body);

                          if (response != null && response.statusCode == 200) {
                            dynamic _result = jsonDecode(response.body);
                            //print(_result);
                            if (_result['code'] == '200') {
                              dynamic _res = _result['result'][0];
                              x.saveMember(jsonEncode(_res));
                            }
                          }

                          EasyLoading.dismiss();

                          Future.delayed(Duration(milliseconds: 1200), () {
                            EasyLoading.showToast("Process success...");
                            //Get.back();
                          });
                        });
                      },
                      child: Container(
                        width: Get.width / 3.5,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Process',
                          style: TextStyle(
                            //fontFamily: 'Mukta',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  final TextEditingController passController = TextEditingController();
  final TextEditingController newpassController = TextEditingController();
  final TextEditingController renewpassController = TextEditingController();
  changePassword(final XController x) {
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (BuildContext context) {
        // return object of type Dialog
        return Dialog(
          elevation: 0.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10.0),
            ),
            height: Get.height / 2.2,
            padding: EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Change Password",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 21.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  "* strong password required",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12.0, color: Colors.grey[600]),
                ),
                spaceHeight10,
                TextField(
                  controller: passController,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Old Password',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                spaceHeight10,
                TextField(
                  controller: newpassController,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'New Password',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                spaceHeight10,
                TextField(
                  controller: renewpassController,
                  obscureText: true,
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Retype New Password',
                    hintStyle: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Get.back();
                      },
                      child: Container(
                        width: Get.width / 3.5,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {
                        String oldpass = passController.text.trim();
                        String newpass = newpassController.text.trim();
                        String renewpass = renewpassController.text.trim();

                        if (oldpass == '' || oldpass.length < 6) {
                          EasyLoading.showError(
                              "Old Password invalid... min 6 alphanumeric.");
                          return;
                        }

                        if (newpass == '' || newpass.length < 6) {
                          EasyLoading.showError(
                              "New Password invalid... min 6 alphanumeric.");
                          return;
                        }

                        if (renewpass == '' || renewpass.length < 6) {
                          EasyLoading.showError(
                              "Re-New Password invalid... min 6 alphanumeric.");
                          return;
                        }

                        if (renewpass != newpass) {
                          EasyLoading.showError(
                              "New & Re-New Password invalid... not equal.");
                          return;
                        }

                        Get.back();
                        EasyLoading.showToast("Loading...");
                        await Future.delayed(Duration(milliseconds: 1200),
                            () async {
                          var dataPush = jsonEncode({
                            "action": "change_password",
                            "is": "${x.member['id_install']}",
                            "id": "${x.member['id_member']}",
                            "em": "${x.member['email']}",
                            "op": oldpass,
                            "np": newpass
                          });

                          //print(dataPush);

                          final response =
                              await x.pushResponse('member/update', dataPush);
                          //print(response.body);

                          EasyLoading.dismiss();

                          if (response != null && response.statusCode == 200) {
                            dynamic _result = jsonDecode(response.body);
                            //print(_result);
                            if (_result['code'] == '200') {
                              dynamic _res = _result['result'][0];
                              x.saveMember(jsonEncode(_res));
                              EasyLoading.showToast("Process success...");
                            } else {
                              EasyLoading.showToast(
                                  "Process failed...\n${_result['message']}");
                            }
                          }
                        });
                      },
                      child: Container(
                        width: Get.width / 3.5,
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: mainColor,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Text(
                          'Process',
                          style: TextStyle(
                            //fontFamily: 'Mukta',
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
