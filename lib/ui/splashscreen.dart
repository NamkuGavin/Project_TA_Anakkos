import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui/landing_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    Future.delayed(Duration(seconds: 3), () {
      SharedCode.navigatorReplacement(context, LandingPage());
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SvgPicture.asset("assets/logo/anakkos_logo1.svg", width: 175.w),
      ),
    );
  }
}
