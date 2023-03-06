// To parse this JSON data, do
//
//     final registerGoogleModel = registerGoogleModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

RegisterGoogleModel registerGoogleModelFromJson(String str) =>
    RegisterGoogleModel.fromJson(json.decode(str));

String registerGoogleModelToJson(RegisterGoogleModel data) =>
    json.encode(data.toJson());

class RegisterGoogleModel {
  RegisterGoogleModel({
    required this.message,
    required this.data,
    required this.token,
  });

  String message;
  RegisterGoogleData data;
  String token;

  factory RegisterGoogleModel.fromJson(Map<String, dynamic> json) =>
      RegisterGoogleModel(
        message: json["message"],
        data: RegisterGoogleData.fromJson(json["data"]),
        token: json["token"],
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
        "token": token,
      };
}

class RegisterGoogleData {
  RegisterGoogleData({
    required this.name,
    required this.email,
    required this.role,
    required this.chatStatus,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String name;
  String email;
  String role;
  String chatStatus;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory RegisterGoogleData.fromJson(Map<String, dynamic> json) =>
      RegisterGoogleData(
        name: json["name"],
        email: json["email"],
        role: json["role"],
        chatStatus: json["chat_status"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "email": email,
        "role": role,
        "chat_status": chatStatus,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
