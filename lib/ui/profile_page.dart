import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Widget _widget = Container();

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  _checkLogin() async {
    final pref = await SharedPreferences.getInstance();
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SvgPicture.asset("assets/logo/blm_login.svg", width: 175.w),
            SizedBox(height: 30.h),
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Text("Login terlebih dahulu untuk mengakses fitur ini",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
            ),
            SizedBox(height: 15.h),
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
                    onPressed: () {},
                    child: Text('Login',
                        style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
              ),
            )
          ],
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
}
