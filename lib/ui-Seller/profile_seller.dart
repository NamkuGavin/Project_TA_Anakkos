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
import 'package:project_anakkos_app/ui-Seller/login_seller.dart';
import 'package:project_anakkos_app/ui-User/bookmark_page.dart';
import 'package:project_anakkos_app/ui-User/Edit%20Profile/edit_profile_google.dart';
import 'package:project_anakkos_app/ui-User/login_user.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/ui-User/terms_privacy_page.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileSeller extends StatefulWidget {
  ProfileSeller({Key? key}) : super(key: key);

  @override
  State<ProfileSeller> createState() => _ProfileSellerState();
}

class _ProfileSellerState extends State<ProfileSeller> {
  bool _isLoad = false;
  String full_name = "";
  String email = "";

  Future getProfileSeller() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoad = true;
      });
      LoginModel result = await ApiService().getLogin(
          email: pref.getString("email_owner").toString(),
          password: pref.getString("pass_owner").toString());
      full_name = result.data.name;
      email = result.data.email;
      setState(() {
        _isLoad = false;
      });
    } catch (error) {
      print('no internet ' + error.toString());
    }
  }

  @override
  void initState() {
    getProfileSeller();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0XFFF9F9F9),
        body: SafeArea(
          child: _isLoad
              ? LoadingAnimation()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(28, 75, 28, 0),
                      child: Column(
                        children: [
                          headerProfileApps(full_name, email),
                          SizedBox(
                            height: 16.h,
                          ),
                          Divider(
                            color: Color(0XFFECEEF2),
                            thickness: 1,
                          ),
                          SizedBox(
                            height: 32.h,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        padding:
                            EdgeInsets.symmetric(horizontal: 28, vertical: 30),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(50),
                            topRight: Radius.circular(50),
                          ),
                        ),
                        child: Column(
                          children: [
                            _button(
                              onPress: () {
                                SharedCode.navigatorPush(
                                    context, EditProfileSeller());
                              },
                              icon: 'PersonalInfo',
                              title: 'Edit Profil',
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _button(
                              onPress: () async {
                                setState(() {
                                  _isLoad = true;
                                });
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await ApiService().logout(
                                    pref.getString('token_owner').toString());
                                await pref.clear();
                                await SharedCode.navigatorPushAndRemove(
                                    context, RolePage());
                              },
                              icon: 'Logout',
                              title: 'Keluar',
                              isLogout: true,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }

  headerProfileApps(String user, String email) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0XFFE7E7E7),
          radius: 50,
          backgroundImage: null,
          child: Text(
            getInitials(user),
            style: GoogleFonts.poppins(
              color: Colors.black,
              fontSize: 22,
            ),
          ),
        ),
        SizedBox(
          height: 24.h,
        ),
        Text(
          user,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
        Text(
          email,
          style: GoogleFonts.poppins(),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _button({
    required void Function() onPress,
    required String icon,
    required String title,
    bool isLogout = false,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPress,
        splashColor: Colors.white,
        borderRadius: BorderRadius.circular(12.5),
        child: Row(
          children: [
            Container(
              height: 45,
              width: 45,
              decoration: BoxDecoration(
                color: Color(0XFFF9F9F9),
                borderRadius: BorderRadius.all(
                  Radius.circular(12.5),
                ),
              ),
              child: Center(
                child: SvgPicture.asset(
                  'assets/icon/$icon.svg',
                  fit: BoxFit.fill,
                  color: isLogout ? Colors.red : Colors.black,
                ),
              ),
            ),
            SizedBox(width: 15),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: isLogout ? Colors.red : Colors.black,
              ),
            ),
            Spacer(),
            Icon(Icons.navigate_next_sharp)
          ],
        ),
      ),
    );
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';
}
