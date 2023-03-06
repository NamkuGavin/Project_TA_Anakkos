// To parse this JSON data, do
//
//     final loginGoogleModel = loginGoogleModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginGoogleModel loginGoogleModelFromJson(String str) =>
    LoginGoogleModel.fromJson(json.decode(str));

String loginGoogleModelToJson(LoginGoogleModel data) =>
    json.encode(data.toJson());

class LoginGoogleModel {
  LoginGoogleModel({
    required this.message,
    required this.data,
    required this.token,
  });

  String message;
  LoginGoogleData data;
  String token;

  factory LoginGoogleModel.fromJson(Map<String, dynamic> json) =>
      LoginGoogleModel(
        message: json["message"],
        data: LoginGoogleData.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "token": token,
      };
}

class LoginGoogleData {
  LoginGoogleData({
    required this.id,
    required this.name,
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
  String chatStatus;
  String email;
  dynamic rentStatus;
  String role;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory LoginGoogleData.fromJson(Map<String, dynamic> json) =>
      LoginGoogleData(
        id: json["id"],
        name: json["name"],
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
        "chat_status": chatStatus,
        "email": email,
        "rent_status": rentStatus,
        "role": role,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
