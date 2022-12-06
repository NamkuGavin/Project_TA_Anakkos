import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui/landing_page.dart';
import 'package:project_anakkos_app/widget/bottomNavigation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final user = FirebaseAuth.instance.currentUser;
  @override
  void initState() {
    Future.delayed(Duration(seconds: 3), () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('access_token') == null && user == null) {
        SharedCode.navigatorReplacement(context, LandingPage());
      } else if (user != null) {
        SharedCode.navigatorReplacement(context, NavigationWidgetBar());
      } else {
        SharedCode.navigatorReplacement(context, NavigationWidgetBar());
      }
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
