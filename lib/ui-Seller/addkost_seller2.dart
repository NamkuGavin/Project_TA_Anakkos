import 'dart:developer';
import 'dart:io';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:project_anakkos_app/helper/check_status.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui-Seller/addkost_seller3.dart';

class AddKostPage2 extends StatefulWidget {
  final String kost_name;
  final String kost_type;
  final String total_unit;
  final String location;
  final String location_url;
  final List<File> roomImg;
  final File kostImg;

  AddKostPage2(
      {super.key,
      required this.kost_name,
      required this.kost_type,
      required this.total_unit,
      required this.location,
      required this.location_url,
      required this.roomImg,
      required this.kostImg});
  @override
  _AddKostPage2State createState() => _AddKostPage2State();
}

class _AddKostPage2State extends State<AddKostPage2> {
  TextEditingController panjang = TextEditingController();
  TextEditingController lebar = TextEditingController();
  List<int> idFacility = [];
  final _formKey = GlobalKey<FormState>();
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
      body: Form(
        key: _formKey,
        child: Padding(
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
                        TextFormField(
                          validator: (value) =>
                              SharedCode().emptyValidator(value),
                          controller: panjang,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              suffixText: "m²",
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffD6D6D6)),
                                  borderRadius: BorderRadius.circular(8)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
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
                        TextFormField(
                          validator: (value) =>
                              SharedCode().emptyValidator(value),
                          controller: lebar,
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              suffixText: "m²",
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffD6D6D6)),
                                  borderRadius: BorderRadius.circular(8)),
                              errorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.red),
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
                              Checkbox(
                                value: CheckStatus.bantal,
                                onChanged: (bool? value) {
                                  int id = 1;
                                  setState(() {
                                    CheckStatus.bantal = value!;
                                    if (value != false) {
                                      idFacility.add(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    } else {
                                      idFacility.remove(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    }
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
                                  int id = 2;
                                  setState(() {
                                    CheckStatus.kasur = value!;
                                    if (value != false) {
                                      idFacility.add(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    } else {
                                      idFacility.remove(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    }
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
                                  int id = 3;
                                  setState(() {
                                    CheckStatus.kamarMandi = value!;
                                    if (value != false) {
                                      idFacility.add(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    } else {
                                      idFacility.remove(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    }
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
                                  int id = 4;
                                  setState(() {
                                    CheckStatus.laundry = value!;
                                    if (value != false) {
                                      idFacility.add(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    } else {
                                      idFacility.remove(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    }
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
                                  int id = 5;
                                  setState(() {
                                    CheckStatus.lemari = value!;
                                    if (value != false) {
                                      idFacility.add(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    } else {
                                      idFacility.remove(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    }
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
                                  int id = 6;
                                  setState(() {
                                    CheckStatus.meja = value!;
                                    if (value != false) {
                                      idFacility.add(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    } else {
                                      idFacility.remove(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    }
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
                                  int id = 7;
                                  setState(() {
                                    CheckStatus.kursi = value!;
                                    if (value != false) {
                                      idFacility.add(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    } else {
                                      idFacility.remove(id);
                                      print(
                                          "LIST ID: " + idFacility.toString());
                                    }
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
                                int id = 9;
                                setState(() {
                                  CheckStatus.kipas = value!;
                                  if (value != false) {
                                    idFacility.add(id);
                                    print("LIST ID: " + idFacility.toString());
                                  } else {
                                    idFacility.remove(id);
                                    print("LIST ID: " + idFacility.toString());
                                  }
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
                                int id = 8;
                                setState(() {
                                  CheckStatus.ac = value!;
                                  if (value != false) {
                                    idFacility.add(id);
                                    print("LIST ID: " + idFacility.toString());
                                  } else {
                                    idFacility.remove(id);
                                    print("LIST ID: " + idFacility.toString());
                                  }
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
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          // await getLogin();
                          await SharedCode.navigatorPush(
                              context,
                              AddKostPage3(
                                panjang: panjang.text,
                                lebar: lebar.text,
                                kost_name: widget.kost_name,
                                kost_type: widget.kost_type,
                                total_unit: widget.total_unit,
                                location: widget.location,
                                location_url: widget.location_url,
                                idFacility: idFacility,
                                roomImg: widget.roomImg,
                                kostImg: widget.kostImg,
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
    );
  }
}
