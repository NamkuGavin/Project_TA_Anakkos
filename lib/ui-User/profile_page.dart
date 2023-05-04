import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/model/get_current_trans_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-User/Edit%20Profile/edit_profile_apps.dart';
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

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final user = FirebaseAuth.instance.currentUser;
  Widget _widget = Container();
  String username = "";
  String email = "";
  String photo = "";

  @override
  void initState() {
    super.initState();
    _checkLogin();
  }

  _checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("token_user") == null && user == null) {
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
      await getProfileApps();
    }
  }

  getProfileApps() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      setState(() {
        _widget = LoadingAnimation();
      });
      LoginModel result = await ApiService().getLogin(
          email: pref.getString("email_user").toString(),
          password: pref.getString("pass_user").toString());
      // CurrentTransaksiModel res = await ApiService().getCurrentTrans(idKost: result.data.id);
      username = result.data.name;
      email = result.data.email;
      photo = result.data.pfp;
      setState(() {
        _widget = sudahLoginApps();
      });
    } catch (error) {
      print('no internet ' + error.toString());
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
              Lottie.asset("assets/lottie/login_first.json"),
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
    return Scaffold(
        backgroundColor: Color(0XFFF9F9F9),
        body: SafeArea(
          child: username.isEmpty || email.isEmpty
              ? Center(child: Text("No Data Available"))
              : SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(28, 75, 28, 0),
                        child: Column(
                          children: [
                            headerProfileApps(username, email, photo),
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
                          padding: EdgeInsets.symmetric(
                              horizontal: 28, vertical: 30),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Column(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     Text(
                              //       "Your current kos",
                              //       style: GoogleFonts.poppins(
                              //         color: Colors.black,
                              //         fontWeight: FontWeight.w600,
                              //       ),
                              //     ),
                              //     Padding(
                              //       padding:
                              //           const EdgeInsets.symmetric(vertical: 10),
                              //       child: IntrinsicHeight(
                              //         child: Row(
                              //           crossAxisAlignment:
                              //               CrossAxisAlignment.stretch,
                              //           mainAxisAlignment:
                              //               MainAxisAlignment.start,
                              //           children: [
                              //             ClipRRect(
                              //               borderRadius: BorderRadius.all(
                              //                   Radius.circular(13)),
                              //               child: Container(
                              //                   height: 100.h,
                              //                   width: 110.w,
                              //                   child: SvgPicture.asset(
                              //                       "assets/images/boardingone.svg",
                              //                       fit: BoxFit.fill)),
                              //             ),
                              //             Expanded(
                              //               child: Padding(
                              //                 padding: EdgeInsets.all(8.0),
                              //                 child: Column(
                              //                   mainAxisAlignment:
                              //                       MainAxisAlignment.start,
                              //                   crossAxisAlignment:
                              //                       CrossAxisAlignment.start,
                              //                   children: [
                              //                     SizedBox(height: 20.h),
                              //                     Text("Kost Godaan Dunia",
                              //                         style: GoogleFonts.inter(
                              //                             fontWeight:
                              //                                 FontWeight.bold,
                              //                             fontSize: 15)),
                              //                     Text(
                              //                         "Stay duration: 27 Aug - 27 Sep",
                              //                         style: GoogleFonts.inter(
                              //                             fontSize: 12)),
                              //                   ],
                              //                 ),
                              //               ),
                              //             )
                              //           ],
                              //         ),
                              //       ),
                              //     ),
                              //   ],
                              // ),
                              // SizedBox(
                              //   height: 20.h,
                              // ),
                              Text(
                                "Setting",
                                style: GoogleFonts.poppins(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(
                                height: 16.h,
                              ),
                              _button(
                                onPress: () async {
                                  final result = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfileApps()));
                                  print('result: ' + result);
                                  await getProfileApps();
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
                                    _widget = LoadingAnimation();
                                  });
                                  SharedPreferences pref =
                                      await SharedPreferences.getInstance();
                                  await ApiService().logout(
                                      pref.getString('token_user').toString());
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
                ),
        ));
  }

  sudahLoginGoogle() {
    final _document =
        FirebaseFirestore.instance.collection('users').doc(user!.uid);
    return Scaffold(
        backgroundColor: Color(0XFFF9F9F9),
        body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            stream: _document.snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Lottie.asset(
                  'assets/lottie/loading.json',
                  width: 150.w,
                ));
              } else if (snapshot.hasError) {
                print("ERROR: " + snapshot.hasError.toString());
                return Center(child: Text("Something Wrong"));
              } else {
                var data = snapshot.data!;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(28, 75, 28, 0),
                      child: Column(
                        children: [
                          headerProfileGoogle(data['full_name'], data['email'],
                              data['photo_profile']),
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
                                    context, BookmarkPage());
                              },
                              icon: 'Bookmark',
                              title: 'Bookmark',
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            _button(
                              onPress: () {
                                SharedCode.navigatorPush(
                                    context, EditProfileGoogle());
                              },
                              icon: 'PersonalInfo',
                              title: 'Edit Profil',
                            ),
                            SizedBox(
                              height: 16,
                            ),
                            _button(
                              onPress: () async {
                                SharedPreferences pref =
                                    await SharedPreferences.getInstance();
                                await FirebaseAuth.instance.signOut();
                                await ApiService().logout(pref
                                    .getString('token_user_google')
                                    .toString());
                                await pref.clear();
                                await GoogleSignIn().signOut();
                                if (!mounted) return;
                                SharedCode.navigatorPushAndRemove(
                                    context, LoginUser());
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
                );
              }
            }));
  }

  headerProfileGoogle(String user, String email, String photo) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0XFFE7E7E7),
          radius: 50,
          backgroundImage: photo != '' ? NetworkImage(photo) : null,
          child: photo != ''
              ? null
              : Text(
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

  headerProfileApps(String user, String email, String photo) {
    return Column(
      children: [
        CircleAvatar(
          backgroundColor: Color(0XFFE7E7E7),
          radius: 50,
          backgroundImage: photo != '' ? NetworkImage(photo) : null,
          // backgroundImage: null,
          child: photo != ''
              ? null
              : Text(
                  getInitials(user),
                  style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
          // child: Text(
          //   getInitials(user),
          //   style: GoogleFonts.poppins(
          //     color: Colors.black,
          //     fontSize: 22,
          //   ),
          // ),
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
