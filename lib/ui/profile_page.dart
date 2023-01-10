import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui/edit_profile.dart';
import 'package:project_anakkos_app/ui/login_page.dart';
import 'package:project_anakkos_app/ui/role_page.dart';
import 'package:project_anakkos_app/ui/terms_privacy_page.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  Widget _widget = Container();
  String username = "";
  String email = "";
  Timer? _timer;
  bool _isloading = false;
  bool _isRead = false;

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getBool("isRead") == null) {
      await pref.setBool("isRead", false);
    } else {
      null;
    }
    if (pref.getString("token") == null && user == null) {
      setState(() {
        _widget = belumLogin();
      });
    } else if (user != null) {
      await getProfileGoogle();
      print("GOOGLE LOGIN");
      setState(() {
        _widget = sudahLoginGoogle();
      });
    } else {
      print("APPS LOGIN");
      await getProfileApps();
      setState(() {
        _widget = sudahLoginApps();
      });
    }
  }

  getProfileApps() async {
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
    _isRead = prefs.getBool("isRead")!;
    print("STATUS TERMS: " + _isRead.toString());
    username = result.data.name;
    email = result.data.email;
    setState(() {
      _isloading = false;
      _timer?.cancel();
      EasyLoading.dismiss();
    });
  }

  getProfileGoogle() async {
    setState(() {
      _isloading = true;
      _timer?.cancel();
      EasyLoading.show(
        status: 'loading...',
        maskType: EasyLoadingMaskType.black,
      );
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _isRead = prefs.getBool("isRead")!;
    print("STATUS TERMS: " + _isRead.toString());
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
        body: Padding(
      padding: EdgeInsets.all(12),
      child: _isloading
          ? Center()
          : username.isEmpty || email.isEmpty
              ? Center(child: Text("No Data Available"))
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 50.h),
                    headerProfileApps(),
                    SizedBox(height: 50.h),
                    akunOptionApps(),
                    SizedBox(height: 50.h),
                    generalOptionApps(),
                  ],
                ),
    ));
  }

  sudahLoginGoogle() {
    _timer?.cancel();
    EasyLoading.dismiss();
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
                Map<String, dynamic> data =
                    snapshot.data!.data() as Map<String, dynamic>;
                return Padding(
                  padding: EdgeInsets.all(12),
                  child: _isloading
                      ? Center()
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 50.h),
                            headerProfileGoogle(data['username'], data['email'],
                                data['profilePhoto']),
                            SizedBox(height: 50.h),
                            akunOptionGoogle(),
                            SizedBox(height: 50.h),
                            generalOptionGoogle(),
                          ],
                        ),
                );
              }
            }));
  }

  headerProfileApps() {
    return Row(
      children: [
        SizedBox(width: 25.w),
        SvgPicture.asset("assets/icon/profile.svg", width: 75.w),
        SizedBox(width: 25.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            SizedBox(height: 20.h),
            Text(email,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }

  headerProfileGoogle(String user, String email, String photo) {
    return Row(
      children: [
        SizedBox(width: 25.w),
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(photo),
        ),
        SizedBox(width: 25.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            SizedBox(height: 20.h),
            Text(email,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w600)),
          ],
        )
      ],
    );
  }

  akunOptionApps() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Akun",
            style:
                GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w500)),
        SizedBox(height: 25.h),
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: ColorValues.primaryBlue,
            shadowColor: Colors.black,
            elevation: 4.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: Icon(Icons.person_pin,
                        color: Colors.black, size: 20.w)),
                Expanded(
                  flex: 5,
                  child: Text("Edit Akun",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                ),
                Expanded(
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black, size: 20.w),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 25.h),
        ElevatedButton(
          onPressed: () {
            logout();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: ColorValues.primaryBlue,
            shadowColor: Colors.black,
            elevation: 4.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: Icon(Icons.logout_rounded,
                        color: Colors.black, size: 20.w)),
                Expanded(
                  flex: 5,
                  child: Text("Logout",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                ),
                Expanded(
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black, size: 20.w),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  akunOptionGoogle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Akun",
            style:
                GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w500)),
        SizedBox(height: 25.h),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => EditProfile()));
            print('result: ' + result);
            setState(() {
              _widget = sudahLoginGoogle();
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: ColorValues.primaryBlue,
            shadowColor: Colors.black,
            elevation: 4.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: Icon(Icons.person_pin,
                        color: Colors.black, size: 20.w)),
                Expanded(
                  flex: 5,
                  child: Text("Edit Akun",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                ),
                Expanded(
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black, size: 20.w),
                )
              ],
            ),
          ),
        ),
        SizedBox(height: 25.h),
        ElevatedButton(
          onPressed: () {
            final provider =
                Provider.of<GoogleProvider>(context, listen: false);
            provider.logout();
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: ColorValues.primaryBlue,
            shadowColor: Colors.black,
            elevation: 4.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                    child: Icon(Icons.logout_rounded,
                        color: Colors.black, size: 20.w)),
                Expanded(
                  flex: 5,
                  child: Text("Logout",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                ),
                Expanded(
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black, size: 20.w),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  generalOptionApps() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("General",
            style:
                GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w500)),
        SizedBox(height: 25.h),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsPrivacyPage()));
            print('result: ' + result);
            await getProfileApps();
            setState(() {
              _widget = sudahLoginApps();
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: ColorValues.primaryBlue,
            shadowColor: Colors.black,
            elevation: 4.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Icon(Icons.privacy_tip_rounded,
                      color: Colors.black, size: 20.w),
                ),
                Expanded(
                  flex: 5,
                  child: Text("Terms & Privacy",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                ),
                Expanded(
                  flex: _isRead == false ? 2 : 1,
                  child: Text(_isRead == false ? "Not Accept" : "Accept",
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          color: _isRead == false ? Colors.red : Colors.green)),
                ),
                Expanded(
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black, size: 20.w),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  generalOptionGoogle() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("General",
            style:
                GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w500)),
        SizedBox(height: 25.h),
        ElevatedButton(
          onPressed: () async {
            final result = await Navigator.push(context,
                MaterialPageRoute(builder: (context) => TermsPrivacyPage()));
            print('result: ' + result);
            await getProfileGoogle();
            setState(() {
              _widget = sudahLoginGoogle();
            });
          },
          style: ElevatedButton.styleFrom(
            primary: Colors.white,
            onPrimary: ColorValues.primaryBlue,
            shadowColor: Colors.black,
            elevation: 4.0,
          ),
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Icon(Icons.privacy_tip_rounded,
                      color: Colors.black, size: 20.w),
                ),
                Expanded(
                  flex: 5,
                  child: Text("Terms & Privacy",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: Colors.black)),
                ),
                Expanded(
                  flex: _isRead == false ? 2 : 1,
                  child: Text(_isRead == false ? "Not Accept" : "Accept",
                      style: GoogleFonts.inter(
                          fontSize: 9,
                          color: _isRead == false ? Colors.red : Colors.green)),
                ),
                Expanded(
                  child: Icon(Icons.arrow_forward_ios_rounded,
                      color: Colors.black, size: 20.w),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    SharedCode.navigatorPushAndRemove(context, LoginPage());
  }
}
