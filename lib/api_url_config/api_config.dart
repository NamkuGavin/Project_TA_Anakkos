import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_anakkos_app/api_url_config/server_config.dart';
import 'package:project_anakkos_app/model/comment_model.dart';
import 'package:project_anakkos_app/model/create_kost_model.dart';
import 'package:project_anakkos_app/model/detail_kost_user_model.dart';
import 'package:project_anakkos_app/model/history_model.dart';
import 'package:project_anakkos_app/model/kost_by_facility_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/model/kost_by_popu_model.dart';
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
      required String room_price,
      required int seller_id}) async {
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
      "rating": 0,
      "seller_id": seller_id
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
    print("RAW CREATE DETAIL KOST: " + body.toString());
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

  Future editProfile(
      {required int id_user,
      required String token,
      required String name}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {"name": name};
    print("RAW EDIT PROFILE: " + body.toString());
    print("URL EDIT PROFILE: " +
        ServerConfig.baseURL +
        ServerConfig.editProfile +
        "/$id_user");
    final res = await http.put(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.editProfile + "/$id_user"),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(EDIT PROFILE): " + res.statusCode.toString());
    print("RES EDIT PROFILE: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<KostbyLocationModel> getKostbyLoc({required String location}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL KOST BY LOC: " +
        ServerConfig.baseURL +
        ServerConfig.getKostbyLoc +
        "/$location");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.getKostbyLoc + "/$location"),
        headers: headers);
    print("STATUS CODE(KOST BY LOC): " + res.statusCode.toString());
    print("RES KOST BY LOC: " + res.body.toString());
    if (res.statusCode == 200) {
      return KostbyLocationModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<KostbyPopularModel> getKostbyPopu({required String location}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL KOST BY POPULARITY: " +
        ServerConfig.baseURL +
        ServerConfig.getKostbyPopu +
        "/$location");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.getKostbyPopu + "/$location"),
        headers: headers);
    print("STATUS CODE(KOST BY POPULARITY): " + res.statusCode.toString());
    print("RES KOST BY POPULARITY: " + res.body.toString());
    if (res.statusCode == 200) {
      return KostbyPopularModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future createFacilityKost(
      {required String token,
      required int kost_id,
      required List<int> facilityId}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {"kost_id": kost_id, "facilities_id": facilityId};
    print("RAW CREATE FACILITY KOST: " + body.toString());
    print("URL CREATE FACILITY KOST: " +
        ServerConfig.baseURL +
        ServerConfig.createKostFacility);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.createKostFacility),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE FACILITY KOST): " + res.statusCode.toString());
    print("RES CREATE FACILITY KOST: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<KostbyFacilityModel> getKostbyFacility(
      {required List<int> facilityId}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"data": facilityId};
    print("RAW GET KOST BY FACILITY: " + body.toString());
    print("URL GET KOST BY FACILITY: " +
        ServerConfig.baseURL +
        ServerConfig.getKostbyFacility);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.getKostbyFacility),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(GET KOST BY FACILITY): " + res.statusCode.toString());
    print("RES GET KOST BY FACILITY: " + res.body.toString());
    if (res.statusCode == 200) {
      return KostbyFacilityModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<DetailKostUserModel> getKostDetailUser({required idKost}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL KOST DETAIL USER: " +
        ServerConfig.baseURL +
        ServerConfig.getKostDetailUser +
        "/$idKost");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.getKostDetailUser + "/$idKost"),
        headers: headers);
    print("STATUS CODE(KOST DETAIL USER): " + res.statusCode.toString());
    print("RES KOST DETAIL USER: " + res.body.toString());
    if (res.statusCode == 200) {
      return DetailKostUserModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<CommentModel> getComment({required idKost}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL COMMENT: " +
        ServerConfig.baseURL +
        ServerConfig.getComment +
        "/$idKost");
    final res = await http.get(
        Uri.parse(ServerConfig.baseURL + ServerConfig.getComment + "/$idKost"),
        headers: headers);
    print("STATUS CODE(COMMENT): " + res.statusCode.toString());
    print("RES COMMENT: " + res.body.toString());
    if (res.statusCode == 200) {
      return CommentModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future createComment(
      {required String token,
      required String kost_id,
      required String user_id,
      required String comment_body,
      required String rating}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_id": kost_id,
      "user_id": user_id,
      "comment_body": comment_body,
      "rating": rating,
    };
    print("RAW CREATE COMMENT: " + body.toString());
    print("URL CREATE COMMENT: " +
        ServerConfig.baseURL +
        ServerConfig.createComment);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.createComment),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE COMMENT): " + res.statusCode.toString());
    print("RES CREATE COMMENT: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<HistoryModel> getHistory(
      {required String token, required String user_id}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print("URL GET HISTORY: " +
        ServerConfig.baseURL +
        ServerConfig.getHistory +
        "/$user_id");
    final res = await http.get(
        Uri.parse(ServerConfig.baseURL + ServerConfig.getHistory + "/$user_id"),
        headers: headers);
    print("STATUS CODE(GET HISTORY): " + res.statusCode.toString());
    print("RES GET HISTORY: " + res.body.toString());
    if (res.statusCode == 200) {
      return HistoryModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future startTransaksi({
    required String token,
    required String user_id,
    required String status,
    required String proof_img,
    required String stay_duration,
    required String due_date,
    required String kost_id,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "user_id": user_id,
      "status": status,
      "proof_img": proof_img,
      "stay_duration": stay_duration,
      "due_date": due_date,
      "kost_id": kost_id,
    };
    print("RAW START TRANSAKSI: " + body.toString());
    print("URL START TRANSAKSI: " +
        ServerConfig.baseURL +
        ServerConfig.startTrans);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.startTrans),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(START TRANSAKSI): " + res.statusCode.toString());
    print("RES START TRANSAKSI: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future updateTransaksi({
    required String token,
    required String status,
    required int id,
    required String kost_id,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "status": status,
      "id": id,
      "kost_id": kost_id,
    };
    print("RAW UPDATE TRANSAKSI: " + body.toString());
    print("URL UPDATE TRANSAKSI: " +
        ServerConfig.baseURL +
        ServerConfig.updateTrans);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.updateTrans),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(UPDATE TRANSAKSI): " + res.statusCode.toString());
    print("RES UPDATE TRANSAKSI: " + res.body.toString());
    if (res.statusCode == 200) {
      return res.body;
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }
}
