// To parse this JSON data, do
//
//     final commentModel = commentModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CommentModel commentModelFromJson(String str) =>
    CommentModel.fromJson(json.decode(str));

String commentModelToJson(CommentModel data) => json.encode(data.toJson());

class CommentModel {
  CommentModel({
    required this.message,
    required this.data,
  });

  String message;
  List<CommentData> data;

  factory CommentModel.fromJson(Map<String, dynamic> json) => CommentModel(
        message: json["message"],
        data: List<CommentData>.from(
            json["data"].map((x) => CommentData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class CommentData {
  CommentData({
    required this.id,
    required this.kostId,
    required this.userId,
    required this.commentBody,
    required this.rating,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
  });

  int id;
  String kostId;
  String userId;
  String commentBody;
  String rating;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory CommentData.fromJson(Map<String, dynamic> json) => CommentData(
        id: json["id"],
        kostId: json["kost_id"],
        userId: json["user_id"],
        commentBody: json["comment_body"],
        rating: json["rating"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        user: User.fromJson(json["user"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kost_id": kostId,
        "user_id": userId,
        "comment_body": commentBody,
        "rating": rating,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.name,
    required this.phone,
    required this.chatStatus,
    required this.pfp,
    required this.email,
    required this.rentStatus,
    required this.role,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String firstName;
  String lastName;
  String name;
  String phone;
  String chatStatus;
  String pfp;
  String email;
  dynamic rentStatus;
  String role;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        firstName: json["first_name"],
        lastName: json["last_name"],
        name: json["name"],
        phone: json["phone"],
        chatStatus: json["chat_status"],
        pfp: json["pfp"],
        email: json["email"],
        rentStatus: json["rent_status"],
        role: json["role"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "first_name": firstName,
        "last_name": lastName,
        "name": name,
        "phone": phone,
        "chat_status": chatStatus,
        "pfp": pfp,
        "email": email,
        "rent_status": rentStatus,
        "role": role,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
