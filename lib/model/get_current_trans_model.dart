// To parse this JSON data, do
//
//     final currentTransaksiModel = currentTransaksiModelFromJson(jsonString);

import 'dart:convert';

CurrentTransaksiModel currentTransaksiModelFromJson(String str) =>
    CurrentTransaksiModel.fromJson(json.decode(str));

String currentTransaksiModelToJson(CurrentTransaksiModel data) =>
    json.encode(data.toJson());

class CurrentTransaksiModel {
  CurrentTransaksiModel({
    required this.message,
    required this.data,
  });

  String message;
  CurrentTransaksiData data;

  factory CurrentTransaksiModel.fromJson(Map<String, dynamic> json) =>
      CurrentTransaksiModel(
        message: json["message"],
        data: CurrentTransaksiData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class CurrentTransaksiData {
  CurrentTransaksiData({
    required this.id,
    required this.kostId,
    required this.userId,
    required this.orderId,
    required this.status,
    required this.kostName,
    required this.kostType,
    required this.location,
    required this.stayDuration,
    required this.totalPrice,
    required this.electricity,
    required this.roomPrice,
    required this.dueDate,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String kostId;
  String userId;
  String orderId;
  String status;
  String kostName;
  String kostType;
  String location;
  String stayDuration;
  String totalPrice;
  String electricity;
  String roomPrice;
  String dueDate;
  DateTime createdAt;
  DateTime updatedAt;

  factory CurrentTransaksiData.fromJson(Map<String, dynamic> json) =>
      CurrentTransaksiData(
        id: json["id"],
        kostId: json["kost_id"],
        userId: json["user_id"],
        orderId: json["order_id"],
        status: json["status"],
        kostName: json["kost_name"],
        kostType: json["kost_type"],
        location: json["location"],
        stayDuration: json["stay_duration"],
        totalPrice: json["total_price"],
        electricity: json["electricity"],
        roomPrice: json["room_price"],
        dueDate: json["due_date"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kost_id": kostId,
        "user_id": userId,
        "order_id": orderId,
        "status": status,
        "kost_name": kostName,
        "kost_type": kostType,
        "location": location,
        "stay_duration": stayDuration,
        "total_price": totalPrice,
        "electricity": electricity,
        "room_price": roomPrice,
        "due_date": dueDate,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
