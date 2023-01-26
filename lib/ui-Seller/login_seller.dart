import 'dart:async';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-Seller/register_seller.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_seller.dart';
import 'package:project_anakkos_app/widget/custom_text_field.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../widget/bottomNavigation_user.dart';

class LoginSeller extends StatefulWidget {
  LoginSeller({Key? key}) : super(key: key);

  @override
  State<LoginSeller> createState() => _LoginSellerState();
}

class _LoginSellerState extends State<LoginSeller> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isVisible = true;
  bool submit = false;
  bool _isloading = false;
  Timer? _timer;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _emailController.addListener(() {
      if (_emailController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty) {
        setState(() {
          submit = true;
        });
      } else {
        setState(() {
          submit = false;
        });
      }
    });
    _passwordController.addListener(() {
      if (_passwordController.text.isNotEmpty &&
          _emailController.text.isNotEmpty) {
        setState(() {
          submit = true;
        });
      } else {
        setState(() {
          submit = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      body: _isloading == false
          ? Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 75.h,
                    ),
                    Text("Login",
                        style: GoogleFonts.roboto(
                          fontSize: 35,
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(
                      height: 50.h,
                    ),
                    inputWidget(),
                    loginButton(),
                    SizedBox(
                      height: 50.h,
                    ),
                  ],
                ),
              ),
            )
          : Container(),
    );
  }

  submitData() async {
    SharedCode.navigatorPushAndRemove(context, NavigationWidgetBarSeller());
  }

  inputWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: GoogleFonts.roboto(
            fontSize: 13,
          ),
        ),
        SizedBox(
          height: 7.h,
        ),
        CustomTextField(
          isEnable: true,
          isreadOnly: false,
          controller: _emailController,
          inputType: TextInputType.emailAddress,
          validator: (value) => SharedCode().emailValidator(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Text(
          'Password',
          style: GoogleFonts.roboto(
            fontSize: 13,
          ),
        ),
        SizedBox(
          height: 7.h,
        ),
        CustomTextField(
          inputType: TextInputType.text,
          isEnable: true,
          isreadOnly: false,
          controller: _passwordController,
          isPassword: _isVisible,
          validator: (value) => SharedCode().passwordValidator(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isVisible ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
                size: 17.w,
              ),
              onPressed: () {
                setState(() {
                  _isVisible = !_isVisible;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 50.h,
        ),
      ],
    );
  }

  loginButton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: submit
              ? () {
                  return submitData();
                }
              : null,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text('Login'),
          ),
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.disabled))
                  return ColorValues.primaryBlue.withOpacity(0.5);
                return ColorValues.primaryBlue; // Use the component's default.
              },
            ),
          ),
        ),
        SizedBox(
          height: 30.h,
        ),
        Center(
          child: RichText(
            text: TextSpan(
                text: 'Don\'t have an account?',
                style: GoogleFonts.roboto(color: HexColor("#818181")),
                children: [
                  TextSpan(
                      text: ' SignUp',
                      style: GoogleFonts.roboto(
                          color: ColorValues.primaryBlue,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          SharedCode.navigatorPush(context, RegisterSeller());
                        }),
                ]),
          ),
        ),
      ],
    );
  }
}
