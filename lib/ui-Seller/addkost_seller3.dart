import 'dart:developer';

import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';

class AddKostPage3 extends StatefulWidget {
  @override
  _AddKostPage3State createState() => _AddKostPage3State();
}

class _AddKostPage3State extends State<AddKostPage3> {
  TextEditingController kostRule = TextEditingController();
  TextEditingController roomRule = TextEditingController();

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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Peraturan",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 25.h),
            Text('Peraturan Kost',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.black45)),
            SizedBox(height: 4.h),
            TextField(
              controller: kostRule,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: 'Tambahkan Peraturan Kost',
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
            SizedBox(height: 20.h),
            Text('Peraturan Kamar',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.black45)),
            SizedBox(height: 4.h),
            TextField(
              controller: roomRule,
              keyboardType: TextInputType.multiline,
              maxLines: null,
              decoration: InputDecoration(
                  hintText: 'Tambahkan Peraturan Kamar',
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
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: Row(
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
                          log("PERATURAN KOST: " + kostRule.text);
                          log("PERATURAN KAMAR: " + roomRule.text);
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
