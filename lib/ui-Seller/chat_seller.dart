import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/chat_model.dart';
import 'package:project_anakkos_app/model/chat_room/chat_roomSeller_model.dart';
import 'package:project_anakkos_app/model/chat_room/chat_roomUser_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/widget/chat_widget/chatWidget_seller.dart';
import 'package:project_anakkos_app/widget/chat_widget/chatWidget_user.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_google_model.dart';

class ChatSeller extends StatefulWidget {
  const ChatSeller({Key? key}) : super(key: key);

  @override
  State<ChatSeller> createState() => _ChatSellerState();
}

class _ChatSellerState extends State<ChatSeller> {
  List<ChatRoomSellerData> dataChatRoom = [];
  bool _isLoad = false;
  // List<ChatModel> chat = [
  //   ChatModel("Hai, dengan Pemilik Kost disini. Ada yang bisa saya bantu?",
  //       DateTime.now().subtract(Duration(days: 3)), false),
  //   ChatModel(
  //       "Halo, saya ingin bertanya apakah di kos ini boleh membawa kulkas?",
  //       DateTime.now().subtract(Duration(days: 3)),
  //       true),
  //   ChatModel("Boleh tapi tanggungan harga listrik nya nanti bertamah y",
  //       DateTime.now().subtract(Duration(days: 3)), false),
  //   ChatModel("Oooh bertambah y, hmm...",
  //       DateTime.now().subtract(Duration(days: 3)), true),
  //   ChatModel("Kalau boleh kemungkinan tambah biaya listrik nya berapaan?",
  //       DateTime.now().subtract(Duration(days: 3)), true),
  //   ChatModel(
  //       "kalau biaya listrik nya harus menyesuaikan berapa Watt kulkas anda",
  //       DateTime.now().subtract(Duration(days: 3)),
  //       false),
  //   ChatModel("kulkas saya bertenaga 500 Watt, itu kira kira bisa berapa?",
  //       DateTime.now().subtract(Duration(days: 3)), true),
  //   ChatModel("kalo 500 Watt mungkin bertambah sekitar 100rb an",
  //       DateTime.now().subtract(Duration(days: 3)), false),
  //   ChatModel("ooh gitu...y udah ini ta pikirkan dulu, terima kasih banyak",
  //       DateTime.now().subtract(Duration(days: 3)), true),
  //   ChatModel(
  //       "oke sama sama", DateTime.now().subtract(Duration(days: 3)), false),
  // ];

  @override
  void initState() {
    getLogin();
    super.initState();
  }

  getLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      setState(() {
        _isLoad = true;
      });
      LoginModel result = await ApiService().getLogin(
          email: pref.getString("email_owner").toString(),
          password: pref.getString("pass_owner").toString());
      ChatRoomSellerModel res = await ApiService().getChatRoomSeller(
          token: result.token, seller_id: result.data.id.toString());
      setState(() {
        dataChatRoom = res.data;
        _isLoad = false;
      });
    } catch (error) {
      print('no internet ' + error.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(),
      body: ListView.builder(
        itemCount: dataChatRoom.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              SharedCode.navigatorPush(context,
                  ChatWidgetSeller(idRoom: dataChatRoom[index].id.toString()));
            },
            child: Card(
              child: ListTile(
                leading:
                    SvgPicture.asset("assets/icon/profile.svg", width: 30.w),
                title: Text(dataChatRoom[index].kostName +
                    " - " +
                    dataChatRoom[index].sellerName),
                trailing: Text(
                    DateFormat("HH:mm").format(dataChatRoom[index].createdAt)),
              ),
            ),
          );
        },
      ),
      // body: ChatWidget(chats: chat),
    );
    ;
  }

  appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Text("Chat", style: GoogleFonts.roboto(color: Colors.black)),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          color: Colors.black,
          height: 0.2.h,
        ),
      ),
    );
  }
}
