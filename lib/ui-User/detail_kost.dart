import 'package:carousel_slider/carousel_slider.dart';
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
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/db_helper.dart';
import 'package:project_anakkos_app/model/comment_model.dart';
import 'package:project_anakkos_app/model/db_model/kost_model.dart';
import 'package:project_anakkos_app/model/detail_kost_user_model.dart';
import 'package:project_anakkos_app/model/image_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/model/kost_room_rule_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/model/show_fasilitas_kost_model.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_dates.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_image.dart';
import 'package:project_anakkos_app/widget/chat_widget/chatWidget_user.dart';
import 'package:project_anakkos_app/widget/custom_text_form.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailKost extends StatefulWidget {
  final KostbyLocationData model;
  final String idKost;
  const DetailKost({Key? key, required this.model, required this.idKost})
      : super(key: key);

  @override
  State<DetailKost> createState() => _DetailKostState();
}

class _DetailKostState extends State<DetailKost> {
  TextEditingController commentController = TextEditingController();
  Color _iconColor = Colors.grey;
  String pemilikkost = "";
  final user = FirebaseAuth.instance.currentUser;
  DetailKostUserData? dataDetailKost;
  List<CommentData>? dataComment;
  bool _isLoad = true;
  bool _isLogin = false;
  List<List<FasilitasKostData>>? dataFasilitas;
  List<ImageData>? dataImage;
  double? rate;
  List<KostRoomRuleData>? dataRoomRule;
  List<KostRoomRuleData>? dataKostRule;
  Widget widgetChat = Container();
  int activeIndex = 0;

  Future getImage() async {
    ImageModel _resImg =
        await ApiService().getImageRoom(kost_id: widget.idKost);
    setState(() {
      dataImage = _resImg.data;
    });
  }

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
    await getImage();
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
                  backgroundColor: Color(0xFFECECEC),
                  body: ListView(
                    children: [
                      detailHeader(),
                      SizedBox(height: 15.h),
                      fotoKostWidget(),
                      SizedBox(height: 15.h),
                      detailFasilitas(),
                      SizedBox(height: 15.h),
                      detailPeraturan(),
                      SizedBox(height: 15.h),
                      mapKost(),
                      SizedBox(height: 15.h),
                      commentRatingUser(),
                      SizedBox(height: 15.h),
                      comment(),
                      SizedBox(height: 25.h),
                      sewaButton(),
                    ],
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
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
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Cube.svg")),
                Expanded(
                    flex: 7,
                    child: Text(
                        dataDetailKost!.width +
                            " X " +
                            dataDetailKost!.weight +
                            " Meter",
                        style: TextStyle(fontSize: 15))),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Electric.svg")),
                Expanded(
                    flex: 7,
                    child: Text(
                        dataDetailKost!.elecPrice == "0"
                            ? "Termasuk Listrik"
                            : "Tidak Termasuk Listrik",
                        style: TextStyle(fontSize: 15))),
              ],
            ),
          ),
          SizedBox(height: 15.h),
          GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: (1 / .3),
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            shrinkWrap: true,
            itemCount: dataFasilitas!.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                  decoration: BoxDecoration(
                      color: Color(0xFF6E6E77),
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: Row(
                    children: [
                      if (dataFasilitas![index][0].name == "Bantal")
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Pillow.svg",
                                color: Colors.white))
                      else if (dataFasilitas![index][0].name == "Kasur")
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Bed.svg",
                                color: Colors.white))
                      else if (dataFasilitas![index][0].name == "Lemari")
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Cupboard.svg",
                                color: Colors.white))
                      else if (dataFasilitas![index][0].name == "Meja")
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Table.svg",
                                color: Colors.white))
                      else if (dataFasilitas![index][0].name == "Kursi")
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Chair.svg",
                                color: Colors.white))
                      else if (dataFasilitas![index][0].name == "Kipas" ||
                          dataFasilitas![index][0].name == "AC")
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Fan.svg",
                                color: Colors.white))
                      else if (dataFasilitas![index][0].name == "Dalam" ||
                          dataFasilitas![index][0].name == "Luar")
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Toilet.svg",
                                color: Colors.white, height: 20.h)),
                      Expanded(
                          child: Text(
                        dataFasilitas![index][0].name,
                        style: GoogleFonts.inter(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      )),
                    ],
                  ));
            },
          ),
          // ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       side: BorderSide(width: 1, color: ColorValues.primaryPurple),
          //       backgroundColor: Colors.white,
          //       foregroundColor: Colors.black,
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(10)),
          //       minimumSize: Size(0.w, 30.h),
          //     ),
          //     onPressed: () {
          //       showModalBottomSheet(
          //         backgroundColor: Colors.transparent,
          //         isScrollControlled: true,
          //         context: context,
          //         builder: (context) => buildSheet(),
          //       );
          //     },
          //     child: Row(
          //       mainAxisSize: MainAxisSize.min,
          //       children: [
          //         Text('Lihat Fasilitas',
          //             style: GoogleFonts.inter(fontSize: 12)),
          //         Icon(Icons.double_arrow_rounded, size: 20)
          //       ],
          //     ))
        ],
      ),
    );
  }

  // buildSheet() {
  //   return makeDismissible(
  //     child: DraggableScrollableSheet(
  //         initialChildSize: 0.7,
  //         minChildSize: 0.3,
  //         maxChildSize: 0.7,
  //         builder: (_, controller) {
  //           return Container(
  //             decoration: BoxDecoration(
  //               color: Colors.white,
  //               borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
  //               boxShadow: [
  //                 BoxShadow(
  //                   color: Colors.grey,
  //                   spreadRadius: 5,
  //                   blurRadius: 10,
  //                 ),
  //               ],
  //             ),
  //             padding: EdgeInsets.all(20),
  //             child: ListView(
  //               controller: controller,
  //               children: [
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 6),
  //                   child: Text("Fasilitas Kamar",
  //                       style: GoogleFonts.roboto(
  //                           fontWeight: FontWeight.bold, fontSize: 20)),
  //                 ),
  //                 Text(
  //                     dataDetailKost!.kostName +
  //                         "\n" +
  //                         dataDetailKost!.location,
  //                     style: GoogleFonts.roboto()),
  //                 Padding(
  //                   padding: EdgeInsets.only(top: 25),
  //                   child: Text("Spesifikasi Kamar",
  //                       style: GoogleFonts.roboto(fontSize: 17)),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 12),
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                           child: SvgPicture.asset("assets/icon/Cube.svg")),
  //                       Expanded(
  //                           flex: 7,
  //                           child: Text(dataDetailKost!.width +
  //                               " X " +
  //                               dataDetailKost!.weight +
  //                               " Meter")),
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 4),
  //                   child: Row(
  //                     children: [
  //                       Expanded(
  //                           child:
  //                               SvgPicture.asset("assets/icon/Electric.svg")),
  //                       Expanded(
  //                           flex: 7,
  //                           child: Text(dataDetailKost!.elecPrice == "0"
  //                               ? "Termasuk Listrik"
  //                               : "Tidak Termasuk Listrik")),
  //                     ],
  //                   ),
  //                 ),
  //                 Padding(
  //                   padding: EdgeInsets.symmetric(vertical: 12),
  //                   child: DottedLine(dashColor: Colors.black),
  //                 ),
  //                 Text("Fasilitas", style: GoogleFonts.roboto(fontSize: 17)),
  //                 SizedBox(height: 8.h),
  //                 ListView.builder(
  //                   shrinkWrap: true,
  //                   itemCount: dataFasilitas!.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     return Padding(
  //                       padding: EdgeInsets.symmetric(vertical: 10),
  //                       child: Row(
  //                         children: [
  //                           if (dataFasilitas![index][0].name == "Bantal")
  //                             Expanded(
  //                                 child: SvgPicture.asset(
  //                                     "assets/icon/Pillow.svg"))
  //                           else if (dataFasilitas![index][0].name == "Kasur")
  //                             Expanded(
  //                                 child:
  //                                     SvgPicture.asset("assets/icon/Bed.svg"))
  //                           else if (dataFasilitas![index][0].name == "Lemari")
  //                             Expanded(
  //                                 child: SvgPicture.asset(
  //                                     "assets/icon/Cupboard.svg"))
  //                           else if (dataFasilitas![index][0].name == "Meja")
  //                             Expanded(
  //                                 child:
  //                                     SvgPicture.asset("assets/icon/Table.svg"))
  //                           else if (dataFasilitas![index][0].name == "Kursi")
  //                             Expanded(
  //                                 child:
  //                                     SvgPicture.asset("assets/icon/Chair.svg"))
  //                           else if (dataFasilitas![index][0].name == "Kipas" ||
  //                               dataFasilitas![index][0].name == "AC")
  //                             Expanded(
  //                                 child:
  //                                     SvgPicture.asset("assets/icon/Fan.svg"))
  //                           else if (dataFasilitas![index][0].name == "Dalam" ||
  //                               dataFasilitas![index][0].name == "Luar")
  //                             Expanded(
  //                                 child: SvgPicture.asset(
  //                                     "assets/icon/Toilet.svg",
  //                                     height: 20.h)),
  //                           Expanded(
  //                               flex: 7,
  //                               child: Text(dataFasilitas![index][0].name)),
  //                         ],
  //                       ),
  //                     );
  //                   },
  //                 ),
  //               ],
  //             ),
  //           );
  //         }),
  //   );
  // }

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
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.all(15),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text("Ulasan Penyewa",
                                  style: GoogleFonts.roboto(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(width: 63.w),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 2,
                                      blurRadius:
                                          5, // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: Colors.white,
                                  child: IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.black, size: 17),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 578.h,
                          color: Color(0xFFEFEFEF),
                          child: Padding(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                        dataComment!.length.toString() +
                                            " Ulasan",
                                        style:
                                            GoogleFonts.roboto(fontSize: 17)),
                                    SizedBox(width: 25.w),
                                    Icon(Icons.star,
                                        color: Colors.yellow.shade700,
                                        size: 20),
                                    SizedBox(width: 5.w),
                                    Text(dataDetailKost!.rating.toString(),
                                        style:
                                            GoogleFonts.roboto(fontSize: 17)),
                                    // SizedBox(width: 3),
                                    // Text(
                                    //   "(" + "143" + " Ulasan)",
                                    //   style: GoogleFonts.roboto(
                                    //       fontSize: 12, color: Colors.grey[600]),
                                    // ),
                                  ],
                                ),
                                SizedBox(height: 5.h),
                                dataComment!.isEmpty
                                    ? Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                      )
                                    : ListView.builder(
                                        physics: NeverScrollableScrollPhysics(),
                                        shrinkWrap: true,
                                        itemCount: dataComment!.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Padding(
                                            padding: EdgeInsets.symmetric(
                                                vertical: 8),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(12)),
                                              ),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Color(0XFFE7E7E7),
                                                  radius: 20,
                                                  backgroundImage: NetworkImage(
                                                      dataComment![index]
                                                          .user
                                                          .pfp),
                                                ),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                        dataComment![index]
                                                            .user
                                                            .name,
                                                        style:
                                                            GoogleFonts.roboto(
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold)),
                                                    Row(
                                                      children: [
                                                        Icon(Icons.star,
                                                            color: Colors.yellow
                                                                .shade700),
                                                        SizedBox(width: 2.w),
                                                        Text(
                                                            dataComment![index]
                                                                .rating,
                                                            style: GoogleFonts
                                                                .roboto(
                                                                    color: Colors
                                                                        .black,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontSize:
                                                                        12)),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                                subtitle: Text(
                                                    dataComment![index]
                                                        .commentBody,
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 13)),
                                              ),
                                            ),
                                          );
                                          //   Padding(
                                          //   padding: EdgeInsets.symmetric(vertical: 8),
                                          //   child: Row(
                                          //     children: [
                                          //       Padding(
                                          //         padding: EdgeInsets.all(8.0),
                                          //         child: CircleAvatar(
                                          //           backgroundColor: Color(0XFFE7E7E7),
                                          //           radius: 20,
                                          //           backgroundImage:
                                          //               NetworkImage(dataComment![index].user.pfp),
                                          //         ),
                                          //       ),
                                          //       Expanded(
                                          //         child: Column(
                                          //           mainAxisSize: MainAxisSize.min,
                                          //           mainAxisAlignment: MainAxisAlignment.start,
                                          //           crossAxisAlignment: CrossAxisAlignment.start,
                                          //           children: [
                                          //             Text(dataComment![index].user.name,
                                          //                 style: GoogleFonts.roboto(
                                          //                     fontSize: 12, fontWeight: FontWeight.bold)),
                                          //             Row(
                                          //               mainAxisSize: MainAxisSize.min,
                                          //               mainAxisAlignment: MainAxisAlignment.start,
                                          //               crossAxisAlignment: CrossAxisAlignment.start,
                                          //               children: [
                                          //                 Icon(Icons.star,
                                          //                     color: ColorValues.primaryPurple, size: 12),
                                          //                 SizedBox(width: 3),
                                          //                 Text(dataComment![index].rating.toString(),
                                          //                     style: GoogleFonts.roboto(fontSize: 11)),
                                          //                 SizedBox(width: 3),
                                          //                 Padding(
                                          //                   padding: EdgeInsets.only(top: 3),
                                          //                   child: Icon(Icons.circle,
                                          //                       size: 6, color: Colors.grey[400]),
                                          //                 ),
                                          //                 SizedBox(width: 3),
                                          //                 Text(
                                          //                     DateFormat('yy/MM/d HH:mm')
                                          //                         .format(dataComment![index].createdAt),
                                          //                     style: GoogleFonts.roboto(fontSize: 11)),
                                          //               ],
                                          //             ),
                                          //             SizedBox(height: 2.h),
                                          //             Text(dataComment![index].commentBody,
                                          //                 style: GoogleFonts.roboto(fontSize: 12)),
                                          //           ],
                                          //         ),
                                          //       ),
                                          //     ],
                                          //   ),
                                          // );
                                        }),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
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
    return Padding(
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
                          backgroundColor: Colors.black38,
                          radius: 7,
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
            child:
                Text("Peraturan Kost", style: GoogleFonts.roboto(fontSize: 20)),
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
                          backgroundColor: Colors.black38,
                          radius: 7,
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
    );
  }

  detailHeader() {
    return Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  child: Image.network(widget.model.coverImg,
                      fit: BoxFit.fill, width: double.infinity, height: 300),
                ),
                Positioned(
                  top: 15,
                  left: 15,
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.arrow_back_ios_rounded,
                              color: Colors.black, size: 15),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(width: 240.w),
                      CircleAvatar(
                        radius: 17,
                        backgroundColor: Colors.white,
                        child: IconButton(
                          icon: Icon(Icons.favorite_border,
                              color: Colors.black, size: 15),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 175,
                  left: 15,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dataDetailKost!.kostName,
                          style: GoogleFonts.roboto(
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      SizedBox(
                        width: 275.w,
                        child: Text(dataDetailKost!.location,
                            style: GoogleFonts.inter(
                                fontSize: 13,
                                color: Colors.white,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 265,
                  left: 15,
                  child: Row(
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/icon/room.svg",
                              color: Colors.white),
                          SizedBox(width: 5.w),
                          Text(dataDetailKost!.unitOpen + " Kamar tersedia",
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ],
                      ),
                      SizedBox(width: 12.w),
                      Row(
                        children: [
                          dataDetailKost!.kostType == "Cowok"
                              ? SvgPicture.asset("assets/icon/cowok1.svg")
                              : dataDetailKost!.kostType == "Cewek"
                                  ? SvgPicture.asset("assets/icon/cewek1.svg",
                                      width: 14.w)
                                  : dataDetailKost!.kostType == "Campur"
                                      ? SvgPicture.asset(
                                          "assets/icon/campur1.svg")
                                      : Container(),
                          SizedBox(width: 8.w),
                          Text(dataDetailKost!.kostType,
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ],
                      ),
                      SizedBox(width: 70.w),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.yellow.shade700),
                          SizedBox(width: 2.w),
                          Text(dataDetailKost!.rating,
                              style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 12)),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Deskripsi",
                      style: GoogleFonts.roboto(fontSize: 20),
                    ),
                    SizedBox(height: 10.h),
                    ReadMoreText(
                      dataDetailKost!.desc,
                      trimLines: 2,
                      style: GoogleFonts.roboto(fontSize: 14),
                      colorClickableText: ColorValues.primaryBlue,
                      trimMode: TrimMode.Line,
                      trimCollapsedText: ' Show more',
                      trimExpandedText: ' Show less',
                    ),
                    SizedBox(height: 5.h),
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0XFFE7E7E7),
                        radius: 25,
                        backgroundImage: NetworkImage(dataDetailKost!.user.pfp),
                      ),
                      title: Text(pemilikkost,
                          style: GoogleFonts.roboto(
                              fontSize: 15, fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          "Bergabung " +
                              DateFormat('dd MMM yyyy')
                                  .format(dataDetailKost!.user.createdAt),
                          style: GoogleFonts.roboto(fontSize: 12)),
                      trailing: InkWell(
                        onTap: () {},
                        child: Container(
                          height: 37.h,
                          width: 37.w,
                          decoration: BoxDecoration(
                              border: Border.all(
                                  color: ColorValues.primaryBlue, width: 1),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.3),
                                  spreadRadius: 2,
                                  blurRadius: 5,
                                  offset: Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                              color: ColorValues.primaryBlue),
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Center(
                              child: Icon(Icons.chat,
                                  color: Colors.white, size: 17),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                )),
          ],
        )
        // Column(
        //   mainAxisAlignment: MainAxisAlignment.start,
        //   crossAxisAlignment: CrossAxisAlignment.start,
        //   children: [
        //     Row(
        //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
        //       children: [
        //         Text(dataDetailKost!.kostName,
        //             style: GoogleFonts.roboto(
        //                 fontSize: 20, fontWeight: FontWeight.w500)),
        //         IconButton(
        //             onPressed: () async {
        //               SharedPreferences pref =
        //                   await SharedPreferences.getInstance();
        //               if (pref.getString("token_user") == null &&
        //                   user == null) {
        //                 SharedCode.navigatorPush(context, RolePage());
        //               } else if (user != null) {
        //                 await addNote();
        //                 setState(() {
        //                   _iconColor = ColorValues.primaryPurple;
        //                 });
        //               } else {
        //                 await addNote();
        //                 setState(() {
        //                   _iconColor = ColorValues.primaryPurple;
        //                 });
        //               }
        //             },
        //             icon: Icon(Icons.bookmark, color: _iconColor))
        //       ],
        //     ),
        //     Row(
        //       children: [
        //         DottedBorder(
        //           color: Colors.black,
        //           strokeWidth: 1,
        //           child: Padding(
        //             padding: EdgeInsets.all(3),
        //             child: Text(dataDetailKost!.kostType,
        //                 style: GoogleFonts.roboto(fontSize: 13)),
        //           ),
        //         ),
        //         SizedBox(width: 15.w),
        //         Icon(Icons.location_on_rounded, size: 15),
        //         SizedBox(width: 7.w),
        //         Expanded(
        //           child: Text(dataDetailKost!.location,
        //               style: GoogleFonts.inter(fontSize: 12)),
        //         ),
        //       ],
        //     ),
        //     Padding(
        //       padding: EdgeInsets.only(top: 10),
        //       child: Row(
        //         children: [
        //           Icon(Icons.star, color: ColorValues.primaryPurple, size: 20),
        //           SizedBox(width: 5.w),
        //           Text(dataDetailKost!.rating.toString() +
        //               " (" +
        //               dataComment!.length.toString() +
        //               ")")
        //         ],
        //       ),
        //     )
        //   ],
        // ),
        );
  }

  commentRatingUser() {
    return Padding(
      padding: EdgeInsets.all(12),
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
    );
  }

  comment() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Ulasan Penyewa",
                style: GoogleFonts.roboto(fontSize: 20),
              ),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => buildUlasan(),
                  );
                },
                child: Text("See more",
                    style: GoogleFonts.roboto(color: Colors.black38)),
              ),
            ],
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
                        style: Theme.of(context).textTheme.headline3!.copyWith(
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
        ],
      ),
    );
  }

  listviewTopUlasan() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: dataComment!.length,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0XFFE7E7E7),
                radius: 20,
                backgroundImage: NetworkImage(dataComment![index].user.pfp),
              ),
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(dataComment![index].user.name,
                      style: GoogleFonts.roboto(
                          fontSize: 13, fontWeight: FontWeight.bold)),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.yellow.shade700),
                      SizedBox(width: 2.w),
                      Text(dataComment![index].rating,
                          style: GoogleFonts.roboto(
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 12)),
                    ],
                  )
                ],
              ),
              subtitle: Text(dataComment![index].commentBody,
                  style: GoogleFonts.roboto(fontSize: 13)),
            );
            //   Padding(
            //   padding: EdgeInsets.symmetric(vertical: 8),
            //   child: Row(
            //     children: [
            //       Padding(
            //         padding: EdgeInsets.all(8.0),
            //         child: CircleAvatar(
            //           backgroundColor: Color(0XFFE7E7E7),
            //           radius: 20,
            //           backgroundImage:
            //               NetworkImage(dataComment![index].user.pfp),
            //         ),
            //       ),
            //       Expanded(
            //         child: Column(
            //           mainAxisSize: MainAxisSize.min,
            //           mainAxisAlignment: MainAxisAlignment.start,
            //           crossAxisAlignment: CrossAxisAlignment.start,
            //           children: [
            //             Text(dataComment![index].user.name,
            //                 style: GoogleFonts.roboto(
            //                     fontSize: 12, fontWeight: FontWeight.bold)),
            //             Row(
            //               mainAxisSize: MainAxisSize.min,
            //               mainAxisAlignment: MainAxisAlignment.start,
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Icon(Icons.star,
            //                     color: ColorValues.primaryPurple, size: 12),
            //                 SizedBox(width: 3),
            //                 Text(dataComment![index].rating.toString(),
            //                     style: GoogleFonts.roboto(fontSize: 11)),
            //                 SizedBox(width: 3),
            //                 Padding(
            //                   padding: EdgeInsets.only(top: 3),
            //                   child: Icon(Icons.circle,
            //                       size: 6, color: Colors.grey[400]),
            //                 ),
            //                 SizedBox(width: 3),
            //                 Text(
            //                     DateFormat('yy/MM/d HH:mm')
            //                         .format(dataComment![index].createdAt),
            //                     style: GoogleFonts.roboto(fontSize: 11)),
            //               ],
            //             ),
            //             SizedBox(height: 2.h),
            //             Text(dataComment![index].commentBody,
            //                 style: GoogleFonts.roboto(fontSize: 12)),
            //           ],
            //         ),
            //       ),
            //     ],
            //   ),
            // );
          }),
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
            Text(
                formatCurrency(int.parse(dataDetailKost!.roomPrice)) +
                    " / Bulan",
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
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("Lokasi Kost", style: GoogleFonts.roboto(fontSize: 20)),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
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
                    side:
                        BorderSide(width: 1, color: ColorValues.primaryPurple),
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
    );
  }

  fotoKostWidget() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10.h),
          Text("Preview Kost", style: GoogleFonts.roboto(fontSize: 20)),
          SizedBox(height: 15.h),
          Center(
            child: SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CarouselSlider.builder(
                    options: CarouselOptions(
                        viewportFraction: 1,
                        height: 250.h,
                        enableInfiniteScroll: false,
                        enlargeCenterPage: true,
                        onPageChanged: (index, reason) {
                          setState(() {
                            activeIndex = index;
                          });
                        }),
                    itemCount: dataImage!.length,
                    itemBuilder: (context, index, realIndex) {
                      final asset_image = dataImage![index];

                      return buildImage(asset_image, index);
                    },
                  ),
                  SizedBox(height: 10.h),
                  buildIndicator(),
                  SizedBox(height: 15.h),
                ],
              ),
            ),
          )
        ],
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

  Future<void> _launchUrl() async {
    Uri _url = Uri.parse(dataDetailKost!.locationUrl);
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }

  buildImage(ImageData asset_image, int index) {
    return Container(
      width: double.infinity,
      child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          child: Image.network(asset_image.img, fit: BoxFit.fill)),
    );
  }

  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: dataImage!.length,
      effect: ScrollingDotsEffect(
        fixedCenter: true,
        dotWidth: 8.w,
        dotHeight: 8.h,
      ),
    );
  }

  String formatCurrency(int value) {
    final formatCurrency = new NumberFormat.currency(
        locale: 'id_ID', decimalDigits: 0, symbol: 'Rp ');
    return formatCurrency.format(value);
  }
}
