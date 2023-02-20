// To parse this JSON data, do
//
//     final chatModel = chatModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ChatModel chatModelFromJson(String str) => ChatModel.fromJson(json.decode(str));

String chatModelToJson(ChatModel data) => json.encode(data.toJson());

class ChatModel {
  ChatModel({
    required this.message,
    required this.data,
  });

  String message;
  ChatData data;

  factory ChatModel.fromJson(Map<String, dynamic> json) => ChatModel(
        message: json["message"],
        data: ChatData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class ChatData {
  ChatData({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.sellerName,
    required this.kostId,
    required this.username,
    required this.kostName,
    required this.createdAt,
    required this.updatedAt,
    required this.message,
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
  List<Message> message;

  factory ChatData.fromJson(Map<String, dynamic> json) => ChatData(
        id: json["id"],
        userId: json["user_id"],
        sellerId: json["seller_id"],
        sellerName: json["seller_name"],
        kostId: json["kost_id"],
        username: json["username"],
        kostName: json["kost_name"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        message:
            List<Message>.from(json["message"].map((x) => Message.fromJson(x))),
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
        "message": List<dynamic>.from(message.map((x) => x.toJson())),
      };
}

class Message {
  Message({
    required this.id,
    required this.kostChatId,
    required this.userId,
    required this.username,
    required this.role,
    required this.msgContent,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String kostChatId;
  String userId;
  String username;
  String role;
  String msgContent;
  DateTime createdAt;
  DateTime updatedAt;

  factory Message.fromJson(Map<String, dynamic> json) => Message(
        id: json["id"],
        kostChatId: json["kost_chat_id"],
        userId: json["user_id"],
        username: json["username"],
        role: json["role"],
        msgContent: json["msg_content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kost_chat_id": kostChatId,
        "user_id": userId,
        "username": username,
        "role": role,
        "msg_content": msgContent,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
