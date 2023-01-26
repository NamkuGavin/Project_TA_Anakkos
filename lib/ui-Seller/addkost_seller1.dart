import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui-Seller/addkost_seller3.dart';

class AddKostPage1 extends StatefulWidget {
  @override
  _AddKostPage1State createState() => _AddKostPage1State();
}

class _AddKostPage1State extends State<AddKostPage1> {
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
      body: Padding(
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
              TextField(
                decoration: InputDecoration(
                    hintText: 'Masukkan Nama Kost',
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black26,
                        fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD6D6D6)),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorValues.primaryBlue),
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(height: 25.h),
              Text('Preview',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black45)),
              //TODO: WIDGET FOTO
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
                  "MALE",
                  "MIX",
                  "WOMAN",
                ],
                buttonTextStyle: ButtonTextStyle(
                    selectedColor: ColorValues.primaryPurple,
                    unSelectedColor: Colors.black,
                    textStyle: TextStyle(fontSize: 12)),
                radioButtonValue: (value) {
                  print(value);
                },
                selectedColor: Colors.white,
              ),
              SizedBox(height: 25.h),
              Text('Banyak kamar',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black45)),
              SizedBox(height: 4.h),
              TextField(
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
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorValues.primaryBlue),
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(height: 20.h),
              Divider(color: Colors.black),
              SizedBox(height: 10.h),
              Text('Lokasi',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black45)),
              SizedBox(height: 4.h),
              TextField(
                decoration: InputDecoration(
                    hintText: "Masukkan Alamat Lengkap",
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black26,
                        fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD6D6D6)),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorValues.primaryBlue),
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(height: 15.h),
              TextField(
                decoration: InputDecoration(
                    hintText: "Masukkan Kota",
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black26,
                        fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD6D6D6)),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorValues.primaryBlue),
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(height: 15.h),
              TextField(
                decoration: InputDecoration(
                    hintText: "Masukkan Provinsi",
                    hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black26,
                        fontWeight: FontWeight.w500),
                    enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffD6D6D6)),
                        borderRadius: BorderRadius.circular(8)),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorValues.primaryBlue),
                        borderRadius: BorderRadius.circular(8))),
              ),
              SizedBox(height: 15.h),
              TextField(
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
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: ColorValues.primaryBlue),
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
                      onPressed: () {
                        SharedCode.navigatorPush(context, AddKostPage3());
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
    );
  }
}
