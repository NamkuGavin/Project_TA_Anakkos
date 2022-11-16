import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

final Color blackColor = HexColor("#3d3d3d");
final Color greyColor = HexColor("#f2f2f2");

class SharedCode {
  String? emptyValidator(value) {
    return value.toString().trim().isEmpty
        ? 'O campo não pode estar vazio'
        : null;
  }

  String? passwordValidator(value) {
    return value.toString().length < 6
        ? 'A senha não pode ter menos de 6 caracteres'
        : null;
  }

  String? emailValidator(value) {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(value);
    return !emailValid ? 'E-mail não é válido' : null;
  }

  String? phoneValidator(value) {
    bool phoneValid =
        RegExp(r'^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$')
            .hasMatch(value);
    return !phoneValid ? 'O número de telefone não é válido' : null;
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
}
