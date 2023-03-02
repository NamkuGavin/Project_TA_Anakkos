// To parse this JSON data, do
//
//     final imageModel = imageModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

ImageModel imageModelFromJson(String str) =>
    ImageModel.fromJson(json.decode(str));

String imageModelToJson(ImageModel data) => json.encode(data.toJson());

class ImageModel {
  ImageModel({
    required this.message,
    required this.data,
  });

  String message;
  List<ImageData> data;

  factory ImageModel.fromJson(Map<String, dynamic> json) => ImageModel(
        message: json["message"],
        data: List<ImageData>.from(
            json["data"].map((x) => ImageData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "message": message,
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class ImageData {
  ImageData({
    required this.id,
    required this.kostId,
    required this.img,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  String kostId;
  String img;
  DateTime createdAt;
  DateTime updatedAt;

  factory ImageData.fromJson(Map<String, dynamic> json) => ImageData(
        id: json["id"],
        kostId: json["kost_id"],
        img: json["img"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "kost_id": kostId,
        "img": img,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
      };
}
