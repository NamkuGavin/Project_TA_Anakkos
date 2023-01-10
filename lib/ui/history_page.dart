import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
import 'package:project_anakkos_app/ui/role_page.dart';
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
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi gagal"),
    RiwayatDummyModel("assets/dummykos/kost_2.png", "Campur", "Kost Skywalker",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Selesai"),
    RiwayatDummyModel("assets/dummykos/kost_3.png", "Perempuan", "Kost Hokage",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Selesai"),
    RiwayatDummyModel("assets/dummykos/kost_1.png", "Laki-laki", "Kost Apasaja",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Selesai"),
    RiwayatDummyModel("assets/dummykos/kost_1.png", "Laki-laki", "Kost Pelangi",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Selesai"),
    RiwayatDummyModel("assets/dummykos/kost_2.png", "Campur", "Kost Star",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Gagal"),
    RiwayatDummyModel("assets/dummykos/kost_4.png", "Perempuan", "Kost Taman",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Selesai"),
    RiwayatDummyModel("assets/dummykos/kost_3.png", "Perempuan", "Kost Regency",
        "Kudus, Bastio", "01 Sep", "17:16", "Transaksi Gagal"),
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

  sudahLogin() {
    return Scaffold(
      body: Center(
        child: Text("Sudah login"),
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
                  length: 3,
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
                            child: Text('Sedang Berjalan',
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
                        sedangBerjalan(),
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
      child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
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
                        child: Image.asset(items[index].picture_riwayat,
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
                              child: Text(items[index].jenis_kostRiwayat,
                                  style: GoogleFonts.inter(fontSize: 10)),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(items[index].nama_riwayat,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 13),
                                    Text(items[index].lokasi_riwayat,
                                        style: GoogleFonts.inter(fontSize: 10))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Text("Tanggal: " + items[index].tanggal_riwayat,
                                style: GoogleFonts.roboto(fontSize: 11)),
                            SizedBox(height: 5.h),
                            Text("Pukul: " + items[index].waktu_riwayat,
                                style: GoogleFonts.roboto(fontSize: 11)),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: Text(items[index].status_riwayat,
                                  style: GoogleFonts.roboto(
                                      fontSize: 11,
                                      color: items[index].status_riwayat ==
                                              "Transaksi Selesai"
                                          ? Colors.green
                                          : Colors.red)),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          }),
    );
  }

  sedangBerjalan() {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return Card(
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
                        child: Image.asset(items[index].picture_riwayat,
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
                              child: Text(items[index].jenis_kostRiwayat,
                                  style: GoogleFonts.inter(fontSize: 10)),
                            ),
                            SizedBox(height: 5.h),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(items[index].nama_riwayat,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11)),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 13),
                                    Text(items[index].lokasi_riwayat,
                                        style: GoogleFonts.inter(fontSize: 10))
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 5.h),
                            Text("Tanggal: " + items[index].tanggal_riwayat,
                                style: GoogleFonts.roboto(fontSize: 11)),
                            SizedBox(height: 5.h),
                            Text("Pukul: " + items[index].waktu_riwayat,
                                style: GoogleFonts.roboto(fontSize: 11)),
                            Align(
                              alignment: AlignmentDirectional.bottomEnd,
                              child: Text("Sedang berjalan",
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
            );
          }),
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
}
