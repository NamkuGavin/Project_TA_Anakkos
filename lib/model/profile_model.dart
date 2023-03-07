// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ProfileModel profileModelFromJson(String str) =>
    ProfileModel.fromJson(json.decode(str));

String profileModelToJson(ProfileModel data) => json.encode(data.toJson());

class ProfileModel {
  ProfileModel({
    required this.message,
    required this.data,
  });

  String message;
  List<ProfileData> data;

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
        message: json["message"],
        data: List<ProfileData>.from(
            json["data"].map((x) => ProfileData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ProfileData {
  ProfileData({
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

  factory ProfileData.fromJson(Map<String, dynamic> json) => ProfileData(
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
