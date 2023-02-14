// To parse this JSON data, do
//
//     final kostbyLocationModel = kostbyLocationModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

KostbyLocationModel kostbyLocationModelFromJson(String str) =>
    KostbyLocationModel.fromJson(json.decode(str));

String kostbyLocationModelToJson(KostbyLocationModel data) =>
    json.encode(data.toJson());

class KostbyLocationModel {
  KostbyLocationModel({
    required this.message,
    required this.data,
  });

  String message;
  List<KostbyLocationData> data;

  factory KostbyLocationModel.fromJson(Map<String, dynamic> json) =>
      KostbyLocationModel(
        message: json["message"],
        data: List<KostbyLocationData>.from(
            json["data"].map((x) => KostbyLocationData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KostbyLocationData {
  KostbyLocationData({
    required this.id,
    required this.sellerId,
    required this.kostName,
    required this.location,
    required this.locationUrl,
    required this.kostType,
    required this.rating,
    required this.width,
    required this.weight,
    required this.roomRules,
    required this.kostRules,
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
  int sellerId;
  String kostName;
  String location;
  String locationUrl;
  String kostType;
  int rating;
  String width;
  String weight;
  String roomRules;
  String kostRules;
  String desc;
  int unitOpen;
  int totalUnit;
  int roomPrice;
  int elecPrice;
  int totalPrice;
  DateTime createdAt;
  DateTime updatedAt;

  factory KostbyLocationData.fromJson(Map<String, dynamic> json) =>
      KostbyLocationData(
        id: json["id"],
        sellerId: json["seller_id"],
        kostName: json["kost_name"],
        location: json["location"],
        locationUrl: json["location_url"],
        kostType: json["kost_type"],
        rating: json["rating"],
        width: json["width"],
        weight: json["weight"],
        roomRules: json["room_rules"],
        kostRules: json["kost_rules"],
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
        "kost_name": kostName,
        "location": location,
        "location_url": locationUrl,
        "kost_type": kostType,
        "rating": rating,
        "width": width,
        "weight": weight,
        "room_rules": roomRules,
        "kost_rules": kostRules,
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
