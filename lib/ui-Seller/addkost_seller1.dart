import 'dart:io';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  TextEditingController _lokasiKota = TextEditingController();
  TextEditingController _lokasiProvinsi = TextEditingController();
  TextEditingController _lokasiKodePos = TextEditingController();
  TextEditingController _lokasiGoogleMaps = TextEditingController();
  String category = "";
  final _formKey = GlobalKey<FormState>();
  List<File> kostImg = [];

  Future _takePictureGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.gallery,
          preferredCameraDevice: CameraDevice.rear);

      if (pickedImage != null) {
        print("PATH: " + File(pickedImage.path).toString());
        await uploadImage(File(pickedImage.path));
        // setState(() {
        //   kostImg.add(File(pickedImage!.path));
        //   print(kostImg);
        // });
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

  Future _takePictureCamera(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);

      if (pickedImage != null) {
        print("PATH: " + File(pickedImage.path).toString());
        await uploadImage(File(pickedImage.path));
        // setState(() {
        //   kostImg.add(File(pickedImage!.path));
        //   print(kostImg);
        // });
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

  Future uploadImage(File file) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_owner").toString(),
        password: pref.getString("pass_owner").toString());
    await ApiService()
        .uploadImage(file: file, kost_id: "1", token: result.token);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
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
                Text('Preview',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600, color: Colors.black45)),
                SizedBox(height: 15.h),
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12),
                      child: InkWell(
                        onTap: () {
                          showModalBottom();
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.8),
                                spreadRadius: 2,
                                blurRadius: 5, // changes position of shadow
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
                    kostImg.isNotEmpty
                        ? SizedBox(
                            height: 200.h,
                            width: 225.w,
                            child: Scrollbar(
                              thumbVisibility: true,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemCount: kostImg.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 8),
                                    child: Image.file(kostImg[index]),
                                  );
                                },
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
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
                  controller: _lokasiKota,
                  validator: (value) => SharedCode().emptyValidator(value),
                  decoration: InputDecoration(
                      hintText: "Masukkan Kota",
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
                  controller: _lokasiProvinsi,
                  validator: (value) => SharedCode().emptyValidator(value),
                  decoration: InputDecoration(
                      hintText: "Masukkan Provinsi",
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.black,
                          foregroundColor: Colors.white,
                          minimumSize: Size(0.w, 0.h),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                        ),
                        onPressed: () {
                          SharedCode.navigatorPop(context);
                        },
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.close),
                              Text('Batal',
                                  style: GoogleFonts.inter(fontSize: 15)),
                            ],
                          ),
                        )),
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
                              category != "") {
                            // await getLogin();
                            await SharedCode.navigatorPush(
                                context,
                                AddKostPage2(
                                  kost_name: _kostName.text,
                                  kost_type: category,
                                  total_unit: _totalKamar.text,
                                  location: _lokasiAlamat.text +
                                      ", " +
                                      _lokasiKota.text +
                                      ", " +
                                      _lokasiProvinsi.text +
                                      ", " +
                                      _lokasiKodePos.text,
                                  location_url: _lokasiGoogleMaps.text,
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
                        )),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  showModalBottom() {
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
                  _takePictureGallery(context);
                },
              ),
              ListTile(
                leading: Icon(Icons.camera_alt),
                title: Text('Camera'),
                onTap: () {
                  _takePictureCamera(context);
                },
              ),
            ],
          );
        });
  }
}
