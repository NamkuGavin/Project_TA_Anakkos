// To parse this JSON data, do
//
//     final kostbyPopularModel = kostbyPopularModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

KostbyPopularModel kostbyPopularModelFromJson(String str) =>
    KostbyPopularModel.fromJson(json.decode(str));

String kostbyPopularModelToJson(KostbyPopularModel data) =>
    json.encode(data.toJson());

class KostbyPopularModel {
  KostbyPopularModel({
    required this.message,
    required this.data,
  });

  String message;
  List<KostbyPopularData> data;

  factory KostbyPopularModel.fromJson(Map<String, dynamic> json) =>
      KostbyPopularModel(
        message: json["message"],
        data: List<KostbyPopularData>.from(
            json["data"].map((x) => KostbyPopularData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KostbyPopularData {
  KostbyPopularData({
    required this.id,
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
    required this.totalUnit,
    required this.roomPrice,
    required this.elecPrice,
    required this.totalPrice,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String kostName;
  String location;
  String locationUrl;
  String kostType;
  String rating;
  String width;
  String weight;
  String roomRules;
  String kostRules;
  String desc;
  String totalUnit;
  String roomPrice;
  String elecPrice;
  String totalPrice;
  DateTime createdAt;
  DateTime updatedAt;

  factory KostbyPopularData.fromJson(Map<String, dynamic> json) =>
      KostbyPopularData(
        id: json["id"],
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
        totalUnit: json["total_unit"],
        roomPrice: json["room_price"],
        elecPrice: json["elec_price"],
        totalPrice: json["total_price"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
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
        "total_unit": totalUnit,
        "room_price": roomPrice,
        "elec_price": elecPrice,
        "total_price": totalPrice,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
