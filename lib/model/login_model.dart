// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.message,
    required this.data,
    required this.token,
  });

  String message;
  LoginData data;
  String token;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        message: json["message"],
        data: LoginData.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "token": token,
      };
}

class LoginData {
  LoginData({
    required this.id,
    required this.name,
    required this.pfp,
    required this.chatStatus,
    required this.email,
    required this.rentStatus,
    required this.role,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String pfp;
  String chatStatus;
  String email;
  dynamic rentStatus;
  String role;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory LoginData.fromJson(Map<String, dynamic> json) => LoginData(
        id: json["id"],
        name: json["name"],
        pfp: json["pfp"],
        chatStatus: json["chat_status"],
        email: json["email"],
        rentStatus: json["rent_status"],
        role: json["role"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "pfp": pfp,
        "chat_status": chatStatus,
        "email": email,
        "rent_status": rentStatus,
        "role": role,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
