import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/common/theme_data.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_user.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorValues.primaryBlue,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Anda sedang mencari kost?",
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w500)),
              SizedBox(height: 75.h),
              SvgPicture.asset("assets/logo/anakkos_logo2.svg", width: 200.w),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.",
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center),
              ),
              SizedBox(height: 50.h),
              Padding(
                padding: EdgeInsets.only(left: 200.w, right: 20.w),
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                          shadowColor: Colors.black,
                          elevation: 4.0,
                          textStyle: GoogleFonts.roboto(),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          SharedCode.navigatorReplacement(
                              context, NavigationWidgetBarUser());
                        },
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text('Selanjutnya',
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold)),
                            ),
                            Expanded(
                              child: Icon(
                                Icons.arrow_right_alt_rounded,
                                size: 30,
                              ),
                            )
                          ],
                        ))),
              )
            ],
          ),
        ),
      ),
    );
  }
}
