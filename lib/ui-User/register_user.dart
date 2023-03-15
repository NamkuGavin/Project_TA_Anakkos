import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pw_validator/flutter_pw_validator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
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
          role: pref.getString("user").toString(),
          first_name: _firstNameController.text,
          last_name: _lastNameController.text,
          phone: _NoHPController.text);
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

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.blue.shade900,
        body: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.symmetric(vertical: 30),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: Stack(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 30),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // SvgPicture.asset(
                            //   'assets/logo/anakkos_logo3.svg',
                            //   width: size.width * 0.35,
                            // ),
                            // SizedBox(
                            //   height: 48.h,
                            // ),
                            Text(
                              'Daftar',
                              style: textTheme.headline5!.copyWith(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(
                              'Buat akun untuk melanjutkan',
                              style: textTheme.bodyText2!.copyWith(
                                  color: Colors.blue.shade800,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(
                              height: 24.h,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: CustomTextFormField(
                                    label: 'Nama depan',
                                    controller: _firstNameController,
                                    validator: (value) =>
                                        SharedCode().nameValidator(value),
                                  ),
                                ),
                                SizedBox(
                                  width: 12.w,
                                ),
                                Expanded(
                                  child: CustomTextFormField(
                                    label: 'Nama belakang',
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
                            CustomTextFormField(
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
                            CustomTextFormField(
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
                            CustomTextFormField(
                              label: 'Masukkan kata sandi',
                              controller: _passwordController,
                              isPassword: true,
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            FlutterPwValidator(
                                controller: _passwordController,
                                minLength: 6,
                                uppercaseCharCount: 1,
                                numericCharCount: 2,
                                width: 310.w,
                                height: 100.h,
                                onSuccess: () {},
                                onFail: () {}),
                            SizedBox(
                              height: 24.h,
                            ),
                            Center(
                              child: Container(
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
                                          MaterialStateProperty.all(
                                              Colors.white),
                                      foregroundColor:
                                          MaterialStateProperty.all(
                                              Colors.blue.shade800)),
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      await getRegister();
                                      await SharedCode.navigatorPush(
                                          context, LoginUser());
                                    }
                                  },
                                  child: Text('DAFTAR',
                                      style: textTheme.headline6!.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.blue.shade900)),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Center(
                              child: Text(
                                'Atau',
                                style: textTheme.bodyText2,
                              ),
                            ),
                            SizedBox(
                              height: 12.h,
                            ),
                            Center(
                              child: GestureDetector(
                                onTap: () async {
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
                            ),
                            SizedBox(
                              height: 20.h,
                            ),
                            Center(
                              child: RichText(
                                text: TextSpan(
                                  text: 'Sudah mempunyai akun? ',
                                  style: textTheme.bodyText1!
                                      .copyWith(fontWeight: FontWeight.w600),
                                  children: [
                                    TextSpan(
                                      text: 'Masuk',
                                      style: textTheme.bodyText1!.copyWith(
                                        color: Color(0XFF2FA0DF),
                                        fontWeight: FontWeight.w500,
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.of(context)
                                            .pop(PageTransition(
                                                child: LoginUser(),
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
