import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_anakkos_app/common/check_status.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui-Seller/addkost_seller3.dart';

class AddKostPage2 extends StatefulWidget {
  @override
  _AddKostPage2State createState() => _AddKostPage2State();
}

class _AddKostPage2State extends State<AddKostPage2> {
  TextEditingController panjang = TextEditingController();
  TextEditingController lebar = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
            Text("Fasilitas",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold, fontSize: 22)),
            SizedBox(height: 25.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: 135.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Panjang Kamar',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.black45,
                              fontSize: 12)),
                      SizedBox(height: 4.h),
                      TextField(
                        controller: panjang,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: "m²",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffD6D6D6)),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorValues.primaryBlue),
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ],
                  ),
                ),
                Text(
                  "X",
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(
                  width: 135.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Text('Lebar Kamar',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.black45,
                              fontSize: 12)),
                      SizedBox(height: 4.h),
                      TextField(
                        controller: lebar,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            suffixText: "m²",
                            enabledBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: Color(0xffD6D6D6)),
                                borderRadius: BorderRadius.circular(8)),
                            focusedBorder: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: ColorValues.primaryBlue),
                                borderRadius: BorderRadius.circular(8))),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.h),
            Divider(color: Colors.black),
            SizedBox(height: 10.h),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tempat Tidur',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Checkbox(
                              value: CheckStatus.bantal,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.bantal = value!;
                                });
                              },
                            ),
                            Text("Bantal"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: CheckStatus.kasur,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.kasur = value!;
                                });
                              },
                            ),
                            Text("Kasur"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(color: Colors.black),
                  Padding(
                    padding: EdgeInsets.only(right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Kamar mandi',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Checkbox(
                              value: CheckStatus.kamarMandi,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.kamarMandi = value!;
                                });
                              },
                            ),
                            Text("Luar"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: CheckStatus.laundry,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.laundry = value!;
                                });
                              },
                            ),
                            Text("Dalam"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.black),
            SizedBox(height: 10.h),
            IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 12, right: 7),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Lain - lain',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Checkbox(
                              value: CheckStatus.lemari,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.lemari = value!;
                                });
                              },
                            ),
                            Text("Lemari"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: CheckStatus.meja,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.meja = value!;
                                });
                              },
                            ),
                            Text("Meja"),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: CheckStatus.kursi,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.kursi = value!;
                                });
                              },
                            ),
                            Text("Kursi"),
                          ],
                        ),
                      ],
                    ),
                  ),
                  VerticalDivider(color: Colors.black),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Sirkulasi Udara',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              color: Colors.black45)),
                      SizedBox(height: 4.h),
                      Row(
                        children: [
                          Checkbox(
                            value: CheckStatus.kipas,
                            onChanged: (bool? value) {
                              setState(() {
                                CheckStatus.kipas = value!;
                              });
                            },
                          ),
                          Text("Kipas"),
                        ],
                      ),
                      Row(
                        children: [
                          Checkbox(
                            value: CheckStatus.ac,
                            onChanged: (bool? value) {
                              setState(() {
                                CheckStatus.ac = value!;
                              });
                            },
                          ),
                          Text("AC"),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(child: Container()),
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
                          Icon(Icons.keyboard_double_arrow_left),
                          Text('Kembali',
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
    );
  }
}
