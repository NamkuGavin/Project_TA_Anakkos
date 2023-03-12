import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/model/chat_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/widget/custom_text_form.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatWidgetSeller extends StatefulWidget {
  final String idRoom;
  ChatWidgetSeller({Key? key, required this.idRoom}) : super(key: key);

  @override
  State<ChatWidgetSeller> createState() => _ChatWidgetSellerState();
}

class _ChatWidgetSellerState extends State<ChatWidgetSeller> {
  TextEditingController chatController = TextEditingController();
  ChatData? dataChat;
  // List<Message>? messageData;
  ValueNotifier<List<Message>> messageData = ValueNotifier<List<Message>>([]);
  Timer? timer;
  bool _isLoad = false;

  Future getChat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ChatModel res = await ApiService()
        .getChat(token: pref.getString("token_owner")!, room_id: widget.idRoom);
    setState(() {
      dataChat = res.data;
      messageData.value = res.data.message;
    });
  }

  Future getChatBeginning() async {
    setState(() {
      _isLoad = true;
    });
    SharedPreferences pref = await SharedPreferences.getInstance();
    ChatModel res = await ApiService()
        .getChat(token: pref.getString("token_owner")!, room_id: widget.idRoom);
    setState(() {
      dataChat = res.data;
      messageData.value = res.data.message;
      _isLoad = false;
    });
  }

  Future getChatAfterCreate() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_owner").toString(),
        password: pref.getString("pass_owner").toString());
    ChatModel res =
        await ApiService().getChat(token: result.token, room_id: widget.idRoom);
    setState(() {
      dataChat = res.data;
      messageData.value = res.data.message;
    });
  }

  Future createChat() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_owner").toString(),
        password: pref.getString("pass_owner").toString());
    await ApiService().createChat(
        token: result.token,
        kost_chat_id: widget.idRoom,
        user_id: result.data.id.toString(),
        role: "owner",
        msg_content: chatController.text);
    await getChatAfterCreate();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getChatBeginning();
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) => getChat());
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoad
        ? Scaffold(body: LoadingAnimation())
        : Scaffold(
            appBar: AppBar(
              title: Text(dataChat!.kostName + " - " + dataChat!.sellerName,
                  style: GoogleFonts.roboto(color: Colors.white)),
              backgroundColor: Color(0XFF006BB8),
              iconTheme: IconThemeData(
                color: Colors.white,
              ),
              centerTitle: true,
            ),
            body: ValueListenableBuilder(
                valueListenable: messageData,
                builder: (BuildContext context, value, Widget? child) {
                  return Column(
                    children: [
                      Expanded(
                          child: GroupedListView<Message, DateTime>(
                        padding: EdgeInsets.all(8),
                        reverse: true,
                        order: GroupedListOrder.DESC,
                        useStickyGroupSeparators: true,
                        floatingHeader: true,
                        elements: messageData.value,
                        groupBy: (chat) {
                          return DateTime(
                            chat.updatedAt.year,
                            chat.updatedAt.month,
                            chat.updatedAt.day,
                          );
                        },
                        groupHeaderBuilder: (Message chat) {
                          return SizedBox(
                            height: 40.h,
                            child: Center(
                              child: Card(
                                color: Color(0xFFF8ECEC),
                                child: Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                    DateFormat.yMMMd().format(chat.createdAt),
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        itemBuilder: (context, Message chat) {
                          return Align(
                            alignment: Alignment.bottomCenter,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              child: Align(
                                alignment: (chat.role == "owner")
                                    ? Alignment.topRight
                                    : Alignment.topLeft,
                                child: Container(
                                  margin: (chat.role == "owner")
                                      ? EdgeInsets.only(left: 50)
                                      : EdgeInsets.only(right: 50),
                                  padding: EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: (chat.role == "owner")
                                        ? Colors.blue[200]
                                        : Colors.grey.shade200,
                                  ),
                                  child: Text(
                                    chat.msgContent,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      )),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(12),
                            width: 300.w,
                            height: 75.h,
                            child: CustomTextFormField(
                              label: 'Ketikkan seusatu',
                              controller: chatController,
                              borderRadius: 30,
                            ),
                          ),
                          Expanded(
                            child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all(
                                  CircleBorder(),
                                ),
                                padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(10),
                                ),
                                backgroundColor: MaterialStateProperty.all(
                                  ColorValues.primaryBlue,
                                ),
                              ),
                              onPressed: () async {
                                await createChat();
                                chatController.clear();
                              },
                              child: const Icon(Icons.send, size: 20),
                            ),
                          ),
                        ],
                      )
                    ],
                  );
                }),
          );
  }
}
