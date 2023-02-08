import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/helper/firebase_service.dart';
import 'package:project_anakkos_app/model/register_model.dart';
import 'package:project_anakkos_app/ui-User/login_user.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_user.dart';
import 'package:project_anakkos_app/widget/custom_text_form.dart';
import 'package:project_anakkos_app/widget/google_signin_button.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({Key? key}) : super(key: key);

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoad = false;

  Future getRegister() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoad = true;
      });
      RegisterModel model = await ApiService().getRegister(
          username: _fullNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
          role: pref.getString("user").toString());
      setState(() {
        _isLoad = false;
      });
    } catch (error) {
      print('no internet ' + error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
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
                          'assets/logo/anakkos_logo1.svg',
                          width: size.width * 0.35,
                        ),
                        SizedBox(
                          height: 48.h,
                        ),
                        Text(
                          'Daftar Akun',
                          style: textTheme.headline5!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(
                          height: 8.h,
                        ),
                        Text(
                          'Masukkan form di bawah untuk mendaftar',
                          style: textTheme.bodyText2,
                        ),
                        SizedBox(
                          height: 24.h,
                        ),
                        CustomTextFormField(
                          label: 'Masukkan nama lengkap',
                          controller: _fullNameController,
                          validator: (value) =>
                              SharedCode().nameValidator(value),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CustomTextFormField(
                          label: 'Masukkan email',
                          controller: _emailController,
                          textInputType: TextInputType.emailAddress,
                          validator: (value) =>
                              SharedCode().emailValidator(value),
                        ),
                        SizedBox(
                          height: 12.h,
                        ),
                        CustomTextFormField(
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
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              await getRegister();
                              await SharedCode.navigatorPush(
                                  context, LoginUser());
                            }
                          },
                          child: Text('Daftar'),
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
                            text: 'Sudah punya akun? ',
                            style: textTheme.bodyText1,
                            children: [
                              TextSpan(
                                text: 'Masuk',
                                style: textTheme.bodyText1!.copyWith(
                                  color: Color(0XFF2FA0DF),
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () => SharedCode.navigatorPush(
                                      context, LoginUser()),
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
