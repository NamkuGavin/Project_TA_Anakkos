import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/ui-User/invoice_page.dart';

class KonfirmasiPhotoPage extends StatefulWidget {
  final KostDummyModel model;
  final DateTime dateDari;
  final DateTime dateSampai;
  final String imagePath;
  KonfirmasiPhotoPage(
      {Key? key,
      required this.imagePath,
      required this.model,
      required this.dateDari,
      required this.dateSampai})
      : super(key: key);

  @override
  State<KonfirmasiPhotoPage> createState() => _KonfirmasiPhotoPageState();
}

class _KonfirmasiPhotoPageState extends State<KonfirmasiPhotoPage> {
  Future _retakePicture(BuildContext context) async {
    final navigator = Navigator.of(context);
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.camera, preferredCameraDevice: CameraDevice.rear);

      if (pickedImage != null) {
        await navigator.pushReplacement(
          MaterialPageRoute(
            builder: (context) => KonfirmasiPhotoPage(
                imagePath: pickedImage!.path,
                model: widget.model,
                dateDari: widget.dateDari,
                dateSampai: widget.dateSampai),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No image was selected"),
          ),
        );
      }
    } catch (e) {
      print(e);
      print("error");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: ColorValues.primaryBlue,
          title: Text(
            "Konfirmasi Foto Pembayaran",
            style: GoogleFonts.roboto(fontSize: 20),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Container(
                  height: 600.h,
                  width: 300.w,
                  child: Image.file(
                    File(widget.imagePath),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.red, shape: BoxShape.circle),
                          child: IconButton(
                              onPressed: () {
                                _retakePicture(context);
                              },
                              icon: Icon(
                                Icons.clear,
                                size: 40,
                                color: Colors.white,
                              )),
                          width: 55,
                          height: 55,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Ambil Ulang",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300, fontSize: 16),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.green, shape: BoxShape.circle),
                          child: IconButton(
                            onPressed: () {
                              showAlertDialog(context);
                            },
                            icon: Icon(
                              Icons.check,
                              size: 40,
                              color: Colors.white,
                            ),
                          ),
                          width: 55,
                          height: 55,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "Kirim Pembayaran",
                          style: GoogleFonts.roboto(
                              fontWeight: FontWeight.w300, fontSize: 16),
                        )
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the button
    Widget cancelButton = TextButton(
      child: Text("Tidak"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget okButton = TextButton(
      child: Text("Kirim"),
      onPressed: () {
        SharedCode.navigatorPush(
            context,
            InvoicePage(
              model: widget.model,
              dateDari: widget.dateDari,
              dateSampai: widget.dateSampai,
            ));
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text("Apakah anda yakin ingin mengirim?"),
      actions: [cancelButton, okButton],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
