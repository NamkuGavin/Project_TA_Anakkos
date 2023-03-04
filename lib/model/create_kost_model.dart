// To parse this JSON data, do
//
//     final createKostModel = createKostModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

CreateKostModel createKostModelFromJson(String str) =>
    CreateKostModel.fromJson(json.decode(str));

String createKostModelToJson(CreateKostModel data) =>
    json.encode(data.toJson());

class CreateKostModel {
  CreateKostModel({
    required this.message,
    required this.data,
  });

  String message;
  CreateKostData data;

  factory CreateKostModel.fromJson(Map<String, dynamic> json) =>
      CreateKostModel(
        message: json["message"],
        data: CreateKostData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class CreateKostData {
  CreateKostData({
    required this.kostName,
    required this.location,
    required this.locationUrl,
    required this.kostType,
    required this.totalUnit,
    required this.rating,
    required this.desc,
    required this.width,
    required this.weight,
    required this.roomPrice,
    required this.elecPrice,
    required this.totalPrice,
    required this.updatedAt,
    required this.createdAt,
    required this.id,
  });

  String kostName;
  String location;
  String locationUrl;
  String kostType;
  String totalUnit;
  int rating;
  String desc;
  String width;
  String weight;
  String roomPrice;
  String elecPrice;
  int totalPrice;
  DateTime updatedAt;
  DateTime createdAt;
  int id;

  factory CreateKostData.fromJson(Map<String, dynamic> json) => CreateKostData(
        kostName: json["kost_name"],
        location: json["location"],
        locationUrl: json["location_url"],
        kostType: json["kost_type"],
        totalUnit: json["total_unit"],
        rating: json["rating"],
        desc: json["desc"],
        width: json["width"],
        weight: json["weight"],
        roomPrice: json["room_price"],
        elecPrice: json["elec_price"],
        totalPrice: json["total_price"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
        id: json["id"],
      );

  Map<String, dynamic> toJson() => {
        "kost_name": kostName,
        "location": location,
        "location_url": locationUrl,
        "kost_type": kostType,
        "total_unit": totalUnit,
        "rating": rating,
        "desc": desc,
        "width": width,
        "weight": weight,
        "room_price": roomPrice,
        "elec_price": elecPrice,
        "total_price": totalPrice,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
        "id": id,
      };
}
