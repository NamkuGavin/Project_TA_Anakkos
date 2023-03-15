import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class CustomTextFormField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType textInputType;
  final String? Function(String?)? validator;
  final bool isPassword;
  final bool isEmail;
  final bool isUser;
  final bool isPhone;
  final double borderRadius;

  const CustomTextFormField(
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
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
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
      style: textTheme.bodyText1!.copyWith(
        color: Colors.black,
      ),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 1,
            color: Color(0XFFE7E7E7),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 1,
            color: Color(0XFFE7E7E7),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          borderSide: BorderSide(
            width: 2,
            color: Color(0XFF2FA0DF),
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
        labelStyle: textTheme.bodyText1!.copyWith(color: Color(0XFF9B9B9B)),
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
                        color: Color(0XFF9B9B9B),
                      )
                    : Icon(
                        Icons.visibility,
                        color: Color(0XFF9B9B9B),
                      ),
              )
            : widget.isEmail
                ? Icon(
                    Icons.email,
                    color: Color(0XFF9B9B9B),
                  )
                : widget.isUser
                    ? Icon(
                        Icons.account_box,
                        color: Color(0XFF9B9B9B),
                      )
                    : widget.isPhone
                        ? Icon(
                            Icons.phone_android,
                            color: Color(0XFF9B9B9B),
                          )
                        : null,
      ),
    );
  }
}
