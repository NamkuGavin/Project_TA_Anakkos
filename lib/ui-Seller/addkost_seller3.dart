import 'dart:developer';

import 'package:currency_text_input_formatter/currency_text_input_formatter.dart';
import 'package:custom_radio_grouped_button/custom_radio_grouped_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_stepper/cupertino_stepper.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/helper/check_status.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/model/create_kost_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-Seller/success_sell_kost.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_confirmSeller.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddKostPage3 extends StatefulWidget {
  final String panjang;
  final String lebar;
  final String kost_name;
  final String kost_type;
  final String total_unit;
  final String location;
  final String location_url;
  final List<int> idFacility;

  AddKostPage3(
      {super.key,
      required this.panjang,
      required this.lebar,
      required this.kost_name,
      required this.kost_type,
      required this.total_unit,
      required this.location,
      required this.location_url,
      required this.idFacility});
  @override
  _AddKostPage3State createState() => _AddKostPage3State();
}

class _AddKostPage3State extends State<AddKostPage3> {
  TextEditingController kostRule = TextEditingController();
  TextEditingController roomRule = TextEditingController();
  TextEditingController descKost = TextEditingController();
  TextEditingController electPrice = TextEditingController();
  TextEditingController roomPrice = TextEditingController();
  bool _isEnableTermasuk = true;
  bool _isEnableBerbayar = true;
  final _formKey = GlobalKey<FormState>();
  bool _isLoad = false;

  Future createKost() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoad = true;
    });
    LoginModel res_login = await ApiService().getLogin(
        email: pref.getString("email_owner").toString(),
        password: pref.getString("pass_owner").toString());
    CreateKostModel res_createKost = await ApiService().createKost(
        token: res_login.token,
        kost_name: widget.kost_name,
        kost_type: widget.kost_type,
        total_unit: widget.total_unit,
        location: widget.location,
        location_url: widget.location_url,
        width: widget.panjang,
        weight: widget.lebar,
        kost_rules: kostRule.text,
        room_rules: roomRule.text,
        desc: descKost.text,
        elec_price: electPrice.text.isEmpty ? "0" : electPrice.text,
        room_price: roomPrice.text,
        seller_id: res_login.data.id);
    await ApiService().createDetailKost(
        token: res_login.token,
        seller_id: res_login.data.id.toString(),
        kost_id: res_createKost.data.id.toString(),
        status: 'pending');
    await ApiService().createFacilityKost(
        token: res_login.token,
        kost_id: res_createKost.data.id,
        facilityId: widget.idFacility);
    setState(() {
      _isLoad = false;
    });
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
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: SingleChildScrollView(
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
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 4.h),
                        TextFormField(
                          validator: (value) =>
                              SharedCode().emptyValidator(value),
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
                        SizedBox(height: 20.h),
                        Divider(color: Colors.black),
                        SizedBox(height: 20.h),
                        Text('Peraturan Kamar',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 4.h),
                        TextFormField(
                          validator: (value) =>
                              SharedCode().emptyValidator(value),
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
                        SizedBox(height: 25.h),
                        Text("Lain - Lain",
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold, fontSize: 22)),
                        SizedBox(height: 25.h),
                        Text('Deskripsi Kos',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 5.h),
                        TextFormField(
                          controller: descKost,
                          validator: (value) =>
                              SharedCode().emptyValidator(value),
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          decoration: InputDecoration(
                              hintText: 'Tambahkan Deskripsi Kos',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500),
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
                        SizedBox(height: 25.h),
                        Text('Listrik',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        Row(
                          children: [
                            Text("Termasuk"),
                            Checkbox(
                              value: CheckStatus.termasukListrik,
                              onChanged: _isEnableTermasuk
                                  ? (bool? value) {
                                      setState(() {
                                        CheckStatus.termasukListrik = value!;
                                        if (value == true) {
                                          CheckStatus.bayarListrik = false;
                                          _isEnableTermasuk = false;
                                          _isEnableBerbayar = true;
                                        }
                                        print("TERMASUK: " + value.toString());
                                        print("BERBAYAR: " +
                                            CheckStatus.bayarListrik
                                                .toString());
                                      });
                                    }
                                  : null,
                            ),
                            Text("Berbayar"),
                            Checkbox(
                              value: CheckStatus.bayarListrik,
                              onChanged: _isEnableBerbayar
                                  ? (bool? value) {
                                      setState(() {
                                        CheckStatus.bayarListrik = value!;
                                        if (value == true) {
                                          CheckStatus.termasukListrik = false;
                                          _isEnableTermasuk = true;
                                          _isEnableBerbayar = false;
                                        }
                                        print("BERBAYAR: " + value.toString());
                                        print("TERMASUK: " +
                                            CheckStatus.termasukListrik
                                                .toString());
                                      });
                                    }
                                  : null,
                            ),
                          ],
                        ),
                        CheckStatus.bayarListrik == false &&
                                CheckStatus.termasukListrik == false
                            ? Padding(
                                padding: EdgeInsets.only(left: 4.w),
                                child: Text("Pilih salah satu opsi di atas*",
                                    style: TextStyle(
                                        color: Colors.red.shade700,
                                        fontSize: 12)),
                              )
                            : Container(),
                        CheckStatus.bayarListrik
                            ? TextFormField(
                                controller: electPrice,
                                validator: (value) =>
                                    SharedCode().emptyValidator(value),
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    prefixText: "Rp ",
                                    suffixText: "/ Bulan",
                                    hintText: 'Tambahkan Biaya Listrik',
                                    hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w500),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD6D6D6)),
                                        borderRadius: BorderRadius.circular(8)),
                                    errorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8)),
                                    focusedErrorBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.red),
                                        borderRadius: BorderRadius.circular(8)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorValues.primaryBlue),
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              )
                            : Container(),
                        SizedBox(height: 10.h),
                        Text('Bayaran',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 4.h),
                        TextFormField(
                          controller: roomPrice,
                          validator: (value) =>
                              SharedCode().emptyValidator(value),
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              prefixText: "Rp ",
                              suffixText: CheckStatus.bayarListrik == false
                                  ? "/ Bulan + Listrik"
                                  : "/ Bulan",
                              hintText: CheckStatus.bayarListrik == false
                                  ? 'Biaya Kamar'
                                  : 'Tambahkan Biaya Kamar',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500),
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
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.keyboard_double_arrow_left),
                                      Text('Kembali',
                                          style:
                                              GoogleFonts.inter(fontSize: 15)),
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
                                          CheckStatus.bayarListrik != false ||
                                      CheckStatus.termasukListrik != false) {
                                    // await getLogin();
                                    await createKost();
                                    await SharedCode.navigatorPush(
                                        context, SuccessPageSeller());
                                  }
                                },
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('Selanjutnya',
                                          style:
                                              GoogleFonts.inter(fontSize: 15)),
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
            ),
            _isLoad ? LoadingAnimation() : Container()
          ],
        ),
      ),
    );
  }

  // Future _showDialog(context) {
  //   return showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialogConfirmSeller();
  //     },
  //   );
  // }
}
