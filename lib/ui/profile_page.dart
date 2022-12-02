import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui/login_page.dart';
import 'package:project_anakkos_app/ui/role_page.dart';
import 'package:project_anakkos_app/ui/terms_privacy_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _widget = Container();
  String username = "";
  String email = "";

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  _checkLogin() async {
    final pref = await SharedPreferences.getInstance();
    username = pref.getString("username").toString();
    email = pref.getString("email").toString();
    if (pref.getString("username") == null) {
      setState(() {
        _widget = belumLogin();
      });
    } else {
      setState(() {
        _widget = sudahLogin();
      });
    }
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
        body: Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 50.h),
          headerProfile(),
          SizedBox(height: 50.h),
          akunOption(),
          SizedBox(height: 50.h),
          // generalOption(),
        ],
      ),
    ));
  }

  headerProfile() {
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

  akunOption() {
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
                Icon(Icons.bookmark, color: Colors.black, size: 20.w),
                SizedBox(width: 10.w),
                Text("Riwayat",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black)),
                SizedBox(width: 60.w),
                Text("sedang berjalan & riwayat",
                    style: GoogleFonts.inter(fontSize: 9, color: Colors.grey)),
                SizedBox(width: 5.w),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.black, size: 20.w)
              ],
            ),
          ),
        ),
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
                Icon(Icons.person_pin, color: Colors.black, size: 20.w),
                SizedBox(width: 10.w),
                Text("Edit Akun",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black)),
                SizedBox(width: 165.w),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.black, size: 20.w)
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
                Icon(Icons.logout_rounded, color: Colors.black, size: 20.w),
                SizedBox(width: 10.w),
                Text("Logout",
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.black)),
                SizedBox(width: 180.w),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: Colors.black, size: 20.w)
              ],
            ),
          ),
        ),
      ],
    );
  }

  // generalOption() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.start,
  //     crossAxisAlignment: CrossAxisAlignment.start,
  //     children: [
  //       Text("General",
  //           style:
  //               GoogleFonts.roboto(fontSize: 15, fontWeight: FontWeight.w500)),
  //       SizedBox(height: 25.h),
  //       ElevatedButton(
  //         onPressed: () {
  //           SharedCode.navigatorPush(context, TermsPrivacyPage());
  //         },
  //         style: ElevatedButton.styleFrom(
  //           primary: Colors.white,
  //           onPrimary: ColorValues.primaryBlue,
  //           shadowColor: Colors.black,
  //           elevation: 4.0,
  //         ),
  //         child: Padding(
  //           padding: EdgeInsets.all(12),
  //           child: Row(
  //             children: [
  //               Icon(Icons.privacy_tip_rounded,
  //                   color: Colors.black, size: 20.w),
  //               SizedBox(width: 10.w),
  //               Text("Terms & Privacy",
  //                   style: GoogleFonts.inter(
  //                       fontWeight: FontWeight.w600,
  //                       fontSize: 12,
  //                       color: Colors.black)),
  //               SizedBox(width: 75.w),
  //               Text("Not Accept",
  //                   style: GoogleFonts.inter(fontSize: 9, color: Colors.red)),
  //               SizedBox(width: 5.w),
  //               Icon(Icons.arrow_forward_ios_rounded,
  //                   color: Colors.black, size: 20.w)
  //             ],
  //           ),
  //         ),
  //       ),
  //     ],
  //   );
  // }

  logout() async {
    final preferences = await SharedPreferences.getInstance();
    await preferences.clear();
    SharedCode.navigatorPushAndRemove(context, LoginPage());
  }
}
