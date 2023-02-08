import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:project_anakkos_app/api_url_config/server_config.dart';
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
}
