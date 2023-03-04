// To parse this JSON data, do
//
//     final kostRoomRuleModel = kostRoomRuleModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

KostRoomRuleModel kostRoomRuleModelFromJson(String str) =>
    KostRoomRuleModel.fromJson(json.decode(str));

String kostRoomRuleModelToJson(KostRoomRuleModel data) =>
    json.encode(data.toJson());

class KostRoomRuleModel {
  KostRoomRuleModel({
    required this.message,
    required this.data,
  });

  String message;
  List<KostRoomRuleData> data;

  factory KostRoomRuleModel.fromJson(Map<String, dynamic> json) =>
      KostRoomRuleModel(
        message: json["message"],
        data: List<KostRoomRuleData>.from(
            json["data"].map((x) => KostRoomRuleData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KostRoomRuleData {
  KostRoomRuleData({
    required this.id,
    required this.kostId,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String kostId;
  String content;
  DateTime createdAt;
  DateTime updatedAt;

  factory KostRoomRuleData.fromJson(Map<String, dynamic> json) =>
      KostRoomRuleData(
        id: json["id"],
        kostId: json["kost_id"],
        content: json["content"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kost_id": kostId,
        "content": content,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
