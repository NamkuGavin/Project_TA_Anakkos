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
                                  borderSide: BorderSide(
                                      color: ColorValues.primaryBlue),
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
                                  borderSide: BorderSide(
                                      color: ColorValues.primaryBlue),
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
                              Text("Bantal"),
                              Checkbox(
                                value: CheckStatus.bantal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.bantal = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Guling"),
                              Checkbox(
                                value: CheckStatus.guling,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.guling = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Kasur"),
                              Checkbox(
                                value: CheckStatus.kasur,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kasur = value!;
                                  });
                                },
                              ),
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
                        Text('Kebersihan',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 4.h),
                        Row(
                          children: [
                            Text("Kamar Mandi"),
                            Checkbox(
                              value: CheckStatus.kamarMandi,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.kamarMandi = value!;
                                });
                              },
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Laundry"),
                            Checkbox(
                              value: CheckStatus.laundry,
                              onChanged: (bool? value) {
                                setState(() {
                                  CheckStatus.laundry = value!;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
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
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Konsumsi',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text("Dapur"),
                              Checkbox(
                                value: CheckStatus.dapur,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.dapur = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Kulkas"),
                              Checkbox(
                                value: CheckStatus.kulkas,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kulkas = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Katering"),
                              Checkbox(
                                value: CheckStatus.katering,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.katering = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(color: Colors.black),
                    Padding(
                      padding: EdgeInsets.only(right: 65),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Hiburan',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text("Wifi"),
                              Checkbox(
                                value: CheckStatus.wifi,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.wifi = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("TV"),
                              Checkbox(
                                value: CheckStatus.tv,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.tv = value!;
                                  });
                                },
                              ),
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
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Furniture',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text("Lemari"),
                              Checkbox(
                                value: CheckStatus.lemari,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.lemari = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Meja"),
                              Checkbox(
                                value: CheckStatus.meja,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.meja = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Kursi"),
                              Checkbox(
                                value: CheckStatus.kursi,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kursi = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(color: Colors.black),
                    Padding(
                      padding: EdgeInsets.only(right: 30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Udara',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Text("Jendela"),
                              Checkbox(
                                value: CheckStatus.jendela,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.jendela = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("Kipas"),
                              Checkbox(
                                value: CheckStatus.kipas,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kipas = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("AC"),
                              Checkbox(
                                value: CheckStatus.ac,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.ac = value!;
                                  });
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25.h),
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
