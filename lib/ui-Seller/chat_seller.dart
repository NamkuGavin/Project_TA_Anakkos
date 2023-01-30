import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/chat_model.dart';
import 'package:project_anakkos_app/widget/chatWidget.dart';

class ChatSeller extends StatefulWidget {
  const ChatSeller({Key? key}) : super(key: key);

  @override
  State<ChatSeller> createState() => _ChatSellerState();
}

class _ChatSellerState extends State<ChatSeller> {
  List<ChatModel> chat = [
    ChatModel(
        "Halo, saya ingin bertanya apakah di kos ini boleh membawa kulkas?",
        DateTime.now().subtract(Duration(days: 3)),
        false),
    ChatModel("Boleh tapi tanggungan harga listrik nya nanti bertamah y",
        DateTime.now().subtract(Duration(days: 3)), true),
    ChatModel("Oooh bertambah y, hmm...",
        DateTime.now().subtract(Duration(days: 3)), false),
    ChatModel("Kalau boleh kemungkinan tambah biaya listrik nya berapaan?",
        DateTime.now().subtract(Duration(days: 3)), false),
    ChatModel(
        "kalau biaya listrik nya harus menyesuaikan berapa Watt kulkas anda",
        DateTime.now().subtract(Duration(days: 3)),
        true),
    ChatModel("kulkas saya bertenaga 500 Watt, itu kira kira bisa berapa?",
        DateTime.now().subtract(Duration(days: 3)), false),
    ChatModel("kalo 500 Watt mungkin bertambah sekitar 100rb an",
        DateTime.now().subtract(Duration(days: 3)), true),
    ChatModel("ooh gitu...y udah ini ta pikirkan dulu, terima kasih banyak",
        DateTime.now().subtract(Duration(days: 3)), false),
    ChatModel(
        "oke sama sama", DateTime.now().subtract(Duration(days: 3)), true),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(),
      body: ListView(
        children: [
          InkWell(
            onTap: () {
              SharedCode.navigatorPush(
                  context, ChatWidget(chats: chat, title: 'Customer 1'));
            },
            child: Card(
              child: ListTile(
                leading:
                    SvgPicture.asset("assets/icon/profile.svg", width: 30.w),
                title: Text('Seller 1'),
                trailing: Text("12:00"),
              ),
            ),
          ),
        ],
      ),
    );
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
