import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/common/theme_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:provider/provider.dart';

import 'ui-User/splashscreen.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
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
        return ChangeNotifierProvider(
          create: (context) => GoogleProvider(),
          child: MaterialApp(
            title: 'Anakkos App',
            theme: AppThemeData.getTheme(),
            debugShowCheckedModeBanner: false,
            home: child,
            builder: EasyLoading.init(),
          ),
        );
      },
      child: SplashScreen(),
    );
  }
}
