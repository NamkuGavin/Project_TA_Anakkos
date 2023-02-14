// To parse this JSON data, do
//
//     final kostbyFacilityModel = kostbyFacilityModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

KostbyFacilityModel kostbyFacilityModelFromJson(String str) =>
    KostbyFacilityModel.fromJson(json.decode(str));

String kostbyFacilityModelToJson(KostbyFacilityModel data) =>
    json.encode(data.toJson());

class KostbyFacilityModel {
  KostbyFacilityModel({
    required this.data,
  });
  List<List<KostbyFacilityData>> data;

  factory KostbyFacilityModel.fromJson(Map<String, dynamic> json) =>
      KostbyFacilityModel(
        data: List<List<KostbyFacilityData>>.from(json["data"].map((x) =>
            List<KostbyFacilityData>.from(
                x.map((x) => KostbyFacilityData.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(
            data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class KostbyFacilityData {
  KostbyFacilityData({
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

  factory KostbyFacilityData.fromJson(Map<String, dynamic> json) =>
      KostbyFacilityData(
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
