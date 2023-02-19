// To parse this JSON data, do
//
//     final showFasilitasKostModel = showFasilitasKostModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ShowFasilitasKostModel showFasilitasKostModelFromJson(String str) =>
    ShowFasilitasKostModel.fromJson(json.decode(str));

String showFasilitasKostModelToJson(ShowFasilitasKostModel data) =>
    json.encode(data.toJson());

class ShowFasilitasKostModel {
  ShowFasilitasKostModel({
    required this.message,
    required this.data,
  });

  String message;
  List<List<FasilitasKostData>> data;

  factory ShowFasilitasKostModel.fromJson(Map<String, dynamic> json) =>
      ShowFasilitasKostModel(
        message: json["message"],
        data: List<List<FasilitasKostData>>.from(json["data"].map((x) =>
            List<FasilitasKostData>.from(
                x.map((x) => FasilitasKostData.fromJson(x))))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(
            data.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
      };
}

class FasilitasKostData {
  FasilitasKostData({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String name;
  dynamic createdAt;
  dynamic updatedAt;

  factory FasilitasKostData.fromJson(Map<String, dynamic> json) =>
      FasilitasKostData(
        id: json["id"],
        name: json["name"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
