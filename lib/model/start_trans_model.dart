// To parse this JSON data, do
//
//     final startTransModel = startTransModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

StartTransModel startTransModelFromJson(String str) =>
    StartTransModel.fromJson(json.decode(str));

String startTransModelToJson(StartTransModel data) =>
    json.encode(data.toJson());

class StartTransModel {
  StartTransModel({
    required this.message,
    required this.data,
  });

  String message;
  StartTransData data;

  factory StartTransModel.fromJson(Map<String, dynamic> json) =>
      StartTransModel(
        message: json["message"],
        data: StartTransData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class StartTransData {
  StartTransData({
    required this.kostId,
    required this.userId,
    required this.kostName,
    required this.kostType,
    required this.location,
    required this.status,
    required this.stayDuration,
    required this.totalPrice,
    required this.roomPrice,
    required this.electricity,
    required this.dueDate,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String kostId;
  String userId;
  String kostName;
  String kostType;
  String location;
  String status;
  String stayDuration;
  String totalPrice;
  String roomPrice;
  String electricity;
  String dueDate;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory StartTransData.fromJson(Map<String, dynamic> json) => StartTransData(
        kostId: json["kost_id"],
        userId: json["user_id"],
        kostName: json["kost_name"],
        kostType: json["kost_type"],
        location: json["location"],
        status: json["status"],
        stayDuration: json["stay_duration"],
        totalPrice: json["total_price"],
        roomPrice: json["room_price"],
        electricity: json["electricity"],
        dueDate: json["due_date"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kost_id": kostId,
        "user_id": userId,
        "kost_name": kostName,
        "kost_type": kostType,
        "location": location,
        "status": status,
        "stay_duration": stayDuration,
        "total_price": totalPrice,
        "room_price": roomPrice,
        "electricity": electricity,
        "due_date": dueDate,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
