import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/db_helper.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/ulasan_model.dart';
import 'package:project_anakkos_app/dummy/dummy_bookmark.dart';
import 'package:project_anakkos_app/model/comment_model.dart';
import 'package:project_anakkos_app/model/db_model/kost_model.dart';
import 'package:project_anakkos_app/model/detail_kost_user_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/model/kost_room_rule_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/model/show_fasilitas_kost_model.dart';
import 'package:project_anakkos_app/ui-User/booking_page.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_dates.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_image.dart';
import 'package:project_anakkos_app/widget/chat_widget/chatWidget_user.dart';
import 'package:project_anakkos_app/widget/custom_text_form.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailKostOld extends StatefulWidget {
  final KostbyLocationData model;
  final String idKost;
  DetailKostOld({Key? key, required this.idKost, required this.model})
      : super(key: key);

  @override
  State<DetailKostOld> createState() => _DetailKostOldState();
}

class _DetailKostOldState extends State<DetailKostOld> {
  TextEditingController commentController = TextEditingController();
  Color _iconColor = Colors.grey;
  String pemilikkost = "";
  final user = FirebaseAuth.instance.currentUser;
  DetailKostUserData? dataDetailKost;
  List<CommentData>? dataComment;
  bool _isLoad = true;
  bool _isLogin = false;
  List<List<FasilitasKostData>>? dataFasilitas;
  double? rate;
  List<KostRoomRuleData>? dataRoomRule;
  List<KostRoomRuleData>? dataKostRule;
  Widget widgetChat = Container();

  Future getDetailKost() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoad = true;
    });
    if (pref.getString("token_user") == null && user == null) {
      null;
    } else if (user != null) {
      setState(() {
        _isLogin = true;
        widgetChat = chatButton();
      });
    } else {
      setState(() {
        _isLogin = true;
        widgetChat = chatButton();
      });
    }
    DetailKostUserModel _model =
        await ApiService().getKostDetailUser(idKost: widget.idKost);
    await getComment();
    await getFasilitas();
    await getRoomKostRule();
    setState(() {
      dataDetailKost = _model.data;
      pemilikkost = _model.data.user.name;
      _isLoad = false;
    });
  }

  Future getComment() async {
    CommentModel _model = await ApiService().getComment(idKost: widget.idKost);
    setState(() {
      dataComment = _model.data;
    });
  }

  Future getFasilitas() async {
    ShowFasilitasKostModel _model =
        await ApiService().showFasilitasKos(id: widget.idKost);
    setState(() {
      dataFasilitas = _model.data;
    });
  }

  Future getRoomKostRule() async {
    KostRoomRuleModel kostRuleModel =
        await ApiService().getKostRule(kost_id: widget.idKost);
    KostRoomRuleModel roomRuleModel =
        await ApiService().getRoomRule(kost_id: widget.idKost);
    setState(() {
      dataKostRule = kostRuleModel.data;
      dataRoomRule = roomRuleModel.data;
    });
  }

  Future createChatRoom() async {
    if (user != null) {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        _isLoad = true;
      });
      await ApiService().createChatRoom(
        token: pref.getString("token_user_google")!,
        user_id: pref.getInt("id_user_google").toString(),
        kost_id: widget.idKost,
      );
      setState(() {
        _isLoad = true;
      });
    } else {
      SharedPreferences pref = await SharedPreferences.getInstance();
      setState(() {
        _isLoad = true;
      });
      LoginModel result = await ApiService().getLogin(
          email: pref.getString("email_user").toString(),
          password: pref.getString("pass_user").toString());
      await ApiService().createChatRoom(
        token: result.token,
        user_id: result.data.id.toString(),
        kost_id: widget.idKost,
      );
      setState(() {
        _isLoad = true;
      });
    }
  }

  Future createComment() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoad = true;
    });
    LoginModel result_log = await ApiService().getLogin(
        email: pref.getString("email_user").toString(),
        password: pref.getString("pass_user").toString());
    await ApiService().createComment(
        token: result_log.token,
        kost_id: widget.idKost,
        user_id: result_log.data.id.toString(),
        comment_body: commentController.text,
        rating: rate!);
    await ApiService().getAvgRate(kost_id: widget.idKost);
    await getComment();
    setState(() {
      _isLoad = false;
    });
  }

  Future addNote() async {
    final kost_fav = KostFav(
        idKost: int.parse(widget.idKost),
        name: widget.model.kostName,
        coverImg: widget.model.coverImg,
        location: widget.model.location,
        type: widget.model.kostType,
        price: widget.model.totalPrice);
    await KostDatabase.instance.create(kost_fav);
  }

  @override
  void initState() {
    // if (BookmarkList.bookmarkItems.contains(widget.model) == true) {
    //   setState(() {
    //     _iconColor = ColorValues.primaryPurple;
    //   });
    // }
    super.initState();
    getDetailKost();
  }

  @override
  Widget build(BuildContext context) {
    return _isLoad
        ? SafeArea(child: Scaffold(body: LoadingAnimation()))
        : _isLogin
            ? SafeArea(
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (context, scrolling) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverAppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: Colors.transparent,
                            expandedHeight: 250.h,
                            forceElevated: scrolling,
                            flexibleSpace:
                                FlexibleSpaceBar(background: detailAppbar()),
                          ),
                        ),
                      ];
                    },
                    body: ListView(
                      children: [
                        detailHeader(),
                        detailFasilitas(),
                        detailPeraturan(),
                        fotoKostWidget(),
                        mapKost(),
                        pemilikKost(),
                        commentRatingUser(),
                        comment(),
                        SizedBox(height: 25.h),
                        sewaButton(),
                      ],
                    ),
                  ),
                ),
              )
            : SafeArea(
                child: Scaffold(
                  body: NestedScrollView(
                    headerSliverBuilder: (context, scrolling) {
                      return <Widget>[
                        SliverOverlapAbsorber(
                          handle:
                              NestedScrollView.sliverOverlapAbsorberHandleFor(
                                  context),
                          sliver: SliverAppBar(
                            automaticallyImplyLeading: false,
                            backgroundColor: Colors.transparent,
                            expandedHeight: 250.h,
                            forceElevated: scrolling,
                            flexibleSpace:
                                FlexibleSpaceBar(background: detailAppbar()),
                          ),
                        ),
                      ];
                    },
                    body: ListView(
                      children: [
                        detailHeader(),
                        detailFasilitas(),
                        detailPeraturan(),
                        fotoKostWidget(),
                        mapKost(),
                        pemilikKost(),
                        comment(),
                        SizedBox(height: 25.h),
                        sewaButton(),
                      ],
                    ),
                  ),
                ),
              );
  }

  detailAppbar() {
    return Stack(
      children: [
        Image.network(widget.model.coverImg,
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        Positioned(
            top: 25,
            left: 20,
            child: CircleAvatar(
              backgroundColor: ColorValues.primaryBlue,
              child: IconButton(
                onPressed: () {
                  SharedCode.navigatorPop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )),
      ],
    );
  }

  detailFasilitas() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Fasilitas Kamar",
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
            SizedBox(
              height: 100.h,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                itemCount: 3,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        if (dataFasilitas![index][0].name == "Bantal")
                          Expanded(
                              child: SvgPicture.asset("assets/icon/Pillow.svg"))
                        else if (dataFasilitas![index][0].name == "Kasur")
                          Expanded(
                              child: SvgPicture.asset("assets/icon/Bed.svg"))
                        else if (dataFasilitas![index][0].name == "Lemari")
                          Expanded(
                              child:
                                  SvgPicture.asset("assets/icon/Cupboard.svg"))
                        else if (dataFasilitas![index][0].name == "Meja")
                          Expanded(
                              child: SvgPicture.asset("assets/icon/Table.svg"))
                        else if (dataFasilitas![index][0].name == "Kursi")
                          Expanded(
                              child: SvgPicture.asset("assets/icon/Chair.svg"))
                        else if (dataFasilitas![index][0].name == "Kipas" ||
                            dataFasilitas![index][0].name == "AC")
                          Expanded(
                              child: SvgPicture.asset("assets/icon/Fan.svg"))
                        else if (dataFasilitas![index][0].name == "Dalam" ||
                            dataFasilitas![index][0].name == "Luar")
                          Expanded(
                              child: SvgPicture.asset("assets/icon/Toilet.svg",
                                  height: 20.h)),
                        Expanded(
                            flex: 7,
                            child: Text(dataFasilitas![index][0].name)),
                      ],
                    ),
                  );
                },
              ),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 1, color: ColorValues.primaryPurple),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(0.w, 30.h),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => buildSheet(),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lihat Fasilitas',
                        style: GoogleFonts.inter(fontSize: 12)),
                    Icon(Icons.double_arrow_rounded, size: 20)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  buildSheet() {
    return makeDismissible(
      child: DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.3,
          maxChildSize: 0.7,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: EdgeInsets.all(20),
              child: ListView(
                controller: controller,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text("Fasilitas Kamar",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Text(
                      dataDetailKost!.kostName +
                          "\n" +
                          dataDetailKost!.location,
                      style: GoogleFonts.roboto()),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text("Spesifikasi Kamar",
                        style: GoogleFonts.roboto(fontSize: 17)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Cube.svg")),
                        Expanded(
                            flex: 7,
                            child: Text(dataDetailKost!.width +
                                " X " +
                                dataDetailKost!.weight +
                                " Meter")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                SvgPicture.asset("assets/icon/Electric.svg")),
                        Expanded(
                            flex: 7,
                            child: Text(dataDetailKost!.elecPrice == "0"
                                ? "Termasuk Listrik"
                                : "Tidak Termasuk Listrik")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: DottedLine(dashColor: Colors.black),
                  ),
                  Text("Fasilitas", style: GoogleFonts.roboto(fontSize: 17)),
                  SizedBox(height: 8.h),
                  ListView.builder(
                    shrinkWrap: true,
                    itemCount: dataFasilitas!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Row(
                          children: [
                            if (dataFasilitas![index][0].name == "Bantal")
                              Expanded(
                                  child: SvgPicture.asset(
                                      "assets/icon/Pillow.svg"))
                            else if (dataFasilitas![index][0].name == "Kasur")
                              Expanded(
                                  child:
                                      SvgPicture.asset("assets/icon/Bed.svg"))
                            else if (dataFasilitas![index][0].name == "Lemari")
                              Expanded(
                                  child: SvgPicture.asset(
                                      "assets/icon/Cupboard.svg"))
                            else if (dataFasilitas![index][0].name == "Meja")
                              Expanded(
                                  child:
                                      SvgPicture.asset("assets/icon/Table.svg"))
                            else if (dataFasilitas![index][0].name == "Kursi")
                              Expanded(
                                  child:
                                      SvgPicture.asset("assets/icon/Chair.svg"))
                            else if (dataFasilitas![index][0].name == "Kipas" ||
                                dataFasilitas![index][0].name == "AC")
                              Expanded(
                                  child:
                                      SvgPicture.asset("assets/icon/Fan.svg"))
                            else if (dataFasilitas![index][0].name == "Dalam" ||
                                dataFasilitas![index][0].name == "Luar")
                              Expanded(
                                  child: SvgPicture.asset(
                                      "assets/icon/Toilet.svg",
                                      height: 20.h)),
                            Expanded(
                                flex: 7,
                                child: Text(dataFasilitas![index][0].name)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          }),
    );
  }

  // buildUlasanComment() {
  //   return makeDismissible(
  //     child: StatefulBuilder(
  //       builder: (context, setState) {
  //         Future createComment() async {
  //           SharedPreferences pref = await SharedPreferences.getInstance();
  //           setState(() {
  //             _isRefresh = true;
  //           });
  //           LoginModel result_log = await ApiService().getLogin(
  //               email: pref.getString("email_user").toString(),
  //               password: pref.getString("pass_user").toString());
  //           await ApiService().createComment(
  //               token: result_log.token,
  //               kost_id: widget.idKost,
  //               user_id: result_log.data.id.toString(),
  //               comment_body: commentController.text,
  //               rating: "0");
  //           await getComment();
  //           setState(() {
  //             _isRefresh = false;
  //           });
  //         }
  //
  //         return DraggableScrollableSheet(
  //             initialChildSize: 0.8,
  //             minChildSize: 0.3,
  //             maxChildSize: 0.8,
  //             builder: (_, controller) {
  //               return Container(
  //                 decoration: BoxDecoration(
  //                   color: Colors.white,
  //                   borderRadius:
  //                       BorderRadius.vertical(top: Radius.circular(20)),
  //                   boxShadow: [
  //                     BoxShadow(
  //                       color: Colors.grey,
  //                       spreadRadius: 5,
  //                       blurRadius: 10,
  //                     ),
  //                   ],
  //                 ),
  //                 padding: EdgeInsets.only(left: 20, right: 20, top: 20),
  //                 child: _isRefresh
  //                     ? LoadingAnimation()
  //                     : Column(
  //                         mainAxisAlignment: MainAxisAlignment.start,
  //                         crossAxisAlignment: CrossAxisAlignment.start,
  //                         children: [
  //                           Text("Ulasan Penyewa",
  //                               style: GoogleFonts.roboto(
  //                                   fontSize: 20, fontWeight: FontWeight.bold)),
  //                           Padding(
  //                             padding: EdgeInsets.symmetric(vertical: 5),
  //                             child: Row(
  //                               children: [
  //                                 Icon(Icons.star,
  //                                     color: ColorValues.primaryPurple,
  //                                     size: 12),
  //                                 SizedBox(width: 3),
  //                                 Text(dataDetailKost!.rating.toString(),
  //                                     style: GoogleFonts.roboto(fontSize: 12)),
  //                                 SizedBox(width: 3),
  //                                 Icon(Icons.circle,
  //                                     size: 6, color: Colors.grey[400]),
  //                                 // SizedBox(width: 3),
  //                                 // Text(
  //                                 //   "(" + "143" + " Ulasan)",
  //                                 //   style: GoogleFonts.roboto(
  //                                 //       fontSize: 12, color: Colors.grey[600]),
  //                                 // ),
  //                               ],
  //                             ),
  //                           ),
  //                           Text(dataDetailKost!.location,
  //                               style: GoogleFonts.roboto(
  //                                   fontWeight: FontWeight.bold)),
  //                           dataComment!.isEmpty
  //                               ? Expanded(
  //                                   child: Column(
  //                                     crossAxisAlignment:
  //                                         CrossAxisAlignment.center,
  //                                     mainAxisAlignment:
  //                                         MainAxisAlignment.center,
  //                                     children: [
  //                                       Center(
  //                                         child: Lottie.asset(
  //                                           'assets/lottie/not_found.json',
  //                                           width: 175.w,
  //                                           repeat: false,
  //                                         ),
  //                                       ),
  //                                       Center(
  //                                         child: Text(
  //                                           'Belum ada Komen yang tertulis',
  //                                           style: Theme.of(context)
  //                                               .textTheme
  //                                               .headline3!
  //                                               .copyWith(
  //                                                 fontSize: 15,
  //                                                 color: Color(0XFF9B9B9B),
  //                                                 fontWeight: FontWeight.w500,
  //                                               ),
  //                                         ),
  //                                       ),
  //                                     ],
  //                                   ),
  //                                 )
  //                               : Expanded(
  //                                   child: Padding(
  //                                     padding: EdgeInsets.only(top: 15),
  //                                     child: ListView.builder(
  //                                         shrinkWrap: true,
  //                                         itemCount: dataComment!.length,
  //                                         controller: controller,
  //                                         itemBuilder: (BuildContext context,
  //                                             int index) {
  //                                           return Padding(
  //                                             padding: EdgeInsets.symmetric(
  //                                                 vertical: 8),
  //                                             child: Row(
  //                                               children: [
  //                                                 Image.asset(
  //                                                     "assets/icon/photo_profile.png",
  //                                                     width: 50.w),
  //                                                 Expanded(
  //                                                   child: Column(
  //                                                     mainAxisSize:
  //                                                         MainAxisSize.min,
  //                                                     mainAxisAlignment:
  //                                                         MainAxisAlignment
  //                                                             .start,
  //                                                     crossAxisAlignment:
  //                                                         CrossAxisAlignment
  //                                                             .start,
  //                                                     children: [
  //                                                       Text(
  //                                                           dataComment![index]
  //                                                               .user
  //                                                               .name,
  //                                                           style: GoogleFonts.roboto(
  //                                                               fontSize: 12,
  //                                                               fontWeight:
  //                                                                   FontWeight
  //                                                                       .bold)),
  //                                                       Row(
  //                                                         mainAxisSize:
  //                                                             MainAxisSize.min,
  //                                                         mainAxisAlignment:
  //                                                             MainAxisAlignment
  //                                                                 .start,
  //                                                         crossAxisAlignment:
  //                                                             CrossAxisAlignment
  //                                                                 .start,
  //                                                         children: [
  //                                                           Icon(Icons.star,
  //                                                               color: ColorValues
  //                                                                   .primaryPurple,
  //                                                               size: 11),
  //                                                           SizedBox(width: 3),
  //                                                           Text(
  //                                                               dataComment![
  //                                                                       index]
  //                                                                   .rating
  //                                                                   .toString(),
  //                                                               style: GoogleFonts
  //                                                                   .roboto(
  //                                                                       fontSize:
  //                                                                           12)),
  //                                                           SizedBox(width: 3),
  //                                                           Padding(
  //                                                             padding: EdgeInsets
  //                                                                 .only(top: 3),
  //                                                             child: Icon(
  //                                                                 Icons.circle,
  //                                                                 size: 6,
  //                                                                 color: Colors
  //                                                                         .grey[
  //                                                                     400]),
  //                                                           ),
  //                                                           SizedBox(width: 3),
  //                                                           Text(
  //                                                               DateFormat(
  //                                                                       'yy/MM/d HH:mm')
  //                                                                   .format(dataComment![
  //                                                                           index]
  //                                                                       .createdAt),
  //                                                               style: GoogleFonts
  //                                                                   .roboto(
  //                                                                       fontSize:
  //                                                                           11)),
  //                                                         ],
  //                                                       ),
  //                                                       Text(
  //                                                           dataComment![index]
  //                                                               .commentBody,
  //                                                           style: GoogleFonts
  //                                                               .roboto(
  //                                                                   fontSize:
  //                                                                       12)),
  //                                                     ],
  //                                                   ),
  //                                                 ),
  //                                               ],
  //                                             ),
  //                                           );
  //                                         }),
  //                                   ),
  //                                 ),
  //                         ],
  //                       ),
  //               );
  //             });
  //       },
  //     ),
  //   );
  // }

  buildUlasan() {
    return makeDismissible(
      child: StatefulBuilder(
        builder: (context, setState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.8,
              minChildSize: 0.3,
              maxChildSize: 0.8,
              builder: (_, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(20)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 5,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  padding: EdgeInsets.only(left: 20, right: 20, top: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Ulasan Penyewa",
                          style: GoogleFonts.roboto(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 5),
                        child: Row(
                          children: [
                            Icon(Icons.star,
                                color: ColorValues.primaryPurple, size: 12),
                            SizedBox(width: 3),
                            Text(dataDetailKost!.rating.toString(),
                                style: GoogleFonts.roboto(fontSize: 12)),
                            SizedBox(width: 3),
                            Icon(Icons.circle,
                                size: 6, color: Colors.grey[400]),
                            // SizedBox(width: 3),
                            // Text(
                            //   "(" + "143" + " Ulasan)",
                            //   style: GoogleFonts.roboto(
                            //       fontSize: 12, color: Colors.grey[600]),
                            // ),
                          ],
                        ),
                      ),
                      Text(dataDetailKost!.location,
                          style:
                              GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                      dataComment!.isEmpty
                          ? Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Lottie.asset(
                                      'assets/lottie/not_found.json',
                                      width: 175.w,
                                      repeat: false,
                                    ),
                                  ),
                                  Center(
                                    child: Text(
                                      'Belum ada Komen yang tertulis',
                                      style: Theme.of(context)
                                          .textTheme
                                          .headline3!
                                          .copyWith(
                                            fontSize: 15,
                                            color: Color(0XFF9B9B9B),
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(top: 15),
                                child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: dataComment!.length,
                                    controller: controller,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 8),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: EdgeInsets.all(8.0),
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0XFFE7E7E7),
                                                radius: 20,
                                                backgroundImage: NetworkImage(
                                                    dataComment![index]
                                                        .user
                                                        .pfp),
                                              ),
                                            ),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                      dataComment![index]
                                                          .user
                                                          .name,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 12,
                                                          fontWeight:
                                                              FontWeight.bold)),
                                                  Row(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Icon(Icons.star,
                                                          color: ColorValues
                                                              .primaryPurple,
                                                          size: 11),
                                                      SizedBox(width: 3),
                                                      Text(
                                                          dataComment![index]
                                                              .rating
                                                              .toString(),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize:
                                                                      12)),
                                                      SizedBox(width: 3),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                top: 3),
                                                        child: Icon(
                                                            Icons.circle,
                                                            size: 6,
                                                            color: Colors
                                                                .grey[400]),
                                                      ),
                                                      SizedBox(width: 3),
                                                      Text(
                                                          DateFormat(
                                                                  'yy/MM/d HH:mm')
                                                              .format(
                                                                  dataComment![
                                                                          index]
                                                                      .createdAt),
                                                          style: GoogleFonts
                                                              .roboto(
                                                                  fontSize:
                                                                      11)),
                                                    ],
                                                  ),
                                                  Text(
                                                      dataComment![index]
                                                          .commentBody,
                                                      style: GoogleFonts.roboto(
                                                          fontSize: 12)),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    }),
                              ),
                            ),
                    ],
                  ),
                );
              });
        },
      ),
    );
  }

  makeDismissible({required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SharedCode.navigatorPop(context);
      },
      child: GestureDetector(onTap: () {}, child: child),
    );
  }

  detailPeraturan() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text(
                "Peraturan Kamar",
                style: GoogleFonts.roboto(fontSize: 20),
              ),
            ),
            Container(
              decoration: BoxDecoration(),
              child: Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataRoomRule!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 4,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              dataRoomRule![index].content,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text("Peraturan Kost",
                  style: GoogleFonts.roboto(fontSize: 20)),
            ),
            Container(
              decoration: BoxDecoration(),
              child: Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: dataKostRule!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: <Widget>[
                          CircleAvatar(
                            backgroundColor: Colors.black,
                            radius: 4,
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Text(
                              dataKostRule![index].content,
                              style: TextStyle(fontSize: 16.0),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  detailHeader() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(dataDetailKost!.kostName,
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w500)),
                IconButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      if (pref.getString("token_user") == null &&
                          user == null) {
                        SharedCode.navigatorPush(context, RolePage());
                      } else if (user != null) {
                        await addNote();
                        setState(() {
                          _iconColor = ColorValues.primaryPurple;
                        });
                      } else {
                        await addNote();
                        setState(() {
                          _iconColor = ColorValues.primaryPurple;
                        });
                      }
                    },
                    icon: Icon(Icons.bookmark, color: _iconColor))
              ],
            ),
            Row(
              children: [
                DottedBorder(
                  color: Colors.black,
                  strokeWidth: 1,
                  child: Padding(
                    padding: EdgeInsets.all(3),
                    child: Text(dataDetailKost!.kostType,
                        style: GoogleFonts.roboto(fontSize: 13)),
                  ),
                ),
                SizedBox(width: 15.w),
                Icon(Icons.location_on_rounded, size: 15),
                SizedBox(width: 7.w),
                Expanded(
                  child: Text(dataDetailKost!.location,
                      style: GoogleFonts.inter(fontSize: 12)),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(Icons.star, color: ColorValues.primaryPurple, size: 20),
                  SizedBox(width: 5.w),
                  Text(dataDetailKost!.rating.toString() +
                      " (" +
                      dataComment!.length.toString() +
                      ")")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  pemilikKost() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pemilik Kost",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            Row(
              children: [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Color(0XFFE7E7E7),
                    radius: 25,
                    backgroundImage: NetworkImage(dataDetailKost!.user.pfp),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pemilikkost,
                        style: GoogleFonts.roboto(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text(
                        "Bergabung " +
                            DateFormat('dd MMM yyyy')
                                .format(dataDetailKost!.user.createdAt),
                        style: GoogleFonts.roboto(fontSize: 12)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text("Info Tambahan",
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 5.h),
            Text(dataDetailKost!.desc, style: GoogleFonts.roboto(fontSize: 13)),
            SizedBox(height: 10.h),
            widgetChat
          ],
        ),
      ),
    );
  }

  commentRatingUser() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Rating Kos ini",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            Center(
              child: RatingBar(
                itemPadding: EdgeInsets.all(15),
                itemCount: 5,
                itemSize: 30.w,
                allowHalfRating: true,
                ratingWidget: RatingWidget(
                  full: Icon(
                    Icons.star,
                    color: ColorValues.primaryPurple,
                  ),
                  half: Icon(
                    Icons.star_half,
                    color: ColorValues.primaryPurple,
                  ),
                  empty: Icon(
                    Icons.star_border,
                    color: ColorValues.primaryPurple,
                  ),
                ),
                onRatingUpdate: (rating) {
                  setState(() {
                    rate = rating;
                  });
                  print(rate);
                },
              ),
            ),
            rate == null
                ? Container()
                : Row(
                    children: [
                      Expanded(
                        flex: 4,
                        child: CustomTextFormField(
                          label: 'Ketikkan seusatu',
                          controller: commentController,
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
                              EdgeInsets.all(10),
                            ),
                            backgroundColor: MaterialStateProperty.all(
                              ColorValues.primaryBlue,
                            ),
                          ),
                          onPressed: () async {
                            await createComment();
                            commentController.clear();
                          },
                          child: Icon(Icons.send, size: 20),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  comment() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ulasan Penyewa",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            dataComment!.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset(
                          'assets/lottie/not_found.json',
                          width: 125.w,
                          repeat: false,
                        ),
                        Text(
                          'Belum ada Komen yang tertulis',
                          style:
                              Theme.of(context).textTheme.headline3!.copyWith(
                                    fontSize: 15,
                                    color: Color(0XFF9B9B9B),
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "(" + dataComment!.length.toString() + " Ulasan)",
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Colors.grey[600]),
                      ),
                      listviewTopUlasan(),
                    ],
                  ),
            GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => buildUlasan(),
                );
                // SharedPreferences pref = await SharedPreferences.getInstance();
                // if (pref.getString("token_user") == null && user == null) {
                //   showModalBottomSheet(
                //     backgroundColor: Colors.transparent,
                //     isScrollControlled: true,
                //     context: context,
                //     builder: (context) => buildUlasan(),
                //   );
                // } else if (user != null) {
                //   showModalBottomSheet(
                //     backgroundColor: Colors.transparent,
                //     isScrollControlled: true,
                //     context: context,
                //     builder: (context) => buildUlasanComment(),
                //   );
                // } else {
                //   showModalBottomSheet(
                //     backgroundColor: Colors.transparent,
                //     isScrollControlled: true,
                //     context: context,
                //     builder: (context) => buildUlasanComment(),
                //   );
                // }
              },
              child: Center(
                child: Column(
                  children: [
                    Text("Lihat semua ulasan",
                        style: GoogleFonts.roboto(fontSize: 12)),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: ColorValues.primaryPurple,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  listviewTopUlasan() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Container(
        height: 125.h,
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: dataComment!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircleAvatar(
                        backgroundColor: Color(0XFFE7E7E7),
                        radius: 20,
                        backgroundImage:
                            NetworkImage(dataComment![index].user.pfp),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dataComment![index].user.name,
                              style: GoogleFonts.roboto(
                                  fontSize: 12, fontWeight: FontWeight.bold)),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.star,
                                  color: ColorValues.primaryPurple, size: 12),
                              SizedBox(width: 3),
                              Text(dataComment![index].rating.toString(),
                                  style: GoogleFonts.roboto(fontSize: 11)),
                              SizedBox(width: 3),
                              Padding(
                                padding: EdgeInsets.only(top: 3),
                                child: Icon(Icons.circle,
                                    size: 6, color: Colors.grey[400]),
                              ),
                              SizedBox(width: 3),
                              Text(
                                  DateFormat('yy/MM/d HH:mm')
                                      .format(dataComment![index].createdAt),
                                  style: GoogleFonts.roboto(fontSize: 11)),
                            ],
                          ),
                          SizedBox(height: 2.h),
                          Text(dataComment![index].commentBody,
                              style: GoogleFonts.roboto(fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
      ),
    );
  }

  sewaButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 5, // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Rp. " + dataDetailKost!.roomPrice.toString() + " / Bulan",
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorValues.primaryBlue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(0.w, 40.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    if (pref.getString("token_user") == null && user == null) {
                      SharedCode.navigatorPush(context, RolePage());
                    } else if (user != null) {
                      _showDialog(context);
                    } else {
                      _showDialog(context);
                      print("APPS LOGIN");
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Sewa Kamar',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(width: 5.w),
                      Icon(CupertinoIcons.shopping_cart)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future _showDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogDates(idKost: widget.idKost, model: widget.model);
      },
    );
  }

  mapKost() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child:
                  Text("Lokasi Kost", style: GoogleFonts.roboto(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.location_pin),
                  Expanded(
                      child: Text(dataDetailKost!.location,
                          style: GoogleFonts.roboto())),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 1, color: ColorValues.primaryPurple),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(double.infinity, 40.h)),
                  onPressed: () {
                    _launchUrl();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Click sini untuk liat lokasi kost',
                          style: GoogleFonts.inter(fontSize: 13)),
                      SizedBox(width: 10.w),
                      Icon(CupertinoIcons.location_solid, size: 17)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  fotoKostWidget() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child:
                  Text("Preview Kost", style: GoogleFonts.roboto(fontSize: 20)),
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 1, color: ColorValues.primaryPurple),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(double.infinity, 40.h)),
                  onPressed: () {
                    _showImage(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Click disini untuk melihat foto kamar',
                          style: GoogleFonts.inter(fontSize: 13)),
                      SizedBox(width: 8.w),
                      Icon(CupertinoIcons.photo, size: 17)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  chatButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            side: BorderSide(width: 1, color: ColorValues.primaryPurple),
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            minimumSize: Size(0.w, 30.h),
          ),
          onPressed: () async {
            await createChatRoom();
            await SharedCode.navigatorPush(
                context, ChatWidgetUser(idRoom: widget.idKost));
          },
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Tanya Pemilik Kost',
                  style: GoogleFonts.inter(fontSize: 12)),
              SizedBox(width: 5.w),
              Icon(CupertinoIcons.chat_bubble_text_fill, size: 17)
            ],
          )),
    );
  }

  Future _showImage(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogImage(idKost: widget.idKost);
      },
    );
  }

  Future<void> _launchUrl() async {
    Uri _url = Uri.parse(dataDetailKost!.locationUrl);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
