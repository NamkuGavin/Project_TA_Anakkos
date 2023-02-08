// To parse this JSON data, do
//
//     final getKostModel = getKostModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

GetKostModel getKostModelFromJson(String str) =>
    GetKostModel.fromJson(json.decode(str));

String getKostModelToJson(GetKostModel data) => json.encode(data.toJson());

class GetKostModel {
  GetKostModel({
    required this.message,
    required this.data,
  });

  String message;
  List<Datum> data;

  factory GetKostModel.fromJson(Map<String, dynamic> json) => GetKostModel(
        message: json["message"],
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.id,
    required this.userId,
    required this.kostId,
    required this.profit,
    required this.avgRating,
    required this.unitRented,
    required this.unitOpen,
    required this.kostName,
    required this.status,
    required this.kostImg,
    required this.kostLocation,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  int userId;
  int kostId;
  int profit;
  String avgRating;
  int unitRented;
  int unitOpen;
  String kostName;
  String status;
  String kostImg;
  String kostLocation;
  DateTime createdAt;
  DateTime updatedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        kostId: json["kost_id"],
        profit: json["profit"],
        avgRating: json["avg_rating"],
        unitRented: json["unit_rented"],
        unitOpen: json["unit_open"],
        kostName: json["kost_name"],
        status: json["status"],
        kostImg: json["kost_img"],
        kostLocation: json["kost_location"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "kost_id": kostId,
        "profit": profit,
        "avg_rating": avgRating,
        "unit_rented": unitRented,
        "unit_open": unitOpen,
        "kost_name": kostName,
        "status": status,
        "kost_img": kostImg,
        "kost_location": kostLocation,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
