// To parse this JSON data, do
//
//     final historyModel = historyModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

HistoryModel historyModelFromJson(String str) =>
    HistoryModel.fromJson(json.decode(str));

String historyModelToJson(HistoryModel data) => json.encode(data.toJson());

class HistoryModel {
  HistoryModel({
    required this.message,
    required this.data,
  });

  String message;
  List<HistoryData> data;

  factory HistoryModel.fromJson(Map<String, dynamic> json) => HistoryModel(
        message: json["message"],
        data: List<HistoryData>.from(
            json["data"].map((x) => HistoryData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class HistoryData {
  HistoryData({
    required this.id,
    required this.kostId,
    required this.userId,
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
    required this.kost,
  });

  int id;
  String kostId;
  String userId;
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
  Kost kost;

  factory HistoryData.fromJson(Map<String, dynamic> json) => HistoryData(
        id: json["id"],
        kostId: json["kost_id"],
        userId: json["user_id"],
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
        kost: Kost.fromJson(json["kost"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kost_id": kostId,
        "user_id": userId,
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
        "kost": kost.toJson(),
      };
}

class Kost {
  Kost({
    required this.id,
    required this.sellerId,
    required this.coverImg,
    required this.kostName,
    required this.location,
    required this.locationUrl,
    required this.kostType,
    required this.rating,
    required this.width,
    required this.weight,
    required this.desc,
    required this.unitOpen,
    required this.totalUnit,
    required this.roomPrice,
    required this.elecPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String sellerId;
  String coverImg;
  String kostName;
  String location;
  String locationUrl;
  String kostType;
  String rating;
  String width;
  String weight;
  String desc;
  String unitOpen;
  String totalUnit;
  String roomPrice;
  String elecPrice;
  String totalPrice;
  DateTime createdAt;
  DateTime updatedAt;

  factory Kost.fromJson(Map<String, dynamic> json) => Kost(
        id: json["id"],
        sellerId: json["seller_id"],
        coverImg: json["cover_img"],
        kostName: json["kost_name"],
        location: json["location"],
        locationUrl: json["location_url"],
        kostType: json["kost_type"],
        rating: json["rating"],
        width: json["width"],
        weight: json["weight"],
        desc: json["desc"],
        unitOpen: json["unit_open"],
        totalUnit: json["total_unit"],
        roomPrice: json["room_price"],
        elecPrice: json["elec_price"],
        totalPrice: json["total_price"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "seller_id": sellerId,
        "cover_img": coverImg,
        "kost_name": kostName,
        "location": location,
        "location_url": locationUrl,
        "kost_type": kostType,
        "rating": rating,
        "width": width,
        "weight": weight,
        "desc": desc,
        "unit_open": unitOpen,
        "total_unit": totalUnit,
        "room_price": roomPrice,
        "elec_price": elecPrice,
        "total_price": totalPrice,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
