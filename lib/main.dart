import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/common/theme_data.dart';
import 'package:project_anakkos_app/ui/splashscreen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return ScreenUtilInit(
      designSize: Size(360, 800),
      minTextAdapt: true,
      splitScreenMode: false,
      builder: (_, child) {
        return MaterialApp(
          title: 'Anakkos App',
          theme: AppThemeData.getTheme(),
          debugShowCheckedModeBanner: false,
          home: child,
        );
      },
      child: SplashScreen(),
    );
  }
}
