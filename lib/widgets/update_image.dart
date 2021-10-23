import 'dart:convert';
import 'dart:io';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';

import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:kindashop/core/xcontroller.dart';

class UpdateImage extends StatelessWidget {
  final VoidCallback? callback;
  UpdateImage({this.callback});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: InkWell(
        onTap: () {
          chooseImage();
        },
        child: Icon(
          Icons.add_a_photo,
          color: Colors.grey[400],
        ),
      ),
    );
  }

  chooseImage() {
    showMaterialModalBottomSheet(
      context: Get.context!,
      isDismissible: true,
      builder: (context) => SingleChildScrollView(
        controller: ModalScrollController.of(context),
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              ListTile(
                onTap: () {
                  Get.back();
                  Future.delayed(Duration(milliseconds: 400), () {
                    pickImageSource(2);
                  });
                },
                title: Text("Camera"),
                leading: Icon(Feather.camera),
                trailing: Icon(Feather.chevron_right),
              ),
              Divider(),
              ListTile(
                onTap: () {
                  Get.back();
                  Future.delayed(Duration(milliseconds: 400), () {
                    pickImageSource(1);
                  });
                },
                title: Text("Gallery"),
                leading: Icon(Feather.image),
                trailing: Icon(Feather.chevron_right),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // additional photo uploader
  final picker = ImagePicker();
  pickImageSource(int tipe) {
    Future<PickedFile?>? file = picker.getImage(
        source: tipe == 1 ? ImageSource.gallery : ImageSource.camera);
    file.then((PickedFile? pickFile) {
      Future.delayed(Duration(milliseconds: 500), () {
        if (pickFile != null) {
          _cropImage(File(pickFile.path));
        }
      });
    });
  }

  Future<Null> _cropImage(File? imageFile) async {
    File? croppedFile = await ImageCropper.cropImage(
        sourcePath: imageFile!.path,
        aspectRatioPresets: GetPlatform.isAndroid
            ? [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio16x9
              ]
            : [
                CropAspectRatioPreset.square,
                CropAspectRatioPreset.ratio3x2,
                CropAspectRatioPreset.ratio4x3,
                CropAspectRatioPreset.ratio5x3,
                CropAspectRatioPreset.ratio5x4,
                CropAspectRatioPreset.ratio7x5,
                CropAspectRatioPreset.ratio16x9
              ],
        androidUiSettings: AndroidUiSettings(
            toolbarTitle: 'Crop Image',
            toolbarColor: Colors.white,
            toolbarWidgetColor: Get.theme.accentColor,
            initAspectRatio: CropAspectRatioPreset
                .ratio3x2, //CropAspectRatioPreset.original,
            lockAspectRatio: false),
        iosUiSettings: IOSUiSettings(
          title: 'Crop Image',
        ));
    if (croppedFile != null) {
      File? tmpFile = croppedFile;
      String? base64Image = base64Encode(tmpFile.readAsBytesSync());
      startUpload(base64Image, tmpFile);
    }
  }

  startUpload(String? base64Image, File? tmpFile) {
    EasyLoading.show(status: 'Loading...');

    if (null == tmpFile) {
      EasyLoading.dismiss();
      EasyLoading.showError('Pick/Find another image');
      return;
    }
    String fileName = tmpFile.path.split('/').last;
    upload(base64Image!, fileName);
  }

  upload(String base64Image, String fileName) async {
    final XController x = XController.to;
    dynamic member = x.member;
    String idUser = member['id_member'] ?? "";

    var dataPush = jsonEncode({
      "filename": fileName,
      "id": idUser,
      "image": base64Image,
    });

    //print(dataPush);
    var link = "upload/upload_photo?id=$idUser";
    //print(link);

    http
        .post(
          Uri.parse(XController.BASE_URL_API + link),
          body: dataPush,
        )
        .timeout(Duration(seconds: 250))
        .then((result) {
      //print(result.body);
      dynamic _result = jsonDecode(result.body);
      //print(_result);

      EasyLoading.dismiss();
      if (_result['code'] == '200') {
        EasyLoading.showSuccess("Process success...");
        Future.delayed(Duration(seconds: 1), () async {
          x.getHome();

          Future.delayed(Duration(seconds: 2), () async {
            getMemberByIdEmail(x);
          });
        });
      } else {
        EasyLoading.showError("Process failed...");
      }
    }).catchError((error) {
      print(error);

      EasyLoading.dismiss();
    });
  }

  getMemberByIdEmail(final XController x) async {
    try {
      var dataPush = jsonEncode({
        "is": "${x.member['id_install']}",
        "em": "${x.member['email']}",
      });

      //print(dataPush);

      final response = await x.pushResponse('member/get_member', dataPush);
      //print(response.body);

      if (response != null && response.statusCode == 200) {
        dynamic _result = jsonDecode(response.body);
        //print(_result);
        if (_result['code'] == '200') {
          dynamic _res = _result['result'][0];
          x.saveMember(jsonEncode(_res));
        }
      }
    } catch (e) {}
  }
}
