import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui/terms_privacy_page.dart';

class TermsOfUse extends StatelessWidget {
  TermsOfUse({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          text: "Dengan masuk ke akun, Anda menyetujui\n ",
          style: Theme.of(context).textTheme.bodyText1,
          children: [
            TextSpan(
              text: "Terms & Conditions and Privacy Policy kami!  ",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: ColorValues.primaryBlue,
                  fontSize: 10),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  SharedCode.navigatorPush(context, TermsPrivacyPage());
                },
            ),
          ],
        ),
      ),
    );
  }
}
