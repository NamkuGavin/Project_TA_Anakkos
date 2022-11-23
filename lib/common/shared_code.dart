import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final Color blackColor = HexColor("#3d3d3d");
final Color greyColor = HexColor("#f2f2f2");

class SharedCode {
  String? emptyValidator(value) {
    return value.toString().trim().isEmpty
        ? 'username tidak boleh kosong'
        : null;
  }

  String? passwordValidator(value) {
    return value.toString().length < 6
        ? 'password tidak boleh kurang dari 6 karakter'
        : null;
  }

  String? confirmPassValidator(value, String check) {
    return value.toString() != check ? 'password tidak match' : null;
  }

  String? emailValidator(value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return !emailValid ? 'Email tidak valid' : null;
  }

  bool? emailCheck(value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return !emailValid ? false : true;
  }

  String? phoneValidator(value) {
    bool phoneValid =
        RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
            .hasMatch(value);
    return !phoneValid ? 'Nomor telepon tidak valid' : null;
  }

  static navigatorPush(BuildContext context, Widget widget) {
    Navigator.push(context, MaterialPageRoute(builder: (c) => widget));
  }

  static navigatorReplacement(BuildContext context, Widget widget) {
    Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (c) => widget));
  }

  static navigatorPushAndRemove(BuildContext context, Widget widget) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (c) => widget), (route) => false);
  }

  static navigatorPop(BuildContext context) {
    Navigator.pop(context);
  }
}
