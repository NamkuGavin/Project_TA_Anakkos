import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:project_anakkos_app/api_url_config/server_config.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/model/chat_model.dart';
import 'package:project_anakkos_app/model/chat_room_model.dart';
import 'package:project_anakkos_app/model/comment_model.dart';
import 'package:project_anakkos_app/model/create_chatRoom_model.dart';
import 'package:project_anakkos_app/model/create_kost_model.dart';
import 'package:project_anakkos_app/model/detail_kost_user_model.dart';
import 'package:project_anakkos_app/model/history_model.dart';
import 'package:project_anakkos_app/model/image_model.dart';
import 'package:project_anakkos_app/model/kost_by_facility_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/model/kost_by_popu_model.dart';
import 'package:project_anakkos_app/model/kost_room_rule_model.dart';
import 'package:project_anakkos_app/model/kost_seller_model.dart';
import 'package:project_anakkos_app/model/login_google_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/model/register_google_model.dart';
import 'package:project_anakkos_app/model/register_model.dart';
import 'package:project_anakkos_app/model/show_fasilitas_kost_model.dart';
import 'package:project_anakkos_app/model/start_trans_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mime/mime.dart';

class ApiService {
  Future<LoginModel> getLogin(
      {required String email, required String password}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"email": email, "password": password};
    print("RAW LOGIN: " + body.toString());
    print("URL LOGIN: " + ServerConfig.baseURL + ServerConfig.login);
    final res = await http
        .post(Uri.parse(ServerConfig.baseURL + ServerConfig.login),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 20));
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
    final body = {"name": name, 'pfp': 'inc'};
    print("RAW EDIT PROFILE: " + body.toString());
    print("URL EDIT PROFILE: " +
        ServerConfig.baseURL +
        ServerConfig.editProfile +
        "/$id_user");
    final res = await http.post(
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
      required double rating}) async {
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

  Future<StartTransModel> startTransaksi({
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
      return StartTransModel.fromJson(jsonDecode(res.body));
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

  Future<ShowFasilitasKostModel> showFasilitasKos({required String id}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL SHOW FASILITAS KOS: " +
        ServerConfig.baseURL +
        ServerConfig.showFasilitasKos +
        "/$id");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.showFasilitasKos + "/$id"),
        headers: headers);
    print("STATUS CODE(SHOW FASILITAS KOS): " + res.statusCode.toString());
    print("RES SHOW FASILITAS KOS: " + res.body.toString());
    if (res.statusCode == 200) {
      return ShowFasilitasKostModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future uploadImageRoom(
      {required File file,
      required String kost_id,
      required String token}) async {
    var mimeType = lookupMimeType(file.path);
    var bytes = await File.fromUri(Uri.parse(file.path)).readAsBytes();
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_id": kost_id,
    };
    http.MultipartRequest request = new http.MultipartRequest(
        "POST", Uri.parse(ServerConfig.baseURL + ServerConfig.uploadImageRoom));
    print("URL UPLOAD IMAGE: " +
        ServerConfig.baseURL +
        ServerConfig.uploadImageRoom);
    http.MultipartFile multipartFile = await http.MultipartFile.fromBytes(
        'img', bytes,
        filename: basename(file.path),
        contentType: MediaType.parse(mimeType.toString()));
    request.fields.addAll(body);
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // streamedResponse.stream.transform(utf8.decoder).listen((value) {
    //   debugPrint(value);
    // });
    print("STATUS CODE(UPLOAD IMAGE): " + response.statusCode.toString());
    print("RES UPLOAD IMAGE: " + response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      throw HttpException('request error code ${response.statusCode}');
    }
  }

  ///Old uploadImage API
  // Future uploadImage(
  //     {required File file,
  //       required String kost_id,
  //       required String token}) async {
  //   var stream = new http.ByteStream(DelegatingStream.typed(file.openRead()));
  //   var length = await file.length();
  //   Map<String, String> headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //   final body = {
  //     "kost_id": kost_id,
  //   };
  //   http.MultipartRequest request = new http.MultipartRequest(
  //       "POST", Uri.parse(ServerConfig.baseURL + ServerConfig.uploadImage));
  //   print(
  //       "URL UPLOAD IMAGE: " + ServerConfig.baseURL + ServerConfig.uploadImage);
  //   http.MultipartFile multipartFile = await http.MultipartFile(
  //       'img', stream, length,
  //       filename: basename(file.path),
  //       contentType: new MediaType('img', 'jpg'));
  //   request.fields.addAll(body);
  //   request.headers.addAll(headers);
  //   request.files.add(multipartFile);
  //   var streamedResponse = await request.send();
  //   var response = await http.Response.fromStream(streamedResponse);
  //   // streamedResponse.stream.transform(utf8.decoder).listen((value) {
  //   //   debugPrint(value);
  //   // });
  //   print("STATUS CODE(UPLOAD IMAGE): " + response.statusCode.toString());
  //   print("RES UPLOAD IMAGE: " + response.body);
  //   if (response.statusCode == 200) {
  //     return jsonDecode(response.body);
  //   } else {
  //     print(response.statusCode);
  //     throw HttpException('request error code ${response.statusCode}');
  //   }
  // }

  Future<ChatRoomModel> getChatRoomUser(
      {required String token, required String user_id}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print("URL GET CHAT ROOM: " +
        ServerConfig.baseURL +
        ServerConfig.chatRoomUser +
        "/$user_id");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.chatRoomUser + "/$user_id"),
        headers: headers);
    print("STATUS CODE(GET CHAT ROOM): " + res.statusCode.toString());
    print("RES GET CHAT ROOM: " + res.body.toString());
    if (res.statusCode == 200) {
      return ChatRoomModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<ChatModel> getChat(
      {required String token, required String room_id}) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print("URL GET CHAT: " +
        ServerConfig.baseURL +
        ServerConfig.chat +
        "/$room_id");
    final res = await http.get(
        Uri.parse(ServerConfig.baseURL + ServerConfig.chat + "/$room_id"),
        headers: headers);
    print("STATUS CODE(GET CHAT): " + res.statusCode.toString());
    print("RES GET CHAT: " + res.body.toString());
    if (res.statusCode == 200) {
      return ChatModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<CreatechatRoomModel> createChatRoom({
    required String token,
    required String user_id,
    required String kost_id,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_id": kost_id,
      "user_id": user_id,
    };
    print("RAW CREATE CHAT ROOM: " + body.toString());
    print("URL CREATE CHAT ROOM: " +
        ServerConfig.baseURL +
        ServerConfig.createChatRoom);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.createChatRoom),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE CHAT ROOM): " + res.statusCode.toString());
    print("RES CREATE CHAT ROOM: " + res.body.toString());
    if (res.statusCode == 200) {
      return CreatechatRoomModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future createChat({
    required String token,
    required String kost_chat_id,
    required String user_id,
    required String role,
    required String msg_content,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_chat_id": kost_chat_id,
      "user_id": user_id,
      "role": role,
      "msg_content": msg_content,
    };
    print("RAW CREATE CHAT: " + body.toString());
    print("URL CREATE CHAT: " + ServerConfig.baseURL + ServerConfig.createChat);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.createChat),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE CHAT): " + res.statusCode.toString());
    print("RES CREATE CHAT: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future deleteKost({
    required String token,
    required String kost_id,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    print("URL DELETE KOST: " +
        ServerConfig.baseURL +
        ServerConfig.deleteKost +
        "/$kost_id");
    final res = await http.delete(
        Uri.parse(ServerConfig.baseURL + ServerConfig.deleteKost + "/$kost_id"),
        headers: headers);
    print("STATUS CODE(DELETE KOST): " + res.statusCode.toString());
    print("RES DELETE KOST: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<ImageModel> getImageRoom({required String kost_id}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL IMAGE ROOM: " +
        ServerConfig.baseURL +
        ServerConfig.getImageRoomKost +
        "/$kost_id");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.getImageRoomKost + "/$kost_id"),
        headers: headers);
    print("STATUS CODE(IMAGE ROOM): " + res.statusCode.toString());
    print("RES IMAGE ROOM: " + res.body.toString());
    if (res.statusCode == 200) {
      return ImageModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future uploadImageKost(
      {required File file,
      required String kost_id,
      required String token}) async {
    var mimeType = lookupMimeType(file.path);
    var bytes = await File.fromUri(Uri.parse(file.path)).readAsBytes();
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_id": kost_id,
    };
    http.MultipartRequest request = new http.MultipartRequest(
        "POST", Uri.parse(ServerConfig.baseURL + ServerConfig.uploadImageKost));
    print("URL UPLOAD IMAGE: " +
        ServerConfig.baseURL +
        ServerConfig.uploadImageKost);
    http.MultipartFile multipartFile = await http.MultipartFile.fromBytes(
        'img', bytes,
        filename: basename(file.path),
        contentType: MediaType.parse(mimeType.toString()));
    request.fields.addAll(body);
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // streamedResponse.stream.transform(utf8.decoder).listen((value) {
    //   debugPrint(value);
    // });
    print("STATUS CODE(UPLOAD IMAGE): " + response.statusCode.toString());
    print("RES UPLOAD IMAGE: " + response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      throw HttpException('request error code ${response.statusCode}');
    }
  }

  Future updateImageKost({required int kostId}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL UPDATE IMAGE KOST: " +
        ServerConfig.baseURL +
        ServerConfig.updateImageKost +
        "/$kostId");
    final res = await http.post(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.updateImageKost + "/$kostId"),
        headers: headers);
    print("STATUS CODE(UPDATE IMAGE KOST): " + res.statusCode.toString());
    print("RES UPDATE IMAGE KOST: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future getAvgRate({required String kost_id}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL UPDATE AVG RATE: " +
        ServerConfig.baseURL +
        ServerConfig.updateAvgRating +
        "/$kost_id");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.updateAvgRating + "/$kost_id"),
        headers: headers);
    print("STATUS CODE(UPDATE AVG RATE): " + res.statusCode.toString());
    print("RES UPDATE AVG RATE: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future createKostRule({
    required String token,
    required String kost_id,
    required List<String> content_rule,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_id": kost_id,
      "content": content_rule,
    };
    print("RAW CREATE KOST RULE: " + body.toString());
    print("URL CREATE KOST RULE: " +
        ServerConfig.baseURL +
        ServerConfig.addKostRule);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.addKostRule),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE KOST RULE): " + res.statusCode.toString());
    print("RES CREATE KOST RULE: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future createRoomRule({
    required String token,
    required String kost_id,
    required List<String> content_rule,
  }) async {
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "kost_id": kost_id,
      "content": content_rule,
    };
    print("RAW CREATE ROOM RULE: " + body.toString());
    print("URL CREATE ROOM RULE: " +
        ServerConfig.baseURL +
        ServerConfig.addRoomRule);
    final res = await http.post(
        Uri.parse(ServerConfig.baseURL + ServerConfig.addRoomRule),
        headers: headers,
        body: jsonEncode(body));
    print("STATUS CODE(CREATE ROOM RULE): " + res.statusCode.toString());
    print("RES CREATE ROOM RULE: " + res.body.toString());
    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<KostRoomRuleModel> getKostRule({required String kost_id}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL KOST RULE: " +
        ServerConfig.baseURL +
        ServerConfig.getKostRule +
        "/$kost_id");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.getKostRule + "/$kost_id"),
        headers: headers);
    print("STATUS CODE KOST RULE): " + res.statusCode.toString());
    print("RES KOST RULE: " + res.body.toString());
    if (res.statusCode == 200) {
      return KostRoomRuleModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<KostRoomRuleModel> getRoomRule({required String kost_id}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    print("URL ROOM RULE: " +
        ServerConfig.baseURL +
        ServerConfig.getRoomRule +
        "/$kost_id");
    final res = await http.get(
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.getRoomRule + "/$kost_id"),
        headers: headers);
    print("STATUS CODE ROOM RULE): " + res.statusCode.toString());
    print("RES ROOM RULE: " + res.body.toString());
    if (res.statusCode == 200) {
      return KostRoomRuleModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<LoginGoogleModel> getLoginGoogle({required String email}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"email": email};
    print("RAW LOGIN GOOGLE: " + body.toString());
    print(
        "URL LOGIN GOOGLE: " + ServerConfig.baseURL + ServerConfig.loginGoogle);
    final res = await http
        .post(Uri.parse(ServerConfig.baseURL + ServerConfig.loginGoogle),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 20));
    print("STATUS CODE(LOGIN GOOGLE): " + res.statusCode.toString());
    print("RES LOGIN GOOGLE: " + res.body.toString());
    if (res.statusCode == 200) {
      return LoginGoogleModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future<RegisterGoogleModel> getRegisterGoogle(
      {required String email, required String name}) async {
    Map<String, String> headers = {
      'Content-Type': 'application/json',
    };
    final body = {"name": name, "email": email};
    print("RAW REGISTER GOOGLE: " + body.toString());
    print("URL REGISTER GOOGLE: " +
        ServerConfig.baseURL +
        ServerConfig.registerGoogle);
    final res = await http
        .post(Uri.parse(ServerConfig.baseURL + ServerConfig.registerGoogle),
            headers: headers, body: jsonEncode(body))
        .timeout(Duration(seconds: 20));
    print("STATUS CODE(REGISTER GOOGLE): " + res.statusCode.toString());
    print("RES REGISTER GOOGLE: " + res.body.toString());
    if (res.statusCode == 200) {
      return RegisterGoogleModel.fromJson(jsonDecode(res.body));
    } else {
      print(res.statusCode);
      throw HttpException('request error code ${res.statusCode}');
    }
  }

  Future editProfile_withImage(
      {required File file,
      required String name,
      required String token,
      required int id_user}) async {
    var mimeType = lookupMimeType(file.path);
    var bytes = await File.fromUri(Uri.parse(file.path)).readAsBytes();
    Map<String, String> headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };
    final body = {
      "name": name,
    };
    http.MultipartRequest request = new http.MultipartRequest(
        "POST",
        Uri.parse(
            ServerConfig.baseURL + ServerConfig.editProfile + "/$id_user"));
    print("URL UPDATE PROFILE WITH IMAGE: " +
        ServerConfig.baseURL +
        ServerConfig.editProfile +
        "/$id_user");
    http.MultipartFile multipartFile = await http.MultipartFile.fromBytes(
        'pfp', bytes,
        filename: basename(file.path),
        contentType: MediaType.parse(mimeType.toString()));
    request.fields.addAll(body);
    request.headers.addAll(headers);
    request.files.add(multipartFile);
    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);
    // streamedResponse.stream.transform(utf8.decoder).listen((value) {
    //   debugPrint(value);
    // });
    print("STATUS CODE(UPDATE PROFILE WITH IMAGE): " +
        response.statusCode.toString());
    print("RES UPDATE PROFILE WITH IMAGE: " + response.body);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print(response.statusCode);
      throw HttpException('request error code ${response.statusCode}');
    }
  }
}
