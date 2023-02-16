// To parse this JSON data, do
//
//     final detailKostUserModel = detailKostUserModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

DetailKostUserModel detailKostUserModelFromJson(String str) =>
    DetailKostUserModel.fromJson(json.decode(str));

String detailKostUserModelToJson(DetailKostUserModel data) =>
    json.encode(data.toJson());

class DetailKostUserModel {
  DetailKostUserModel({
    required this.message,
    required this.data,
  });

  String message;
  DetailKostUserData data;

  factory DetailKostUserModel.fromJson(Map<String, dynamic> json) =>
      DetailKostUserModel(
        message: json["message"],
        data: DetailKostUserData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": data.toJson(),
      };
}

class DetailKostUserData {
  DetailKostUserData({
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
    required this.user,
  });

  int id;
  String sellerId;
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
  String unitOpen;
  String totalUnit;
  String roomPrice;
  String elecPrice;
  String totalPrice;
  DateTime createdAt;
  DateTime updatedAt;
  User user;

  factory DetailKostUserData.fromJson(Map<String, dynamic> json) =>
      DetailKostUserData(
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
        user: User.fromJson(json["user"]),
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
        "user": user.toJson(),
      };
}

class User {
  User({
    required this.id,
    required this.name,
    required this.email,
    required this.rentStatus,
    required this.role,
    required this.rememberToken,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  String email;
  dynamic rentStatus;
  String role;
  dynamic rememberToken;
  DateTime createdAt;
  DateTime updatedAt;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        rentStatus: json["rent_status"],
        role: json["role"],
        rememberToken: json["remember_token"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "rent_status": rentStatus,
        "role": role,
        "remember_token": rememberToken,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
