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
import 'package:project_anakkos_app/model/chat_room_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/widget/chatWidget.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/login_google_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  Widget _widget = Container();
  final user = FirebaseAuth.instance.currentUser;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  List<ChatRoomData> dataChatRoom = [];
  List<ChatModel> chat = [
    ChatModel("Hai, dengan Pemilik Kost disini. Ada yang bisa saya bantu?",
        DateTime.now().subtract(Duration(days: 3)), false),
    ChatModel(
        "Halo, saya ingin bertanya apakah di kos ini boleh membawa kulkas?",
        DateTime.now().subtract(Duration(days: 3)),
        true),
    ChatModel("Boleh tapi tanggungan harga listrik nya nanti bertamah y",
        DateTime.now().subtract(Duration(days: 3)), false),
    ChatModel("Oooh bertambah y, hmm...",
        DateTime.now().subtract(Duration(days: 3)), true),
    ChatModel("Kalau boleh kemungkinan tambah biaya listrik nya berapaan?",
        DateTime.now().subtract(Duration(days: 3)), true),
    ChatModel(
        "kalau biaya listrik nya harus menyesuaikan berapa Watt kulkas anda",
        DateTime.now().subtract(Duration(days: 3)),
        false),
    ChatModel("kulkas saya bertenaga 500 Watt, itu kira kira bisa berapa?",
        DateTime.now().subtract(Duration(days: 3)), true),
    ChatModel("kalo 500 Watt mungkin bertambah sekitar 100rb an",
        DateTime.now().subtract(Duration(days: 3)), false),
    ChatModel("ooh gitu...y udah ini ta pikirkan dulu, terima kasih banyak",
        DateTime.now().subtract(Duration(days: 3)), true),
    ChatModel(
        "oke sama sama", DateTime.now().subtract(Duration(days: 3)), false),
  ];

  @override
  void initState() {
    _checkLogin();
    super.initState();
  }

  _checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("token_user") == null && user == null) {
      setState(() {
        _widget = belumLogin();
      });
    } else if (user != null) {
      print("GOOGLE LOGIN");
      await getLoginGoogle();
    } else {
      print("APPS LOGIN");
      await getLoginApps();
    }
  }

  getLoginApps() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    try {
      setState(() {
        _widget = LoadingAnimation();
      });
      LoginModel result = await ApiService().getLogin(
          email: pref.getString("email_user").toString(),
          password: pref.getString("pass_user").toString());
      ChatRoomModel res = await ApiService().getChatRoomUser(
          token: result.token, user_id: result.data.id.toString());
      setState(() {
        dataChatRoom = res.data;
        _widget = sudahLoginApps();
      });
    } catch (error) {
      print('no internet ' + error.toString());
    }
  }

  getLoginGoogle() async {
    setState(() {
      _widget = LoadingAnimation();
    });
    LoginGoogleModel result =
        await ApiService().getLoginGoogle(email: user!.email.toString());
    ChatRoomModel res = await ApiService().getChatRoomUser(
        token: result.token, user_id: result.data.id.toString());
    setState(() {
      dataChatRoom = res.data;
      _widget = sudahLoginGoogle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _widget;
  }

  belumLogin() {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset("assets/logo/blm_login.svg", width: 175.w),
              SizedBox(height: 40.h),
              Text("Login terlebih dahulu untuk mengakses fitur ini",
                  textAlign: TextAlign.center,
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w500,
                    fontSize: 20,
                  )),
              SizedBox(height: 25.h),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: 300.w,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ColorValues.primaryBlue,
                        foregroundColor: Colors.white,
                        minimumSize: Size(double.infinity, 50.h),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: () {
                        SharedCode.navigatorPush(context, RolePage());
                      },
                      child: Text('Login',
                          style:
                              GoogleFonts.inter(fontWeight: FontWeight.bold))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  sudahLoginApps() {
    return Scaffold(
      appBar: appbarWidget(),
      body: ListView.builder(
        itemCount: dataChatRoom.length,
        itemBuilder: (BuildContext context, int index) {
          return InkWell(
            onTap: () {
              SharedCode.navigatorPush(context,
                  ChatWidget(idRoom: dataChatRoom[index].id.toString()));
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
  }

  sudahLoginGoogle() {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot>(
            future: _users.doc(user!.uid).get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                    child: Lottie.asset(
                  'assets/lottie/loading.json',
                  width: 150.w,
                ));
              } else if (snapshot.hasError) {
                print("ERROR: " + snapshot.hasError.toString());
                return Center(child: Text("Something Wrong"));
              } else {
                return Scaffold(
                  appBar: appbarWidget(),
                  body: ListView.builder(
                    itemCount: dataChatRoom.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          SharedCode.navigatorPush(
                              context,
                              ChatWidget(
                                  idRoom: dataChatRoom[index].id.toString()));
                        },
                        child: Card(
                          child: ListTile(
                            leading: SvgPicture.asset("assets/icon/profile.svg",
                                width: 30.w),
                            title: Text(dataChatRoom[index].kostName +
                                " - " +
                                dataChatRoom[index].sellerName),
                            trailing: Text(DateFormat("HH:mm")
                                .format(dataChatRoom[index].createdAt)),
                          ),
                        ),
                      );
                    },
                  ),
                  // body: ChatWidget(chats: chat),
                );
              }
            }));
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
