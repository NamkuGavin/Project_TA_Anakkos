import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/custom_alert_dialog.dart';

final Color blackColor = HexColor("#3d3d3d");
final Color greyColor = HexColor("#f2f2f2");

class SharedCode {
  String? usernameValidator(value) {
    return value.toString().trim().isEmpty
        ? 'username tidak boleh kosong'
        : null;
  }

  String? nameValidator(value) {
    bool nameValid = RegExp(r'[0-9]').hasMatch(value);

    if (nameValid) {
      return 'Nama tidak boleh mengandung angka';
    } else if (value.toString().trim().isEmpty) {
      return 'Nama tidak boleh kosong';
    } else {
      return null;
    }
  }

  String getInitials(String name) => name.isNotEmpty
      ? name.trim().split(RegExp(' +')).map((s) => s[0]).take(2).join()
      : '';

  String? emptyValidator(value) {
    return value.toString().trim().isEmpty
        ? 'field ini tidak boleh kosong*'
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

  static showAlertDialog(
      BuildContext context, String title, String content, String status,
      {dynamic onButtonPressed = 0}) {
    showDialog(
        context: context,
        builder: (context) {
          return CustomAlertDialog(
              title: title,
              content: content,
              status: status,
              onButtonPressed: onButtonPressed);
        });
  }
}
