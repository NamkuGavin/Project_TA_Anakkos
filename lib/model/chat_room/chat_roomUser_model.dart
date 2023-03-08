// To parse this JSON data, do
//
//     final chatRoomModel = chatRoomModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChatRoomUserModel chatRoomModelFromJson(String str) =>
    ChatRoomUserModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomUserModel data) =>
    json.encode(data.toJson());

class ChatRoomUserModel {
  ChatRoomUserModel({
    required this.message,
    required this.data,
  });

  String message;
  List<ChatRoomUserData> data;

  factory ChatRoomUserModel.fromJson(Map<String, dynamic> json) =>
      ChatRoomUserModel(
        message: json["message"],
        data: List<ChatRoomUserData>.from(
            json["data"].map((x) => ChatRoomUserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ChatRoomUserData {
  ChatRoomUserData({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.sellerName,
    required this.kostId,
    required this.username,
    required this.kostName,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String userId;
  String sellerId;
  String sellerName;
  String kostId;
  String username;
  String kostName;
  DateTime createdAt;
  DateTime updatedAt;

  factory ChatRoomUserData.fromJson(Map<String, dynamic> json) => ChatRoomUserData(
        id: json["id"],
        userId: json["user_id"],
        sellerId: json["seller_id"],
        sellerName: json["seller_name"],
        kostId: json["kost_id"],
        username: json["username"],
        kostName: json["kost_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "seller_id": sellerId,
        "seller_name": sellerName,
        "kost_id": kostId,
        "username": username,
        "kost_name": kostName,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
