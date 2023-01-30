import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/chat_model.dart';

class ChatWidget extends StatefulWidget {
  final String title;
  final List<ChatModel> chats;
  ChatWidget({Key? key, required this.chats, required this.title})
      : super(key: key);

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  TextEditingController chatController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.title, style: GoogleFonts.roboto(color: Colors.black)),
        backgroundColor: Color(0xFFF8ECEC),
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
      ),
      body: Column(
        children: [
          Expanded(
              child: GroupedListView<ChatModel, DateTime>(
            padding: EdgeInsets.all(8),
            reverse: true,
            order: GroupedListOrder.DESC,
            useStickyGroupSeparators: true,
            floatingHeader: true,
            elements: widget.chats,
            groupBy: (chat) {
              return DateTime(chat.date.year, chat.date.month, chat.date.day);
            },
            groupHeaderBuilder: (ChatModel chat) {
              return SizedBox(
                height: 40.h,
                child: Center(
                  child: Card(
                    color: Color(0xFFF8ECEC),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        DateFormat.yMMMd().format(chat.date),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemBuilder: (context, ChatModel chat) {
              return Align(
                alignment: chat.SentByMe
                    ? Alignment.centerRight
                    : Alignment.centerLeft,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: SizedBox(
                    width: 175.w,
                    child: Container(
                      decoration: BoxDecoration(
                        color: chat.SentByMe
                            ? ColorValues.primaryBlue
                            : Color(0XFF455A64),
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25),
                            topRight: Radius.circular(25),
                            bottomLeft: chat.SentByMe == true
                                ? Radius.circular(25)
                                : Radius.circular(0),
                            bottomRight: chat.SentByMe == false
                                ? Radius.circular(25)
                                : Radius.circular(0)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.8),
                            spreadRadius: 2,
                            blurRadius: 5, // changes position of shadow
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(12),
                        child: Text(chat.text,
                            style: GoogleFonts.roboto(color: Colors.white)),
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
                child: TextField(
                  controller: chatController,
                  decoration: InputDecoration(
                      hintText: 'Tulis Pesanmu...',
                      hintStyle: TextStyle(
                          fontSize: 14,
                          color: Colors.black38,
                          fontWeight: FontWeight.w500),
                      enabledBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffD6D6D6), width: 2),
                          borderRadius: BorderRadius.circular(25)),
                      focusedBorder: OutlineInputBorder(
                          borderSide:
                              BorderSide(color: ColorValues.primaryBlue),
                          borderRadius: BorderRadius.circular(25))),
                ),
              ),
              RawMaterialButton(
                constraints: BoxConstraints(minWidth: 0),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                onPressed: () {
                  final byUserSeller =
                      ChatModel(chatController.text, DateTime.now(), true);
                  final bySeller = ChatModel("Halo", DateTime.now(), false);
                  final bySeller1 = ChatModel(
                      "Dengan Pemilik Kost disini. Ada yang bisa saya bantu?",
                      DateTime.now(),
                      false);
                  final byUserSellerMuslim =
                      ChatModel("Waalaikumsalam", DateTime.now(), false);
                  final byUser = ChatModel("iya?", DateTime.now(), false);
                  final byUser1 = ChatModel("gimana?", DateTime.now(), false);
                  if (chatController.text == "Hai" ||
                      chatController.text == "hai") {
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        List.generate(1, (index) {
                          return widget.chats.add(bySeller);
                        });
                      });
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          List.generate(1, (index) {
                            return widget.chats.add(bySeller1);
                          });
                        });
                      });
                    });
                  } else if (chatController.text == "Assalamualaikum" ||
                      chatController.text == "assalamualaikum") {
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        List.generate(1, (index) {
                          return widget.chats.add(byUserSellerMuslim);
                        });
                      });
                      Future.delayed(Duration(seconds: 3), () {
                        setState(() {
                          List.generate(1, (index) {
                            return widget.chats.add(bySeller1);
                          });
                        });
                      });
                    });
                  } else if (chatController.text == "Permisi" ||
                      chatController.text == "permisi") {
                    Future.delayed(Duration(seconds: 2), () {
                      setState(() {
                        List.generate(1, (index) {
                          return widget.chats.add(byUser);
                        });
                      });
                      Future.delayed(Duration(seconds: 2), () {
                        setState(() {
                          List.generate(1, (index) {
                            return widget.chats.add(byUser1);
                          });
                        });
                      });
                    });
                  }
                  setState(() {
                    widget.chats.add(byUserSeller);
                    chatController.clear();
                  });
                },
                elevation: 2.0,
                fillColor: ColorValues.primaryBlue,
                child: Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(12),
                shape: CircleBorder(),
              )
            ],
          )
        ],
      ),
    );
  }
}
