import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/riwayat_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  Widget _widget = Container();
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  Timer? _timer;
  bool _isloading = false;
  List<RiwayatDummyModel> items = [
    RiwayatDummyModel("assets/dummykos/kost_4.png", "Laki-laki", "Kost Subadi",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi gagal", "10, Oct 2021"),
    RiwayatDummyModel(
        "assets/dummykos/kost_2.png",
        "Campur",
        "Kost Skywalker",
        "Kudus, Bastio",
        "01 Sep",
        "17:16",
        "Transaksi Selesai",
        "10, Jan 2022"),
    RiwayatDummyModel("assets/dummykos/kost_3.png", "Perempuan", "Kost Hokage",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Selesai", "1, Mar 2022"),
    RiwayatDummyModel(
        "assets/dummykos/kost_1.png",
        "Laki-laki",
        "Kost Apasaja",
        "Kudus, Bastio",
        "01 Sep",
        "17:16",
        "Transaksi Selesai",
        "15, Apr 2022"),
    RiwayatDummyModel(
        "assets/dummykos/kost_1.png",
        "Laki-laki",
        "Kost Pelangi",
        "Kudus, Bastio",
        "01 Sep",
        "17:16",
        "Transaksi Selesai",
        "30, Jun 2022"),
    RiwayatDummyModel("assets/dummykos/kost_2.png", "Campur", "Kost Star",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Gagal", "20 Sep 2022"),
    RiwayatDummyModel(
        "assets/dummykos/kost_4.png",
        "Perempuan",
        "Kost Taman",
        "Kudus, Bastio",
        "01 Sep",
        "17:16",
        "Transaksi Selesai",
        "10, Des 2022"),
    RiwayatDummyModel("assets/dummykos/kost_3.png", "Perempuan", "Kost Regency",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Gagal", "1, Jan 2023"),
  ];

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  _checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("token") == null && user == null) {
      setState(() {
        _widget = belumLogin();
      });
    } else if (user != null) {
      print("GOOGLE LOGIN");
      setState(() {
        _widget = sudahLoginGoogle();
      });
    } else {
      print("APPS LOGIN");
      await getLoginApps();
      setState(() {
        _widget = sudahLoginApps();
      });
    }
  }

  getLoginApps() async {
    setState(() {
      _isloading = true;
      _timer?.cancel();
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    LoginModel result = await ApiService().getLogin(
        email: prefs.getString("email").toString(),
        password: prefs.getString("password").toString());
    setState(() {
      _isloading = false;
      _timer?.cancel();
      EasyLoading.dismiss();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _widget;
  }

  belumLogin() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logo/blm_login.svg", width: 175.w),
              SizedBox(height: 40.h),
              Text("Login terlebih dahulu untuk mengakses fitur ini",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              SizedBox(height: 25.h),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 300.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: ColorValues.primaryBlue,
                        onPrimary: Colors.white,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        SharedCode.navigatorPush(context, RolePage());
                      },
                      child: Text('Login',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sudahLoginApps() {
    _timer?.cancel();
    EasyLoading.dismiss();
    return Scaffold(
        body: _isloading
            ? Center()
            : Center(
                child: Text("Sudah login Apps"),
              ));
  }

  sudahLoginGoogle() {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
            future: _users.doc(user!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                print("ERROR: " + snapshot.hasError.toString());
                return Center(child: Text("Something Wrong"));
              } else {
                return DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: AppBar(
                      backgroundColor: Colors.white,
                      centerTitle: true,
                      bottom: TabBar(
                        indicatorWeight: 3,
                        indicatorColor: ColorValues.primaryPurple,
                        tabs: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Riwayat',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8.0),
                            child: Text('Booking Pending',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 11)),
                          ),
                        ],
                      ),
                      title: Text('History',
                          style: TextStyle(color: Colors.black)),
                    ),
                    body: TabBarView(
                      children: [
                        riwayat(),
                        bookingPending(),
                      ],
                    ),
                  ),
                );
              }
            }));
  }

  riwayat() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ongoingKost(),
          SizedBox(height: 10.h),
          Expanded(
            child: ListView.builder(
                shrinkWrap: true,
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    height: 150.h,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 20, bottom: 5),
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Text(items[index].kapan_sewa,
                                    style: GoogleFonts.inter(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 12,
                                    )),
                              ),
                              Expanded(
                                child: Divider(
                                  color: Colors.grey,
                                  thickness: 0.5,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Card(
                            color: Colors.white,
                            elevation: 4,
                            shadowColor: Colors.black,
                            child: IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                      width: 100,
                                      child: Image.asset(
                                          items[index].picture_riwayat,
                                          fit: BoxFit.fill)),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          DottedBorder(
                                            color: Colors.black,
                                            strokeWidth: 1,
                                            child: Text(
                                                items[index].jenis_kostRiwayat,
                                                style: GoogleFonts.inter(
                                                    fontSize: 10)),
                                          ),
                                          SizedBox(height: 5.h),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(items[index].nama_riwayat,
                                                  style: GoogleFonts.inter(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 11)),
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Icon(
                                                      Icons.location_on_rounded,
                                                      size: 13),
                                                  Text(
                                                      items[index]
                                                          .lokasi_riwayat,
                                                      style: GoogleFonts.inter(
                                                          fontSize: 10))
                                                ],
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 5.h),
                                          Text(
                                              "Tanggal: " +
                                                  items[index].tanggal_riwayat,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 11)),
                                          SizedBox(height: 5.h),
                                          Text(
                                              "Pukul: " +
                                                  items[index].waktu_riwayat,
                                              style: GoogleFonts.roboto(
                                                  fontSize: 11)),
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }

  bookingPending() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView(
        children: [
          Card(
            color: Colors.white,
            elevation: 4,
            shadowColor: Colors.black,
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      width: 100,
                      child: Image.asset(items[1].picture_riwayat,
                          fit: BoxFit.fill)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          DottedBorder(
                            color: Colors.black,
                            strokeWidth: 1,
                            child: Text(items[1].jenis_kostRiwayat,
                                style: GoogleFonts.inter(fontSize: 10)),
                          ),
                          SizedBox(height: 5.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(items[1].nama_riwayat,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11)),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on_rounded, size: 13),
                                  Text(items[1].lokasi_riwayat,
                                      style: GoogleFonts.inter(fontSize: 10))
                                ],
                              ),
                            ],
                          ),
                          SizedBox(height: 5.h),
                          Text("Tanggal: " + items[1].tanggal_riwayat,
                              style: GoogleFonts.roboto(fontSize: 11)),
                          SizedBox(height: 5.h),
                          Text("Pukul: " + items[1].waktu_riwayat,
                              style: GoogleFonts.roboto(fontSize: 11)),
                          Align(
                            alignment: AlignmentDirectional.bottomEnd,
                            child: Text("Pending",
                                style: GoogleFonts.roboto(
                                    fontSize: 11, color: Colors.orange)),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _ongoingKost() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Sedang Berjalan",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    )),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          Container(
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
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(10)),
                    child: Container(
                        width: 100.w,
                        child: Image.asset("assets/dummykos/kost_2.png",
                            fit: BoxFit.fill)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0XFFFD9900),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text("Pending",
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10)),
                                ),
                              ),
                              Text("17 August 2022 ",
                                  style: GoogleFonts.roboto(fontSize: 11)),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Text("Kost Duniawi",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold, fontSize: 11)),
                          SizedBox(height: 7.h),
                          Text("Total : Rp. 568.400",
                              style: GoogleFonts.roboto(fontSize: 11)),
                          SizedBox(height: 7.h),
                          Text("Stay duration: 27 Aug - 27 Sep",
                              style: GoogleFonts.roboto(fontSize: 11)),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}