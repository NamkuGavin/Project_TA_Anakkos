// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

LoginModel loginModelFromJson(String str) =>
    LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  LoginModel({
    required this.data,
    required this.accessToken,
    required this.tokenType,
  });

  Data data;
  String accessToken;
  String tokenType;

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        data: Data.fromJson(json["data"]),
        accessToken: json["access_token"],
        tokenType: json["token_type"],
      );

  Map<String, dynamic> toJson() => {
        "data": data.toJson(),
        "access_token": accessToken,
        "token_type": tokenType,
      };
}

class Data {
  Data({
    required this.id,
    required this.accountRoleId,
    required this.name,
    required this.email,
    required this.ownerCompany,
    required this.ownerCompanyImage,
    required this.emailVerifiedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  int id;
  dynamic accountRoleId;
  String name;
  String email;
  String ownerCompany;
  String ownerCompanyImage;
  dynamic emailVerifiedAt;
  String createdAt;
  String updatedAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        accountRoleId: json["account_role_id"],
        name: json["name"],
        email: json["email"],
        ownerCompany: json["owner_company"],
        ownerCompanyImage: json["owner_company_image"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "account_role_id": accountRoleId,
        "name": name,
        "email": email,
        "owner_company": ownerCompany,
        "owner_company_image": ownerCompanyImage,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt,
        "updated_at": updatedAt,
      };
}
