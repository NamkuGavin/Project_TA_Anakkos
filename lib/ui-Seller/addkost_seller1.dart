import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-Seller/addkost_seller2.dart';
import 'package:project_anakkos_app/ui-Seller/addkost_seller3.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddKostPage1 extends StatefulWidget {
  @override
  _AddKostPage1State createState() => _AddKostPage1State();
}

class _AddKostPage1State extends State<AddKostPage1> {
  TextEditingController _kostName = TextEditingController();
  TextEditingController _totalKamar = TextEditingController();
  TextEditingController _lokasiAlamat = TextEditingController();
  TextEditingController _lokasiKodePos = TextEditingController();
  TextEditingController _lokasiGoogleMaps = TextEditingController();
  String category = "";
  final _formKey = GlobalKey<FormState>();
  List<File> roomImg = [];
  File? kostImg;

  Future _takePictureGalleryRoom(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.rear);

      if (pickedImage != null) {
        print("PATH: " + File(pickedImage.path).toString());
        print("TYPE: " + File(pickedImage.mimeType.toString()).toString());
        print("NAME: " + File(pickedImage.name.toString()).toString());
        setState(() {
          roomImg.add(File(pickedImage!.path));
          print(roomImg);
        });
      } else {
        await SharedCode.navigatorPop(context);
        await ScaffoldMessenger.of(context).showSnackBar(
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

  Future _takePictureCameraRoom(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front);

      if (pickedImage != null) {
        print("PATH: " + File(pickedImage.path).toString());
        print("TYPE: " + File(pickedImage.mimeType.toString()).toString());
        print("NAME: " + File(pickedImage.name.toString()).toString());
        setState(() {
          roomImg.add(File(pickedImage!.path));
          print(roomImg);
        });
      } else {
        await SharedCode.navigatorPop(context);
        await ScaffoldMessenger.of(context).showSnackBar(
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

  Future _takePictureGalleryKost(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.rear);

      if (pickedImage != null) {
        print("PATH: " + File(pickedImage.path).toString());
        print("TYPE: " + File(pickedImage.mimeType.toString()).toString());
        print("NAME: " + File(pickedImage.name.toString()).toString());
        setState(() {
          kostImg = File(pickedImage!.path);
          print(roomImg);
        });
      } else {
        await SharedCode.navigatorPop(context);
        await ScaffoldMessenger.of(context).showSnackBar(
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

  Future _takePictureCameraKost(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          imageQuality: 50,
          preferredCameraDevice: CameraDevice.front);

      if (pickedImage != null) {
        print("PATH: " + File(pickedImage.path).toString());
        print("TYPE: " + File(pickedImage.mimeType.toString()).toString());
        print("NAME: " + File(pickedImage.name.toString()).toString());
        setState(() {
          kostImg = File(pickedImage!.path);
          print(roomImg);
        });
      } else {
        await SharedCode.navigatorPop(context);
        await ScaffoldMessenger.of(context).showSnackBar(
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
    return Scaffold(
      backgroundColor: Color(0xFFF9F9F9),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFECECEC),
        title: Text("Add Kost",
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 17)),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(0.0),
          child: Container(
            color: Colors.black,
            height: 0.2.h,
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("General",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold, fontSize: 22)),
                SizedBox(height: 25.h),
                Text('Nama Kost',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black45)),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: _kostName,
                  validator: (value) => SharedCode().emptyValidator(value),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Masukkan Nama Kost',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD6D6D6)),
                          borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorValues.primaryBlue),
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 25.h),
                Text('Kost Picture',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black45)),
                SizedBox(height: 15.h),
                Center(
                  child: kostImg != null
                      ? Stack(
                          children: [
                            Image.file(
                              File(kostImg!.path),
                              height: 175.h,
                              width: double.infinity,
                              fit: BoxFit.fill,
                            ),
                            Positioned(
                              top: 10,
                              left: 10,
                              child: CircleAvatar(
                                radius: 20,
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: Icon(Icons.delete_forever,
                                      color: Colors.black, size: 23),
                                  onPressed: () {
                                    setState(() {
                                      kostImg = null;
                                    });
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      : InkWell(
                          onTap: () {
                            showOptionKostImg();
                          },
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: EdgeInsets.all(15),
                              child: DottedBorder(
                                  color: Colors.grey.shade500,
                                  strokeWidth: 1.25,
                                  dashPattern: [8, 4],
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 35, vertical: 15),
                                    child: Column(
                                      children: [
                                        SvgPicture.asset(
                                            "assets/images/gallery.svg"),
                                        Text("Click here to upload your image",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 13)),
                                        Text("Supports JPG, JPEG, PNG",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 10,
                                                color: Colors.grey))
                                      ],
                                    ),
                                  )),
                            ),
                          ),
                        ),
                ),
                kostImg == null
                    ? Padding(
                        padding: EdgeInsets.only(left: 9.w, top: 15.h),
                        child: Text(
                            "Pilih gambar untuk foto kost / cover image*",
                            style: TextStyle(
                                color: Colors.red.shade700, fontSize: 12)),
                      )
                    : Container(),
                SizedBox(height: 25.h),
                Text('Foto Kamar',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black45)),
                SizedBox(height: 15.h),
                roomImg.isNotEmpty
                    ? Row(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: InkWell(
                              onTap: () {
                                showOptionRoomImg();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.8),
                                      spreadRadius: 2,
                                      blurRadius:
                                          5, // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Icon(Icons.add, size: 50.w),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 200.h,
                            width: 225.w,
                            child: Scrollbar(
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: roomImg.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Stack(
                                      children: [
                                        Image.file(roomImg[index]),
                                        Positioned(
                                          top: 10,
                                          left: 10,
                                          child: CircleAvatar(
                                            radius: 20,
                                            backgroundColor: Colors.white,
                                            child: IconButton(
                                              icon: Icon(Icons.delete_forever,
                                                  color: Colors.black,
                                                  size: 23),
                                              onPressed: () {
                                                setState(() {
                                                  roomImg.removeAt(index);
                                                });
                                              },
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      )
                    : InkWell(
                        onTap: () {
                          showOptionRoomImg();
                        },
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: EdgeInsets.all(15),
                            child: DottedBorder(
                                color: Colors.grey.shade500,
                                strokeWidth: 1.25,
                                dashPattern: [8, 4],
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 35, vertical: 15),
                                  child: Column(
                                    children: [
                                      SvgPicture.asset(
                                          "assets/images/gallery.svg"),
                                      Text("Click here to upload your image",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 13)),
                                      Text("Supports JPG, JPEG, PNG",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                              color: Colors.grey))
                                    ],
                                  ),
                                )),
                          ),
                        ),
                      ),
                roomImg.isEmpty
                    ? Padding(
                        padding: EdgeInsets.only(left: 9.w, top: 15.h),
                        child: Text("Pilih gambar untuk foto-foto ruangan*",
                            style: TextStyle(
                                color: Colors.red.shade700, fontSize: 12)),
                      )
                    : Container(),
                SizedBox(height: 15.h),
                Divider(color: Colors.black),
                SizedBox(height: 10.h),
                Text('Category',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black45)),
                SizedBox(height: 4.h),
                CustomRadioButton(
                  width: 100.h,
                  selectedBorderColor: ColorValues.primaryPurple,
                  unSelectedBorderColor: Colors.black,
                  elevation: 0,
                  absoluteZeroSpacing: false,
                  unSelectedColor: Colors.white,
                  buttonLables: [
                    'Laki - Laki',
                    'Campur',
                    'Perempuan',
                  ],
                  buttonValues: [
                    "Cowok",
                    "Campur",
                    "Cewek",
                  ],
                  buttonTextStyle: ButtonTextStyle(
                      selectedColor: ColorValues.primaryPurple,
                      unSelectedColor: Colors.black,
                      textStyle: TextStyle(fontSize: 12)),
                  radioButtonValue: (value) {
                    setState(() {
                      category = value;
                    });
                    print(category);
                  },
                  selectedColor: Colors.white,
                ),
                category == ""
                    ? Padding(
                        padding: EdgeInsets.only(left: 9.w, top: 5.h),
                        child: Text("Pilih salah satu kategori di atas*",
                            style: TextStyle(
                                color: Colors.red.shade700, fontSize: 12)),
                      )
                    : Container(),
                SizedBox(height: 25.h),
                Text('Banyak kamar',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black45)),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: _totalKamar,
                  validator: (value) => SharedCode().emptyValidator(value),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: 'Masukkan Jumlah Kamar',
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD6D6D6)),
                          borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorValues.primaryBlue),
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 20.h),
                Divider(color: Colors.black),
                SizedBox(height: 10.h),
                Text('Lokasi',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black45)),
                SizedBox(height: 4.h),
                TextFormField(
                  controller: _lokasiAlamat,
                  validator: (value) => SharedCode().emptyValidator(value),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Masukkan Alamat Lengkap",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD6D6D6)),
                          borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorValues.primaryBlue),
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 15.h),
                TextFormField(
                  controller: _lokasiKodePos,
                  validator: (value) => SharedCode().emptyValidator(value),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Masukkan Kode Pos",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD6D6D6)),
                          borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorValues.primaryBlue),
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 15.h),
                TextFormField(
                  controller: _lokasiGoogleMaps,
                  validator: (value) => SharedCode().emptyValidator(value),
                  decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "Masukkan Link Google Maps",
                      hintStyle: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black26,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xffD6D6D6)),
                          borderRadius: BorderRadius.circular(8)),
                      errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorValues.primaryBlue),
                          borderRadius: BorderRadius.circular(8))),
                ),
                SizedBox(height: 20.h),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorValues.primaryPurple,
                      foregroundColor: Colors.white,
                      minimumSize: Size(0.w, 0.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (_formKey.currentState!.validate() &&
                          category != "" &&
                          kostImg != null &&
                          roomImg.isNotEmpty) {
                        // await getLogin();
                        await SharedCode.navigatorPush(
                            context,
                            AddKostPage2(
                              kost_name: _kostName.text,
                              kost_type: category,
                              total_unit: _totalKamar.text,
                              location: _lokasiAlamat.text +
                                  ", " +
                                  _lokasiKodePos.text,
                              location_url: _lokasiGoogleMaps.text,
                              roomImg: roomImg,
                              kostImg: kostImg!,
                            ));
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Selanjutnya',
                              style: GoogleFonts.inter(fontSize: 15)),
                          Icon(Icons.arrow_forward_ios_rounded)
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }

  showOptionRoomImg() {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Galeri'),
                onTap: () {
                  _takePictureGalleryRoom(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _takePictureCameraRoom(context);
                },
              ),
            ],
          );
        });
  }

  showOptionKostImg() {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15))),
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(Icons.folder),
                title: Text('Galeri'),
                onTap: () {
                  _takePictureGalleryKost(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _takePictureCameraKost(context);
                },
              ),
            ],
          );
        });
  }
}
