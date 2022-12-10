// To parse this JSON data, do
//
//     final registerModel = registerModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RegisterModel registerModelFromJson(String str) =>
    RegisterModel.fromJson(json.decode(str));

String registerModelToJson(RegisterModel data) => json.encode(data.toJson());

class RegisterModel {
  RegisterModel({
    required this.message,
    required this.data,
    required this.token,
  });

  String message;
  RegisterData data;
  String token;

  factory RegisterModel.fromJson(Map<String, dynamic> json) => RegisterModel(
        message: json["message"],
        data: RegisterData.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "token": token,
      };
}

class RegisterData {
  RegisterData({
    required this.id,
    required this.name,
    required this.email,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic rememberToken;
  String createdAt;
  String updatedAt;

  factory RegisterData.fromJson(Map<String, dynamic> json) => RegisterData(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        rememberToken: json["remember_token"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "remember_token": rememberToken,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
