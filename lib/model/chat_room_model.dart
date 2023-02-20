// To parse this JSON data, do
//
//     final chatRoomModel = chatRoomModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChatRoomModel chatRoomModelFromJson(String str) =>
    ChatRoomModel.fromJson(json.decode(str));

String chatRoomModelToJson(ChatRoomModel data) => json.encode(data.toJson());

class ChatRoomModel {
  ChatRoomModel({
    required this.message,
    required this.data,
  });

  String message;
  List<ChatRoomData> data;

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) => ChatRoomModel(
        message: json["message"],
        data: List<ChatRoomData>.from(
            json["data"].map((x) => ChatRoomData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ChatRoomData {
  ChatRoomData({
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

  factory ChatRoomData.fromJson(Map<String, dynamic> json) => ChatRoomData(
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
