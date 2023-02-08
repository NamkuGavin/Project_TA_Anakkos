import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_anakkos_app/api_url_config/server_config.dart';
import 'package:project_anakkos_app/model/create_kost_model.dart';
import 'package:project_anakkos_app/model/kost_seller_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/model/register_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  Future<LoginModel> getLogin(
      {required String email, required String password}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"email": email, "password": password};
    print("RAW LOGIN: " + body.toString());
    print("URL LOGIN: " + ServerConfig.baseURL + ServerConfig.login);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.login),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(LOGIN): " + res.statusCode.toString());
    print("RES LOGIN: " + res.body.toString());
    if (res.statusCode == 200) {
      return LoginModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<RegisterModel> getRegister(
      {required String username,
      required String email,
      required String password,
      required String role}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {
      "name": username,
      "email": email,
      "password": password,
      "role": role
    };
    print("RAW REGISTER: " + body.toString());
    print("URL REGISTER: " + ServerConfig.baseURL + ServerConfig.register);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.register),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(REGISTER): " + res.statusCode.toString());
    print("RES REGISTER: " + res.body.toString());
    if (res.statusCode == 200) {
      return RegisterModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future logout(String token) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print("URL LOGOUT: " + ServerConfig.baseURL + ServerConfig.logout);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.logout),
        headers: headers);
    print("STATUS CODE(LOGOUT): " + res.statusCode.toString());
    print("RES LOGOUT: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<KostSellerModel> getKostSeller(
      {required int id_seller, required String token}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print("URL KOST SELLER: " +
        ServerConfig.baseURL +
        ServerConfig.getKostSeller +
        "/$id_seller");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.getKostSeller + "/$id_seller"),
        headers: headers);
    print("STATUS CODE(KOST SELLER): " + res.statusCode.toString());
    print("RES KOST SELLER: " + res.body.toString());
    if (res.statusCode == 200) {
      return KostSellerModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<CreateKostModel> createKost(
      {required String token,
      required String kost_name,
      required String kost_type,
      required String total_unit,
      required String location,
      required String location_url,
      required String width,
      required String weight,
      required String kost_rules,
      required String room_rules,
      required String desc,
      required String elec_price,
      required String room_price}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_name": kost_name,
      "kost_type": kost_type,
      "total_unit": total_unit,
      "location": location,
      "location_url": location_url,
      "width": width,
      "weight": weight,
      "kost_rules": kost_rules,
      "room_rules": room_rules,
      "desc": desc,
      "elec_price": elec_price,
      "room_price": room_price,
    };
    print("RAW CREATE KOST: " + body.toString());
    print("URL CREATE KOST: " + ServerConfig.baseURL + ServerConfig.createKost);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.createKost),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE KOST): " + res.statusCode.toString());
    print("RES CREATE KOST: " + res.body.toString());
    if (res.statusCode == 200) {
      return CreateKostModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future createDetailKost(
      {required String token,
      required String seller_id,
      required String kost_id,
      required String status}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "seller_id": seller_id,
      "kost_id": kost_id,
      "status": status,
    };
    print("URL CREATE DETAIL KOST: " +
        ServerConfig.baseURL +
        ServerConfig.createDetailKost);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.createDetailKost),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE DETAIL KOST): " + res.statusCode.toString());
    print("RES CREATE DETAIL KOST: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }
}
