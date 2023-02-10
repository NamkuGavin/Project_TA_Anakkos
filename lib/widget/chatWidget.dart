import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/chat_model.dart';
import 'package:project_anakkos_app/widget/custom_text_form.dart';

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
            Text(widget.title, style: GoogleFonts.roboto(color: Colors.white)),
        backgroundColor: Color(0XFF006BB8),
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        centerTitle: true,
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
                    color:
                        // Color(0xFFF8ECEC),
                        Color(0xFFF8ECEC),
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Text(
                        DateFormat.yMMMd().format(chat.date),
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ),
                ),
              );
            },
            itemBuilder: (context, ChatModel chat) {
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  child: Align(
                    alignment: (chat.SentByMe)
                        ? Alignment.topRight
                        : Alignment.topLeft,
                    child: Container(
                      margin: (chat.SentByMe)
                          ? const EdgeInsets.only(left: 50)
                          : const EdgeInsets.only(right: 50),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: (chat.SentByMe)
                            ? Colors.blue[200]
                            : Colors.grey.shade200,
                      ),
                      child: Text(
                        chat.text,
                        style: const TextStyle(
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
                      const CircleBorder(),
                    ),
                    padding: MaterialStateProperty.all(
                      const EdgeInsets.all(10),
                    ),
                    backgroundColor: MaterialStateProperty.all(
                      ColorValues.primaryBlue,
                    ),
                  ),
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
                  child: const Icon(Icons.send, size: 20),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
