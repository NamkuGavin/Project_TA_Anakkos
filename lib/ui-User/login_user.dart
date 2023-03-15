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
import 'package:project_anakkos_app/widget/google_signIn_provider.dart';
import 'package:project_anakkos_app/widget/google_signin_button.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  final scaffoldKey = GlobalKey<ScaffoldState>();
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
          context, 'Error', 'Isikan form dengan benar', 'error');
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        key: scaffoldKey,
        body: Center(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
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
                              'assets/logo/anakkos_logo3.svg',
                              width: size.width * 0.4,
                            ),
                            SizedBox(
                              height: 30.h,
                            ),
                            Text(
                              'ANAKKOS',
                              style: textTheme.headline5!.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.blue.shade900),
                            ),
                            Divider(
                                color: ColorValues.primaryPurple,
                                thickness: 3,
                                height: 25,
                                endIndent: 18,
                                indent: 18),
                            Text(
                              'MENERAPKAN APLIKASI PEMESANAN KOS BERBASIS DIGITAL MENYEDIAKAN INFORMASI LENGKAP',
                              textAlign: TextAlign.center,
                              style: textTheme.bodyText2!.copyWith(
                                  fontSize: 11,
                                  color: Colors.blue.shade900,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            CustomTextFormField(
                              isEmail: true,
                              label: 'Masukkan email',
                              controller: _emailController,
                              textInputType: TextInputType.emailAddress,
                              validator: (value) =>
                                  SharedCode().emailValidator(value),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                            CustomTextFormField(
                              label: 'Masukkan kata sandi',
                              controller: _passwordController,
                              isPassword: true,
                              validator: (value) =>
                                  SharedCode().passwordValidator(value),
                            ),
                            SizedBox(
                              height: 26.h,
                            ),
                            Container(
                              width: 250.w,
                              padding: EdgeInsets.symmetric(vertical: 7),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.blue.shade800),
                              child: ElevatedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    )),
                                    backgroundColor:
                                        MaterialStateProperty.all(Colors.white),
                                    foregroundColor: MaterialStateProperty.all(
                                        Colors.blue.shade800)),
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    await getLogin();
                                  }
                                },
                                child: Text('MASUK',
                                    style: textTheme.headline6!.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.blue.shade900)),
                              ),
                            ),
                            SizedBox(
                              height: 16.h,
                            ),
                            Text(
                              'Atau',
                              style: textTheme.bodyText2,
                            ),
                            SizedBox(
                              height: 16.h,
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
                                await FirebaseService()
                                    .signInGoogle(context)
                                    .then(
                                      (value) => value
                                          ? SharedCode.navigatorPushAndRemove(
                                              context,
                                              NavigationWidgetBarUser())
                                          : null,
                                    );
                              },
                              child: ButtonSignInGoogle(),
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            RichText(
                              text: TextSpan(
                                text: 'Belum mempunyai akun? ',
                                style: textTheme.bodyText1,
                                children: [
                                  TextSpan(
                                    text: 'Daftar',
                                    style: textTheme.bodyText1!.copyWith(
                                      color: Color(0XFF2FA0DF),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.of(context)
                                          .push(PageTransition(
                                              child: RegisterUser(),
                                              type: PageTransitionType
                                                  .bottomToTopPop,
                                              duration:
                                                  Duration(milliseconds: 500),
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
        ),
      ),
    );
  }
}
