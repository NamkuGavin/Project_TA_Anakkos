import 'dart:async';
import 'dart:io';

import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/helper/firebase_service.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-User/register_user.dart';
import 'package:project_anakkos_app/widget/custom_text_field.dart';
import 'package:project_anakkos_app/widget/custom_text_form.dart';
import 'package:project_anakkos_app/widget/custom_text_form_login.dart';
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:project_anakkos_app/widget/google_signin_button.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

import '../widget/bottomNavigation_user.dart';

class LoginUser extends StatefulWidget {
  LoginUser({Key? key}) : super(key: key);

  @override
  State<LoginUser> createState() => _LoginUserState();
}

class _LoginUserState extends State<LoginUser> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoad = false;

  Future getLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoad = true;
      });
      LoginModel model = await ApiService().getLogin(
          email: _emailController.text, password: _passwordController.text);
      pref.setString('pass_user', _passwordController.text);
      pref.setString('email_user', _emailController.text);
      pref.setString('token_user', model.token);
      pref.setInt('id_user', model.data.id);
      setState(() {
        _isLoad = false;
      });
      await SharedCode.navigatorReplacement(context, NavigationWidgetBarUser());
    } on HttpException {
      setState(() {
        _isLoad = false;
      });
      return SharedCode.showAlertDialog(
          context, 'Error', 'HttpException', 'error');
    } on SocketException {
      setState(() {
        _isLoad = false;
      });
      return SharedCode.showAlertDialog(
          context, 'Login Failed', 'Tidak ada koneksi internet', 'error');
    } on TimeoutException {
      setState(() {
        _isLoad = false;
      });
      return SharedCode.showAlertDialog(context, 'Timeout',
          'Sepertinya ada kesalahan koneksi internet', 'warning');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;
    return ScaffoldGradientBackground(
      gradient: LinearGradient(
        begin: Alignment.bottomCenter,
        end: Alignment.topCenter,
        stops: [
          0.2,
          1.0,
        ],
        colors: [
          Color(0xFF58A9FF),
          Color(0xFF6060FF),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 16),
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SvgPicture.asset(
                          'assets/logo/anakkos_logo2.svg',
                          width: size.width * 0.42,
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        Text(
                          'Selamat Datang',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 23),
                        ),
                        Text(
                          'Masukkan email dan kata sandi untuk masuk',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 13),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        CustomTextFormFieldLogin(
                          isEmail: true,
                          borderRadius: 8,
                          label: 'Masukkan email',
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) =>
                              SharedCode().emailValidator(value),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        CustomTextFormFieldLogin(
                          borderRadius: 8,
                          label: 'Masukkan kata sandi',
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value) =>
                              SharedCode().passwordValidator(value),
                        ),
                        SizedBox(
                          height: 26.h,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await getLogin();
                            }
                          },
                          child: Text('Masuk',
                              style: GoogleFonts.poppins(fontSize: 13)),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        Text(
                          'Atau',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        GestureDetector(
                          onTap: () async {
                            // final provider =
                            //     Provider.of<GoogleProvider>(context,
                            //         listen: false);
                            // setState(() {
                            //   _isloading = true;
                            // });
                            // await provider.googleLogin();
                            await FirebaseService().signInGoogle(context).then(
                                  (value) => value
                                      ? SharedCode.navigatorPushAndRemove(
                                          context, NavigationWidgetBarUser())
                                      : null,
                                );
                          },
                          child: ButtonSignInGoogle(),
                        ),
                        SizedBox(
                          height: 40.h,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Belum punya akun? ',
                            style: GoogleFonts.poppins(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'Daftar',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context).push(
                                      PageTransition(
                                          child: RegisterUser(),
                                          type:
                                              PageTransitionType.bottomToTopPop,
                                          duration: Duration(milliseconds: 500),
                                          reverseDuration:
                                              Duration(milliseconds: 500),
                                          childCurrent: widget)),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            _isLoad ? LoadingAnimation() : Container(),
          ],
        ),
      ),
    );
  }
}
