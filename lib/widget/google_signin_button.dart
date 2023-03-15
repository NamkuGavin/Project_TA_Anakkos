import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/helper/firebase_service.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_user.dart';
import 'package:provider/provider.dart';

class ButtonSignInGoogle extends StatelessWidget {
  const ButtonSignInGoogle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      width: 250.w,
      padding: EdgeInsets.symmetric(vertical: 7),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20), color: Colors.blue.shade800),
      child: ElevatedButton(
        style: ButtonStyle(
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50),
            )),
            backgroundColor: MaterialStateProperty.all(Colors.white),
            foregroundColor: MaterialStateProperty.all(Colors.blue.shade800)),
        onPressed: () async {
          await FirebaseService().signInGoogle(context).then(
                (value) => value
                    ? SharedCode.navigatorPushAndRemove(
                        context, NavigationWidgetBarUser())
                    : null,
              );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/logo/google.png', scale: 3),
              SizedBox(
                width: 10.w,
              ),
              Text(
                'Masuk dengan Google',
                style: textTheme.bodyText1!.copyWith(
                  fontSize: 13
                ),
              ),
            ],
          ),
        ),
      ),
    );
    //   Container(
    //   width: double.infinity,
    //   height: 48.h,
    //   padding: EdgeInsets.symmetric(vertical: 12),
    //   decoration: BoxDecoration(
    //     border: Border.all(
    //       color: Colors.black,
    //     ),
    //     borderRadius: BorderRadius.circular(8),
    //   ),
    //   child: Row(
    //     mainAxisAlignment: MainAxisAlignment.center,
    //     crossAxisAlignment: CrossAxisAlignment.center,
    //     children: [
    //       Image.asset('assets/logo/google.png'),
    //       SizedBox(
    //         width: 8.w,
    //       ),
    //       Text(
    //         'Masuk dengan Google',
    //         style: textTheme.bodyText1!.copyWith(
    //           color: Colors.black,
    //           fontWeight: FontWeight.w500,
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
