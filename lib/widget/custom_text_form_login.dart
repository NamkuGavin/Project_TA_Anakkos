import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomTextFormFieldLogin extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isEmail;
  final bool isUser;
  final bool isPhone;
  final double borderRadius;

  const CustomTextFormFieldLogin(
      {Key? key,
      required this.label,
      required this.controller,
      this.textInputType = TextInputType.text,
      this.validator,
      this.isPassword = false,
      this.isEmail = false,
      this.isUser = false,
      this.isPhone = false,
      this.borderRadius = 8})
      : super(key: key);

  @override
  State<CustomTextFormFieldLogin> createState() =>
      _CustomTextFormFieldLoginState();
}

class _CustomTextFormFieldLoginState extends State<CustomTextFormFieldLogin> {
  bool _isPasswordNotVisible = true;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TextFormField(
      controller: widget.controller,
      keyboardType: widget.textInputType,
      validator: widget.validator,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      obscureText: widget.isPassword ? _isPasswordNotVisible : false,
      autocorrect: !widget.isPassword,
      enableSuggestions: !widget.isPassword,
      style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.never,
        fillColor: Color(0xFFA1CCFF),
        filled: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 1,
            color: Colors.white,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 2,
            color: Colors.white,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 2,
            color: Colors.redAccent,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 2,
            color: Colors.redAccent,
          ),
        ),
        labelText: widget.label,
        labelStyle: GoogleFonts.poppins(color: Colors.white),
        contentPadding: EdgeInsets.symmetric(vertical: 19, horizontal: 16),
        prefixIcon: widget.isPassword
            ? IconButton(
                splashRadius: 30,
                onPressed: () {
                  setState(() {
                    _isPasswordNotVisible = !_isPasswordNotVisible;
                  });
                },
                icon: _isPasswordNotVisible
                    ? Icon(
                        Icons.visibility_off,
                        color: Colors.black38,
                      )
                    : Icon(
                        Icons.visibility,
                        color: Colors.black38,
                      ),
              )
            : widget.isEmail
                ? Icon(
                    Icons.email,
                    color: Colors.black38,
                  )
                : widget.isUser
                    ? Icon(
                        Icons.account_box,
                        color: Colors.black38,
                      )
                    : widget.isPhone
                        ? Icon(
                            Icons.phone_android,
                            color: Colors.black38,
                          )
                        : null,
      ),
    );
  }
}
