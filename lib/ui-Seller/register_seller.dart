import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/helper/firebase_service.dart';
import 'package:project_anakkos_app/model/register_model.dart';
import 'package:project_anakkos_app/ui-Seller/login_seller.dart';
import 'package:project_anakkos_app/ui-User/login_user.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_user.dart';
import 'package:project_anakkos_app/widget/custom_text_form.dart';
import 'package:project_anakkos_app/widget/custom_text_form_login.dart';
import 'package:project_anakkos_app/widget/google_signin_button.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterSeller extends StatefulWidget {
  const RegisterSeller({Key? key}) : super(key: key);

  @override
  State<RegisterSeller> createState() => _RegisterSellerState();
}

class _RegisterSellerState extends State<RegisterSeller> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _NoHPController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoad = false;

  Future getRegister() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoad = true;
      });
      RegisterModel model = await ApiService().getRegister(
          email: _emailController.text,
          password: _passwordController.text,
          role: pref.getString("owner").toString(),
          first_name: _firstNameController.text,
          last_name: _lastNameController.text,
          phone: _NoHPController.text);
      setState(() {
        _isLoad = false;
      });
      await SharedCode.navigatorPush(context, LoginSeller());
    } catch (error) {
      print('no internet ' + error.toString());
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
          0.1,
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
                          'Daftar Akun',
                          style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 23),
                        ),
                        Text(
                          'Masukkan form di bawah untuk mendaftar',
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 13),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: CustomTextFormFieldLogin(
                                isUser: true,
                                label: 'Masukkan nama depan',
                                controller: _firstNameController,
                                validator: (value) =>
                                    SharedCode().nameValidator(value),
                              ),
                            ),
                            SizedBox(
                              width: 12.w,
                            ),
                            Expanded(
                              child: CustomTextFormFieldLogin(
                                isUser: true,
                                label: 'Masukkan nama belakang',
                                controller: _lastNameController,
                                validator: (value) =>
                                    SharedCode().nameValidator(value),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CustomTextFormFieldLogin(
                          isEmail: true,
                          label: 'Masukkan email',
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) =>
                              SharedCode().emailValidator(value),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CustomTextFormFieldLogin(
                          isPhone: true,
                          label: 'Masukkan No Handphone',
                          controller: _NoHPController,
                          textInputType: TextInputType.number,
                          validator: (value) =>
                              SharedCode().emptyValidator(value),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CustomTextFormFieldLogin(
                          label: 'Masukkan kata sandi',
                          controller: _passwordController,
                          isPassword: true,
                          validator: (value) =>
                              SharedCode().passwordValidator(value),
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        ElevatedButton(
                          style: ButtonStyle(
                              foregroundColor:
                                  MaterialStateProperty.all(Colors.black),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await getRegister();
                            }
                          },
                          child: Text('Daftar'),
                        ),
                        SizedBox(
                          height: 30.h,
                        ),
                        RichText(
                          text: TextSpan(
                            text: 'Sudah punya akun? ',
                            style: GoogleFonts.poppins(color: Colors.white),
                            children: [
                              TextSpan(
                                text: 'Masuk',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => Navigator.of(context).pop(
                                      PageTransition(
                                          child: LoginSeller(),
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
                        SizedBox(
                          height: 20.h,
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
