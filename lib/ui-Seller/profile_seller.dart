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
import 'package:project_anakkos_app/ui-Seller/edit_profileSeller.dart';
import 'package:project_anakkos_app/ui-User/bookmark_page.dart';
import 'package:project_anakkos_app/ui-User/edit_profile.dart';
import 'package:project_anakkos_app/ui-User/login_user.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/ui-User/terms_privacy_page.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSeller extends StatefulWidget {
  ProfileSeller({Key? key}) : super(key: key);

  @override
  State<ProfileSeller> createState() => _ProfileSellerState();
}

class _ProfileSellerState extends State<ProfileSeller> {
  String username = "UserProfile";
  String email = "Userprofile@gmail.com";
  String noHp = "+62-800-0000-0000";
  bool _isloading = false;

  @override
  Widget build(BuildContext context) {
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
                  ],
                ),
    ));
  }

  headerProfileApps() {
    return Row(
      children: [
        SizedBox(width: 25.w),
        SvgPicture.asset("assets/icon/profile.svg", width: 100.w),
        SizedBox(width: 25.w),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(username,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            SizedBox(height: 7.h),
            Text(noHp,
                style: GoogleFonts.roboto(
                    fontSize: 15, fontWeight: FontWeight.w600)),
            SizedBox(height: 7.h),
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
          onPressed: () {
            SharedCode.navigatorPush(context, EditProfileSeller());
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: ColorValues.primaryBlue,
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
            backgroundColor: Colors.white,
            foregroundColor: ColorValues.primaryBlue,
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

  logout() {
    SharedCode.navigatorPushAndRemove(context, RolePage());
  }
}
