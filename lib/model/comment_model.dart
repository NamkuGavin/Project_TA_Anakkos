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
    required this.name,
    required this.email,
    required this.rentStatus,
    required this.role,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic rentStatus;
  String role;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
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
        "email": email,
        "rent_status": rentStatus,
        "role": role,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
