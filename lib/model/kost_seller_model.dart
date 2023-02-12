// To parse this JSON data, do
//
//     final getKostModel = getKostModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

KostSellerModel getKostModelFromJson(String str) =>
    KostSellerModel.fromJson(json.decode(str));

String getKostModelToJson(KostSellerModel data) => json.encode(data.toJson());

class KostSellerModel {
  KostSellerModel({
    required this.message,
    required this.data,
  });

  String message;
  List<KostSellerData> data;

  factory KostSellerModel.fromJson(Map<String, dynamic> json) =>
      KostSellerModel(
        message: json["message"],
        data: List<KostSellerData>.from(
            json["data"].map((x) => KostSellerData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class KostSellerData {
  KostSellerData({
    required this.id,
    required this.sellerId,
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
  String sellerId;
  String kostId;
  String profit;
  String avgRating;
  String unitRented;
  String unitOpen;
  String kostName;
  String status;
  String kostImg;
  String kostLocation;
  DateTime createdAt;
  DateTime updatedAt;

  factory KostSellerData.fromJson(Map<String, dynamic> json) => KostSellerData(
        id: json["id"],
        sellerId: json["seller_id"],
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
        "seller_id": sellerId,
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
