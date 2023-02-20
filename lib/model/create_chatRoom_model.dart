// To parse this JSON data, do
//
//     final createchatRoomModel = createchatRoomModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreatechatRoomModel createchatRoomModelFromJson(String str) =>
    CreatechatRoomModel.fromJson(json.decode(str));

String createchatRoomModelToJson(CreatechatRoomModel data) =>
    json.encode(data.toJson());

class CreatechatRoomModel {
  CreatechatRoomModel({
    required this.message,
    required this.data,
  });

  String message;
  CreatechatRoomData data;

  factory CreatechatRoomModel.fromJson(Map<String, dynamic> json) =>
      CreatechatRoomModel(
        message: json["message"],
        data: CreatechatRoomData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class CreatechatRoomData {
  CreatechatRoomData({
    required this.kostId,
    required this.userId,
    required this.username,
    required this.kostName,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String kostId;
  String userId;
  String username;
  String kostName;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory CreatechatRoomData.fromJson(Map<String, dynamic> json) =>
      CreatechatRoomData(
        kostId: json["kost_id"],
        userId: json["user_id"],
        username: json["username"],
        kostName: json["kost_name"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kost_id": kostId,
        "user_id": userId,
        "username": username,
        "kost_name": kostName,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
