import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui-User/landing_page.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_seller.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_user.dart';
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
    Future.delayed(Duration(seconds: 5), () async {
      final prefs = await SharedPreferences.getInstance();
      if (prefs.getString('token_user') == null &&
          prefs.getString('token_owner') == null &&
          user == null) {
        SharedCode.navigatorReplacement(context, LandingPage());
      } else if (user != null) {
        SharedCode.navigatorReplacement(context, NavigationWidgetBarUser());
      } else if (prefs.getString('token_owner') != null) {
        SharedCode.navigatorReplacement(context, NavigationWidgetBarSeller());
      } else {
        SharedCode.navigatorReplacement(context, NavigationWidgetBarUser());
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF3399FF),
      body: Center(
        child: Lottie.asset("assets/lottie/app_splash.json", width: 175.w),
      ),
    );
  }
}
