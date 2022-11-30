import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui/login_page.dart';
import 'package:project_anakkos_app/widget/bottomNavigation.dart';
import 'package:project_anakkos_app/widget/custom_text_field.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPassController = TextEditingController();
  bool _isVisible1 = true;
  bool _isVisible2 = true;
  bool submit = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _usernameController.addListener(() {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _confirmPassController.text.isNotEmpty &&
          _confirmPassController.text == _passwordController.text &&
          _passwordController.text.length >= 6 &&
          SharedCode().emailCheck(_emailController.text) == true) {
        setState(() {
          submit = true;
        });
      } else {
        setState(() {
          submit = false;
        });
      }
    });
    _emailController.addListener(() {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _confirmPassController.text.isNotEmpty &&
          _confirmPassController.text == _passwordController.text &&
          _passwordController.text.length >= 6 &&
          SharedCode().emailCheck(_emailController.text) == true) {
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
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _confirmPassController.text.isNotEmpty &&
          _confirmPassController.text == _passwordController.text &&
          _passwordController.text.length >= 6 &&
          SharedCode().emailCheck(_emailController.text) == true) {
        setState(() {
          submit = true;
        });
      } else {
        setState(() {
          submit = false;
        });
      }
    });
    _confirmPassController.addListener(() {
      if (_usernameController.text.isNotEmpty &&
          _passwordController.text.isNotEmpty &&
          _emailController.text.isNotEmpty &&
          _confirmPassController.text.isNotEmpty &&
          _confirmPassController.text == _passwordController.text &&
          _passwordController.text.length >= 6 &&
          SharedCode().emailCheck(_emailController.text) == true) {
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
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                height: 75.h,
              ),
              Text("Sign Up",
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
      ),
    );
  }

  submitData() async {
    final pref = await SharedPreferences.getInstance();
    pref.setString("confirmpassword", _confirmPassController.text);
    pref.setString("username", _usernameController.text);
    pref.setString("email", _emailController.text);
    pref.setString("password", _passwordController.text);
    SharedCode.navigatorReplacement(context, LoginPage());
  }

  inputWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Username',
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
          controller: _usernameController,
          inputType: TextInputType.name,
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
          isPassword: _isVisible1,
          validator: (value) => SharedCode().passwordValidator(value),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isVisible1 ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
                size: 17.w,
              ),
              onPressed: () {
                setState(() {
                  _isVisible1 = !_isVisible1;
                });
              },
            ),
          ),
        ),
        SizedBox(
          height: 25.h,
        ),
        Text(
          'Confirm Password',
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
          controller: _confirmPassController,
          isPassword: _isVisible2,
          validator: (value) => SharedCode()
              .confirmPassValidator(value, _passwordController.text),
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isVisible2 ? Icons.visibility_off : Icons.visibility,
                color: Colors.black,
                size: 17.w,
              ),
              onPressed: () {
                setState(() {
                  _isVisible2 = !_isVisible2;
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
            child: Text('Sign Up'),
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
        Row(
          children: [
            Expanded(
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 25),
              child: Text('Or'),
            ),
            Expanded(
              child: Divider(
                color: Colors.black,
                thickness: 1,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 30.h,
        ),
        ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(HexColor("#F8F8F8")),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          onPressed: () {},
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SvgPicture.asset("assets/logo/google_logo.svg"),
                SizedBox(
                  width: 10.w,
                ),
                Text('Login with Google',
                    style: GoogleFonts.roboto(
                        color: Colors.black, fontWeight: FontWeight.w500))
              ],
            ),
          ),
        ),
        SizedBox(
          height: 40.h,
        ),
        Center(
          child: RichText(
            text: TextSpan(
                text: 'Already have an account?',
                style: GoogleFonts.roboto(color: HexColor("#818181")),
                children: [
                  TextSpan(
                      text: ' SignIn',
                      style: GoogleFonts.roboto(
                          color: ColorValues.primaryBlue,
                          fontWeight: FontWeight.w600),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          SharedCode.navigatorReplacement(context, LoginPage());
                        }),
                ]),
          ),
        ),
      ],
    );
  }
}
