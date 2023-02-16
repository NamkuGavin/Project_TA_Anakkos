import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/chat_model.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/fliter_model.dart';
import 'package:project_anakkos_app/helper/check_status.dart';
import 'package:project_anakkos_app/model/history_model.dart';
import 'package:project_anakkos_app/model/kost_by_facility_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/model/kost_by_popu_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-User/detail_kost.dart';
import 'package:project_anakkos_app/widget/chatWidget.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:project_anakkos_app/widget/nearby_kost.dart';
import 'package:project_anakkos_app/widget/populer_kost.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../dummy/dummy model/populer_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoad = false;
  String location = "jakarta";
  List<KostbyLocationData> dataKostbyLoc = [];
  List<KostbyPopularData> dataKostbyPopular = [];
  List<int> idFacilityConfirm = [];
  List<List<KostbyFacilityData>>? dataKostbyFacility;
  List<HistoryData> dataPendingan = [];
  List<HistoryData> kostPending = [];
  final _seacrhController = TextEditingController();

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

  Future getKostPending() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoad = true;
    });
    if (pref.getString("email_user") != null &&
        pref.getString("pass_user") != null) {
      LoginModel login_res = await ApiService().getLogin(
          email: pref.getString("email_user").toString(),
          password: pref.getString("pass_user").toString());
      HistoryModel history_res = await ApiService().getHistory(
          token: login_res.token, user_id: login_res.data.id.toString());
      setState(() {
        dataPendingan = history_res.data;
        kostPending = dataPendingan
            .where((element) => element.status == "pending")
            .toList();
      });
      KostbyLocationModel kost_byLoc =
          await ApiService().getKostbyLoc(location: location);
      setState(() {
        dataKostbyLoc = kost_byLoc.data;
      });
      await getKostbyPopular();
    } else {
      await getKostbyPopular();
      KostbyLocationModel kost_byLoc =
          await ApiService().getKostbyLoc(location: location);
      setState(() {
        dataKostbyLoc = kost_byLoc.data;
      });
    }
    setState(() {
      _isLoad = false;
    });
  }

  Future getKostbyFacility() async {
    setState(() {
      _isLoad = true;
    });
    KostbyFacilityModel _model =
        await ApiService().getKostbyFacility(facilityId: idFacilityConfirm);
    setState(() {
      dataKostbyFacility = _model.data;
      _isLoad = false;
    });
    Navigator.pop(context);
  }

  Future getKostbyPopular() async {
    KostbyPopularModel _model =
        await ApiService().getKostbyPopu(location: location);
    setState(() {
      dataKostbyPopular = _model.data;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKostPending();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: _isLoad
          ? LoadingAnimation()
          : idFacilityConfirm.isEmpty
              ? SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      filterWidget(),
                      ongoingKost(),
                      SizedBox(height: 20.h),
                      popularKost(),
                      nearbyKost(),
                    ],
                  ),
                )
              : kostByFacility(),
    );
  }

  appBarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        AnimSearchBar(
          boxShadow: false,
          width: 375,
          textController: _seacrhController,
          onSuffixTap: () {
            setState(() {
              _seacrhController.clear();
            });
          },
          onSubmitted: (String) async {
            setState(() {
              location = _seacrhController.text;
            });
            setState(() {
              _isLoad = true;
            });
            KostbyLocationModel _model =
                await ApiService().getKostbyLoc(location: location);
            setState(() {
              dataKostbyLoc = _model.data;
            });
            await getKostbyPopular();
            setState(() {
              _isLoad = false;
            });
          },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          color: Colors.black,
          height: 0.2.h,
        ),
      ),
    );
  }

  popularKost() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Popular Kost",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          dataKostbyPopular.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/not_found.json',
                        width: 225.w,
                        repeat: false,
                      ),
                      Text(
                        'Belum ada Kost yang di Sewakan',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize: 17,
                              color: Color(0XFF9B9B9B),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.7,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        // SharedCode.navigatorPush(context, DetailKost(model: widget.model));
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10)),
                                child: Image.asset("assets/dummykos/kost_1.png",
                                    fit: BoxFit.cover)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12.h),
                                  DottedBorder(
                                    color: Colors.black,
                                    strokeWidth: 1,
                                    child: Text(
                                        dataKostbyPopular![index].kostType,
                                        style: GoogleFonts.inter(fontSize: 11)),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(dataKostbyPopular![index].kostName,
                                      style: GoogleFonts.inter(fontSize: 11)),
                                  SizedBox(height: 4.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_rounded, size: 13),
                                      Text(dataKostbyPopular![index].location,
                                          style:
                                              GoogleFonts.inter(fontSize: 11))
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                        "Rp. " +
                                            dataKostbyPopular![index]
                                                .roomPrice
                                                .toString() +
                                            " / Bulan",
                                        style: GoogleFonts.inter(fontSize: 11)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorValues.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(20.w, 30.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  SharedCode.navigatorPush(context, PopulerKost());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lainnya', style: GoogleFonts.inter(fontSize: 12)),
                    Icon(Icons.double_arrow_rounded)
                  ],
                )),
          )
          // SizedBox(height: 10.h),
          // GestureDetector(
          //   onTap: () {
          //     SharedCode.navigatorPush(context, PopulerKost());
          //   },
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Icon(Icons.add, size: 15),
          //       Text('Lainnya', style: GoogleFonts.inter(fontSize: 12))
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  nearbyKost() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Text("Kost Terdekat",
                    style: GoogleFonts.inter(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    )),
              ),
              Expanded(
                child: Divider(
                  color: Colors.grey,
                  thickness: 0.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          dataKostbyLoc.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/not_found.json',
                        width: 225.w,
                        repeat: false,
                      ),
                      Text(
                        'Belum ada Kost yang di Sewakan',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize: 17,
                              color: Color(0XFF9B9B9B),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.57,
                    crossAxisCount: 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                  ),
                  itemCount: 4,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        SharedCode.navigatorPush(
                            context,
                            DetailKost(
                              idKost: dataKostbyLoc![index].id.toString(),
                            ));
                      },
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        shadowColor: Colors.black,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10)),
                                child: Image.asset("assets/dummykos/kost_1.png",
                                    fit: BoxFit.cover)),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 4),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(height: 12.h),
                                  DottedBorder(
                                    color: Colors.black,
                                    strokeWidth: 1,
                                    child: Text(dataKostbyLoc![index].kostType,
                                        style: GoogleFonts.inter(fontSize: 11)),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(dataKostbyLoc![index].kostName,
                                      style: GoogleFonts.inter(fontSize: 11)),
                                  SizedBox(height: 4.h),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.location_on_rounded, size: 13),
                                      Expanded(
                                        child: Text(
                                            dataKostbyLoc![index].location,
                                            style: GoogleFonts.inter(
                                                fontSize: 11)),
                                      )
                                    ],
                                  ),
                                  SizedBox(height: 6.h),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Text(
                                        "Rp. " +
                                            dataKostbyLoc![index]
                                                .roomPrice
                                                .toString() +
                                            " / Bulan",
                                        style: GoogleFonts.inter(fontSize: 11)),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    );
                  },
                ),
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorValues.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(20.w, 30.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  SharedCode.navigatorPush(
                      context, NearByKost(location: location));
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lainnya', style: GoogleFonts.inter(fontSize: 12)),
                    Icon(Icons.double_arrow_rounded)
                  ],
                )),
          )
        ],
      ),
    );
  }

  ongoingKost() {
    return kostPending.isNotEmpty
        ? Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Text("Sedang Berjalan",
                          style: GoogleFonts.inter(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                          )),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.grey,
                        thickness: 0.5,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.h),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 5, // changes position of shadow
                      ),
                    ],
                  ),
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.horizontal(
                              left: Radius.circular(10)),
                          child: Container(
                              height: 150.h,
                              width: 100.w,
                              child: Image.asset("assets/dummykos/kost_2.png",
                                  fit: BoxFit.fill)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          color: Color(0XFFFD9900),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        child: Text(kostPending[0].status,
                                            style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 11)),
                                      ),
                                    ),
                                    Text(kostPending[0].dueDate + " ",
                                        style:
                                            GoogleFonts.roboto(fontSize: 12)),
                                  ],
                                ),
                                SizedBox(height: 7.h),
                                Text(kostPending[0].kost.kostName,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                SizedBox(height: 7.h),
                                Text("Total : Rp. " + kostPending[0].totalPrice,
                                    style: GoogleFonts.roboto(fontSize: 12)),
                                SizedBox(height: 7.h),
                                Text(
                                    "Stay duration: " +
                                        kostPending[0].stayDuration,
                                    style: GoogleFonts.roboto(fontSize: 12)),
                                Align(
                                  alignment: Alignment.bottomLeft,
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        side: BorderSide(
                                            width: 1,
                                            color: ColorValues.primaryPurple),
                                        backgroundColor: Colors.white,
                                        foregroundColor: Colors.black,
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        minimumSize: Size(0.w, 25.h),
                                      ),
                                      onPressed: () {
                                        SharedCode.navigatorPush(
                                            context,
                                            ChatWidget(
                                                chats: chat,
                                                title: 'Seller 1'));
                                      },
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text('Chat Pemilik Kost',
                                              style: GoogleFonts.inter(
                                                  fontSize: 10)),
                                          SizedBox(width: 5.w),
                                          Icon(
                                              CupertinoIcons
                                                  .chat_bubble_text_fill,
                                              size: 15)
                                        ],
                                      )),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : Container();
  }

  filterWidget() {
    return Padding(
      padding: EdgeInsets.only(right: 12, top: 5),
      child: Align(
        alignment: Alignment.topRight,
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorValues.primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: Size(0.w, 30.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              _showDialog(context);
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Filter', style: GoogleFonts.inter(fontSize: 13)),
                SizedBox(width: 25.w),
                Icon(Icons.filter_alt_rounded)
              ],
            )),
      ),
    );
  }

  Future _showDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            insetPadding: EdgeInsets.all(0),
            content: Builder(builder: (context) {
              return SizedBox(
                height: 425.h,
                // height: 525.h,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text("Filter Fasilitas",
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.black,
                            fontSize: 16)),
                    SizedBox(height: 25.h),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tempat Tidur',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black45,
                                        fontSize: 14)),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.bantal,
                                      onChanged: (bool? value) {
                                        int id = 1;
                                        setState(() {
                                          CheckStatus.bantal = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Bantal",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.kasur,
                                      onChanged: (bool? value) {
                                        int id = 2;
                                        setState(() {
                                          CheckStatus.kasur = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Kasur",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(color: Colors.black),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Kamar mandi',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black45,
                                        fontSize: 14)),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.kamarMandi,
                                      onChanged: (bool? value) {
                                        int id = 3;
                                        setState(() {
                                          CheckStatus.kamarMandi = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Luar",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.laundry,
                                      onChanged: (bool? value) {
                                        int id = 4;
                                        setState(() {
                                          CheckStatus.laundry = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Dalam",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 7.h),
                    Divider(color: Colors.black),
                    SizedBox(height: 7.h),
                    IntrinsicHeight(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(right: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Lain - lain',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black45,
                                        fontSize: 14)),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.lemari,
                                      onChanged: (bool? value) {
                                        int id = 5;
                                        setState(() {
                                          CheckStatus.lemari = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Lemari",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.meja,
                                      onChanged: (bool? value) {
                                        int id = 6;
                                        setState(() {
                                          CheckStatus.meja = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Meja",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.kursi,
                                      onChanged: (bool? value) {
                                        int id = 7;
                                        setState(() {
                                          CheckStatus.kursi = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Kursi",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          VerticalDivider(color: Colors.black),
                          Padding(
                            padding: EdgeInsets.only(left: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Sirkulasi Udara',
                                    style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.black45,
                                        fontSize: 14)),
                                SizedBox(height: 4.h),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.kipas,
                                      onChanged: (bool? value) {
                                        int id = 9;
                                        setState(() {
                                          CheckStatus.kipas = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("Kipas",
                                        style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Checkbox(
                                      value: CheckStatus.ac,
                                      onChanged: (bool? value) {
                                        int id = 8;
                                        setState(() {
                                          CheckStatus.ac = value!;
                                          if (value != false) {
                                            idFacilityConfirm.add(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          } else {
                                            idFacilityConfirm.remove(id);
                                            print("LIST ID: " +
                                                idFacilityConfirm.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text("AC", style: TextStyle(fontSize: 14)),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: Container()),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorValues.primaryPurple,
                            foregroundColor: Colors.white,
                            minimumSize: Size(0.w, 0.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            getKostbyFacility();
                          },
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Tampilkan Hasil',
                                    style: GoogleFonts.inter(fontSize: 14)),
                                SizedBox(width: 10.w),
                                Icon(Icons.save)
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
              );
            }),
          );
        });
      },
    );
  }

  kostByFacility() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        filterWidget(),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(8.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                childAspectRatio: 0.6,
                crossAxisCount: 2,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: dataKostbyFacility!.length,
              itemBuilder: (BuildContext context, int index) {
                return InkWell(
                  onTap: () {
                    // SharedCode.navigatorPush(context, DetailKost(model: widget.model));
                  },
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shadowColor: Colors.black,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                            borderRadius: BorderRadius.vertical(
                                bottom: Radius.circular(10)),
                            child: Image.asset("assets/dummykos/kost_1.png",
                                fit: BoxFit.cover)),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 15.h),
                              DottedBorder(
                                color: Colors.black,
                                strokeWidth: 1,
                                child: Text(
                                    dataKostbyFacility![index][0].kostType,
                                    style: GoogleFonts.inter(fontSize: 11)),
                              ),
                              SizedBox(height: 7.h),
                              Text(dataKostbyFacility![index][0].kostName,
                                  style: GoogleFonts.inter(fontSize: 11)),
                              SizedBox(height: 7.h),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Icon(Icons.location_on_rounded, size: 13),
                                  Expanded(
                                    child: Text(
                                        dataKostbyFacility![index][0].location,
                                        style: GoogleFonts.inter(fontSize: 11)),
                                  )
                                ],
                              ),
                              SizedBox(height: 8.h),
                              Align(
                                alignment: Alignment.bottomRight,
                                child: Text(
                                    "Rp. " +
                                        dataKostbyFacility![index][0]
                                            .roomPrice
                                            .toString() +
                                        " / Bulan",
                                    style: GoogleFonts.inter(fontSize: 11)),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
