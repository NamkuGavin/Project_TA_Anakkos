import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui-Seller/login_seller.dart';
import 'package:project_anakkos_app/ui-User/login_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RolePage extends StatefulWidget {
  const RolePage({Key? key}) : super(key: key);

  @override
  State<RolePage> createState() => _RolePageState();
}

class _RolePageState extends State<RolePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 25.h),
            Text("Login ke Anakkos",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.bold, fontSize: 30)),
            SizedBox(height: 50.h),
            Text("Saya ingin login sebagai",
                style: GoogleFonts.inter(
                    fontWeight: FontWeight.w500, fontSize: 20)),
            SizedBox(height: 50.h),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString("user", "user");
                await SharedCode.navigatorPush(context, LoginUser());
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: ColorValues.primaryBlue,
                shadowColor: Colors.black,
                elevation: 4.0,
              ),
              child: Row(
                children: [
                  Lottie.asset("assets/lottie/kos_search.json", width: 150.w),
                  SizedBox(width: 30.w),
                  Text("Pencari Kos",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black))
                ],
              ),
            ),
            SizedBox(height: 25.h),
            ElevatedButton(
              onPressed: () async {
                SharedPreferences pref = await SharedPreferences.getInstance();
                await pref.setString("owner", "owner");
                await SharedCode.navigatorPush(context, LoginSeller());
              },
              style: ElevatedButton.styleFrom(
                primary: Colors.white,
                onPrimary: ColorValues.primaryBlue,
                shadowColor: Colors.black,
                elevation: 4.0,
              ),
              child: Row(
                children: [
                  Lottie.asset("assets/lottie/new_kos.json", width: 150.w),
                  SizedBox(width: 30.w),
                  Text("Pemilik Kos",
                      style: GoogleFonts.inter(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.black))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            SharedCode.navigatorPop(context);
          },
          icon: Icon(Icons.close, color: Colors.black)),
    );
  }
}
