import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:lottie/lottie.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/db_helper.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/chat_model.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/fliter_model.dart';
import 'package:project_anakkos_app/helper/check_status.dart';
import 'package:project_anakkos_app/model/db_model/kost_model.dart';
import 'package:project_anakkos_app/model/history_model.dart';
import 'package:project_anakkos_app/model/kost_by_facility_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/model/kost_by_popu_model.dart';
import 'package:project_anakkos_app/model/login_google_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-User/booking_pay_page.dart';
import 'package:project_anakkos_app/ui-User/detail_kost.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/widget/chat_widget/chatWidget_user.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:project_anakkos_app/widget/nearby_kost.dart';
import 'package:project_anakkos_app/widget/populer_kost.dart';
import 'package:project_anakkos_app/widget/search_bar.dart';
import 'package:project_anakkos_app/widget/timer_paymonth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../dummy/dummy model/populer_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Color _iconColor = Colors.white;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final user = FirebaseAuth.instance.currentUser;
  bool _isLoad = false;
  String location = "jakarta";
  List<KostbyLocationData> dataKostbyLoc = [];
  List<KostbyPopularData> dataKostbyPopular = [];
  List<int> idFacilityConfirm = [];
  List<List<KostbyFacilityData>>? dataKostbyFacility;
  List<HistoryData> dataPendingan = [];
  List<HistoryData> kostPending = [];
  Widget? kostHome;
  int activeIndex = 0;
  final _seacrhController = TextEditingController();
  String? networkProfile;
  String? nameProfile;

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
      // HistoryModel history_res = await ApiService().getHistory(
      //     token: login_res.token, user_id: login_res.data.id.toString());
      // setState(() {
      //   dataPendingan = history_res.data;
      //   kostPending = dataPendingan
      //       .where((element) => element.status == "Unpaid")
      //       .toList();
      // });
      setState(() {
        networkProfile = login_res.data.pfp;
        nameProfile = login_res.data.name;
      });
      await getKostbyLoc();
      await getKostbyPopular();
    } else if (user != null) {
      LoginGoogleModel login_res =
          await ApiService().getLoginGoogle(email: user!.email.toString());
      HistoryModel history_res = await ApiService().getHistory(
          token: login_res.token, user_id: login_res.data.id.toString());
      setState(() {
        dataPendingan = history_res.data;
        kostPending = dataPendingan
            .where((element) => element.status == "Unpaid")
            .toList();
      });
      await getKostbyLoc();
      await getKostbyPopular();
    } else {
      await getKostbyPopular();
      await getKostbyLoc();
    }
    setState(() {
      _isLoad = false;
    });
  }

  Future getProfileHome() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    if (pref.getString("email_user") != null &&
        pref.getString("pass_user") != null) {
      setState(() {
        _isLoad = true;
      });
      LoginModel res = await ApiService().getLogin(
          email: pref.getString("email_user").toString(),
          password: pref.getString("pass_user").toString());
      setState(() {
        networkProfile = res.data.pfp;
        nameProfile = res.data.name;
        _isLoad = false;
      });
    } else {}
  }

  Future getKostbyFacility() async {
    KostbyFacilityModel _model =
        await ApiService().getKostbyFacility(facilityId: idFacilityConfirm);
    setState(() {
      dataKostbyFacility = _model.data;
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

  Future getKostbyLoc() async {
    KostbyLocationModel _model =
        await ApiService().getKostbyLoc(location: location);
    setState(() {
      dataKostbyLoc = _model.data;
    });
  }

  Future addNote(dataMark) async {
    final kost_fav = KostFav(
        idKost: dataMark.id,
        name: dataMark.kostName,
        coverImg: dataMark.coverImg,
        location: dataMark.location,
        type: dataMark.kostType,
        price: dataMark.totalPrice);
    await KostDatabase.instance.create(kost_fav);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKostPending();
    // getProfileHome();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: _scaffoldKey,
        // appBar: appBarWidget(),
        body: kostHomePage(),
        endDrawer: filterWidget(),
      ),
    );
  }

  kostHomePage() {
    return _isLoad
        ? LoadingAnimation()
        : SingleChildScrollView(
            child: Stack(
              children: [
                Column(
                  children: [
                    headerHome(),
                    popularKost(),
                    nearbyKost(),
                  ],
                ),
                Positioned(
                  top: 155,
                  left: 5,
                  child: SizedBox(
                    width: 355.w,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            flex: 5,
                            child: SearchBar(
                              controller: _seacrhController,
                              // onChanged: (String) async {
                              //   if (_seacrhController.text == "") {
                              //     setState(() {
                              //       location = "jakarta";
                              //       _isLoad = true;
                              //     });
                              //     await getKostbyLoc();
                              //     await getKostbyPopular();
                              //     setState(() {
                              //       _isLoad = false;
                              //     });
                              //   } else {
                              //     setState(() {
                              //       location = _seacrhController.text;
                              //       _isLoad = true;
                              //     });
                              //     await getKostbyLoc();
                              //     await getKostbyPopular();
                              //     setState(() {
                              //       _isLoad = false;
                              //     });
                              //   }
                              // },
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(left: 8),
                              child: InkWell(
                                onTap: () {
                                  _scaffoldKey.currentState!.openEndDrawer();
                                },
                                child: Container(
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.grey, width: 1),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.3),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: Offset(0,
                                              3), // changes position of shadow
                                        ),
                                      ],
                                      color: Colors.white),
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Center(
                                      child: SvgPicture.asset(
                                        "assets/icon/filter.svg",
                                        height: 25.h,
                                        width: 25.w,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
    // SingleChildScrollView(
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     mainAxisAlignment: MainAxisAlignment.start,
    //     children: [
    //       searchBar(),
    //       _isLoad
    //           ? LoadingAnimation()
    //           : Column(
    //               crossAxisAlignment: CrossAxisAlignment.start,
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 filterWidget(),
    //                 ongoingKost(),
    //                 SizedBox(height: 20.h),
    //                 popularKost(),
    //                 nearbyKost(),
    //               ],
    //             ),
    //     ],
    //   ),
    // ),
  }

  headerHome() {
    return Container(
      height: 175.h,
      width: double.infinity,
      color: Color(0xFFECECEC),
      child: Padding(
        padding: EdgeInsets.only(left: 30, top: 25, right: 25),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            networkProfile != null ? sudahLoginProfile() : Container(),
            SizedBox(height: 10.h),
            Text("Temukan kos di dekat Anda",
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                )),
          ],
        ),
      ),
    );
  }

  sudahLoginProfile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CircleAvatar(
              backgroundColor: Color(0XFFE7E7E7),
              radius: 20,
              backgroundImage: NetworkImage(networkProfile!),
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3), // changes position of shadow
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: Icon(Icons.bookmark, color: Colors.black38, size: 22),
                  onPressed: () {},
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 10.h),
        Text("Hello " + nameProfile! + ","),
      ],
    );
  }

  appBarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: SvgPicture.asset(
        "assets/logo/anakkos_logo4.svg",
        height: 37.h,
        fit: BoxFit.fill,
      ),
      // actions: [
      //   AnimSearchBar(
      //     boxShadow: false,
      //     width: 375,
      //     textController: _seacrhController,
      //     onSuffixTap: () {
      //       setState(() {
      //         _seacrhController.clear();
      //       });
      //     },
      //     onSubmitted: (String) async {
      //       setState(() {
      //         location = _seacrhController.text;
      //         _isLoad = true;
      //       });
      //       await getKostbyLoc();
      //       await getKostbyPopular();
      //       setState(() {
      //         _isLoad = false;
      //       });
      //     },
      //   ),
      // ],
      // bottom: PreferredSize(
      //   preferredSize: Size.fromHeight(0.0),
      //   child: Container(
      //     color: Colors.black,
      //     height: 0.2.h,
      //   ),
      // ),
    );
  }

  popularKost() {
    return Column(
      children: [
        SizedBox(height: 35.h),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Most Popular",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
              GestureDetector(
                onTap: () {},
                child: Text("See more",
                    style: GoogleFonts.roboto(color: Colors.grey)),
              )
            ],
          ),
        ),
        Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CarouselSlider.builder(
              options: CarouselOptions(
                  viewportFraction: 1,
                  enableInfiniteScroll: false,
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    setState(() {
                      activeIndex = index;
                    });
                  }),
              itemCount: dataKostbyPopular.length == 1
                  ? 1
                  : dataKostbyPopular.length == 2
                      ? 2
                      : dataKostbyPopular.length == 3
                          ? 3
                          : dataKostbyPopular.length == 4
                              ? 4
                              : dataKostbyPopular.length,
              itemBuilder: (context, index, realIndex) {
                final data = dataKostbyPopular[index];

                return buildKostPopular(data, index);
              },
            ),
            buildIndicator(),
          ],
        ),
      ],
    );
    //   Padding(
    //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 15),
    //             child: Text("Popular Kost",
    //                 style: GoogleFonts.inter(
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 14,
    //                 )),
    //           ),
    //           Expanded(
    //             child: Divider(
    //               color: Colors.grey,
    //               thickness: 0.5,
    //             ),
    //           ),
    //         ],
    //       ),
    //       SizedBox(height: 10.h),
    //       dataKostbyPopular.isEmpty
    //           ? Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Lottie.asset(
    //                     'assets/lottie/not_found.json',
    //                     width: 225.w,
    //                     repeat: false,
    //                   ),
    //                   Text(
    //                     'Belum ada Kost yang Tersedia',
    //                     style: Theme.of(context).textTheme.headline3!.copyWith(
    //                           fontSize: 17,
    //                           color: Color(0XFF9B9B9B),
    //                           fontWeight: FontWeight.w500,
    //                         ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           : GridView.builder(
    //               shrinkWrap: true,
    //               physics: NeverScrollableScrollPhysics(),
    //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                 childAspectRatio: 0.57,
    //                 crossAxisCount: 2,
    //                 crossAxisSpacing: 10.0,
    //                 mainAxisSpacing: 10.0,
    //               ),
    //               itemCount: dataKostbyPopular.length == 1
    //                   ? 1
    //                   : dataKostbyPopular.length == 2
    //                       ? 2
    //                       : dataKostbyPopular.length == 3
    //                           ? 3
    //                           : dataKostbyPopular.length == 4
    //                               ? 4
    //                               : dataKostbyPopular.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return InkWell(
    //                   onTap: () {
    //                     SharedCode.navigatorPush(
    //                         context,
    //                         DetailKost(
    //                           idKost: dataKostbyLoc[index].id.toString(),
    //                           model: dataKostbyLoc[index],
    //                         ));
    //                   },
    //                   child: Card(
    //                     color: Colors.white,
    //                     elevation: 5,
    //                     shadowColor: Colors.black,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         SizedBox(
    //                           height: 125.h,
    //                           width: 150.w,
    //                           child: ClipRRect(
    //                               borderRadius: BorderRadius.vertical(
    //                                   bottom: Radius.circular(10)),
    //                               child: Image.network(
    //                                   dataKostbyPopular[index].coverImg,
    //                                   fit: BoxFit.cover)),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 4),
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               SizedBox(height: 12.h),
    //                               DottedBorder(
    //                                 color: Colors.black,
    //                                 strokeWidth: 1,
    //                                 child: Text(
    //                                     dataKostbyPopular[index].kostType,
    //                                     style: GoogleFonts.inter(fontSize: 11)),
    //                               ),
    //                               SizedBox(height: 4.h),
    //                               Text(dataKostbyPopular[index].kostName,
    //                                   style: GoogleFonts.inter(fontSize: 11)),
    //                               SizedBox(height: 4.h),
    //                               Row(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Icon(Icons.location_on_rounded, size: 13),
    //                                   Expanded(
    //                                     child: Text(
    //                                         dataKostbyPopular[index].location,
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 11)),
    //                                   )
    //                                 ],
    //                               ),
    //                               SizedBox(height: 6.h),
    //                               Align(
    //                                 alignment: Alignment.bottomRight,
    //                                 child: Text(
    //                                     "Rp. " +
    //                                         dataKostbyPopular[index]
    //                                             .roomPrice
    //                                             .toString() +
    //                                         " / Bulan",
    //                                     style: GoogleFonts.inter(fontSize: 11)),
    //                               )
    //                             ],
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //       SizedBox(height: 5.h),
    //       Align(
    //         alignment: Alignment.bottomRight,
    //         child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: ColorValues.primaryBlue,
    //               foregroundColor: Colors.white,
    //               minimumSize: Size(20.w, 30.h),
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10)),
    //             ),
    //             onPressed: () {
    //               SharedCode.navigatorPush(
    //                   context, PopulerKost(location: location));
    //             },
    //             child: Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Text('Lainnya', style: GoogleFonts.inter(fontSize: 12)),
    //                 Icon(Icons.double_arrow_rounded)
    //               ],
    //             )),
    //       )
    //       // SizedBox(height: 10.h),
    //       // GestureDetector(
    //       //   onTap: () {
    //       //     SharedCode.navigatorPush(context, PopulerKost());
    //       //   },
    //       //   child: Row(
    //       //     crossAxisAlignment: CrossAxisAlignment.end,
    //       //     mainAxisAlignment: MainAxisAlignment.end,
    //       //     children: [
    //       //       Icon(Icons.add, size: 15),
    //       //       Text('Lainnya', style: GoogleFonts.inter(fontSize: 12))
    //       //     ],
    //       //   ),
    //       // )
    //     ],
    //   ),
    // );
  }

  nearbyKost() {
    return Column(
      children: [
        SizedBox(height: 20.h),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Near by",
                  style: GoogleFonts.roboto(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  )),
              GestureDetector(
                onTap: () {},
                child: Text("See more",
                    style: GoogleFonts.roboto(color: Colors.grey)),
              )
            ],
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 8),
          child: SizedBox(
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: dataKostbyLoc.length,
              itemBuilder: (BuildContext context, int index) {
                var dataKostLoc = dataKostbyLoc[index];
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    dense: true,
                    visualDensity: VisualDensity(vertical: 4),
                    leading: SizedBox(
                        width: 100.w,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            child: Image.network(dataKostLoc.coverImg,
                                fit: BoxFit.fill))),
                    title: Text(dataKostLoc.kostName,
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.w600, fontSize: 15)),
                    subtitle: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 8.h),
                        Text("Rp. " + dataKostLoc.roomPrice + "/ Bulan",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: ColorValues.primaryBlue)),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            SvgPicture.asset("assets/icon/room.svg"),
                            SizedBox(width: 8.w),
                            Text(dataKostLoc.unitOpen + " Kamar tersedia",
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400, fontSize: 12)),
                          ],
                        ),
                        SizedBox(height: 5.h),
                        Row(
                          children: [
                            dataKostLoc.kostType == "Cowok"
                                ? SvgPicture.asset("assets/icon/cowok.svg")
                                : dataKostLoc.kostType == "Cewek"
                                    ? SvgPicture.asset("assets/icon/cewek.svg",
                                        width: 14.w)
                                    : dataKostLoc.kostType == "Campur"
                                        ? SvgPicture.asset(
                                            "assets/icon/campur.svg")
                                        : Container(),
                            SizedBox(width: 8.w),
                            Text(dataKostLoc.kostType,
                                style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.w400, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                    trailing: IconButton(
                        onPressed: () async {
                          SharedPreferences pref =
                              await SharedPreferences.getInstance();
                          if (pref.getString("token_user") == null &&
                              user == null) {
                            SharedCode.navigatorPush(context, RolePage());
                          } else if (user != null) {
                            await addNote(dataKostLoc);
                            setState(() {
                              _iconColor = ColorValues.primaryPurple;
                            });
                          } else {
                            await addNote(dataKostLoc);
                            setState(() {
                              _iconColor = ColorValues.primaryPurple;
                            });
                          }
                        },
                        icon:
                            Icon(Icons.bookmark, color: Colors.grey.shade300)),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
    //   Padding(
    //   padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
    //   child: Column(
    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       Row(
    //         children: [
    //           Padding(
    //             padding: EdgeInsets.symmetric(horizontal: 15),
    //             child: Text("Kost Terdekat",
    //                 style: GoogleFonts.inter(
    //                   fontWeight: FontWeight.w600,
    //                   fontSize: 14,
    //                 )),
    //           ),
    //           Expanded(
    //             child: Divider(
    //               color: Colors.grey,
    //               thickness: 0.5,
    //             ),
    //           ),
    //         ],
    //       ),
    //       SizedBox(height: 10.h),
    //       dataKostbyLoc.isEmpty
    //           ? Center(
    //               child: Column(
    //                 mainAxisAlignment: MainAxisAlignment.center,
    //                 children: [
    //                   Lottie.asset(
    //                     'assets/lottie/not_found.json',
    //                     width: 225.w,
    //                     repeat: false,
    //                   ),
    //                   Text(
    //                     'Belum ada Kost yang Tersedia',
    //                     style: Theme.of(context).textTheme.headline3!.copyWith(
    //                           fontSize: 17,
    //                           color: Color(0XFF9B9B9B),
    //                           fontWeight: FontWeight.w500,
    //                         ),
    //                   ),
    //                 ],
    //               ),
    //             )
    //           : GridView.builder(
    //               shrinkWrap: true,
    //               physics: NeverScrollableScrollPhysics(),
    //               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    //                 childAspectRatio: 0.57,
    //                 crossAxisCount: 2,
    //                 crossAxisSpacing: 10.0,
    //                 mainAxisSpacing: 10.0,
    //               ),
    //               itemCount: dataKostbyLoc.length == 1
    //                   ? 1
    //                   : dataKostbyLoc.length == 2
    //                       ? 2
    //                       : dataKostbyLoc.length == 3
    //                           ? 3
    //                           : dataKostbyLoc.length == 4
    //                               ? 4
    //                               : dataKostbyLoc.length,
    //               itemBuilder: (BuildContext context, int index) {
    //                 return InkWell(
    //                   onTap: () {
    //                     SharedCode.navigatorPush(
    //                         context,
    //                         DetailKost(
    //                           idKost: dataKostbyLoc[index].id.toString(),
    //                           model: dataKostbyLoc[index],
    //                         ));
    //                   },
    //                   child: Card(
    //                     color: Colors.white,
    //                     elevation: 5,
    //                     shadowColor: Colors.black,
    //                     child: Column(
    //                       crossAxisAlignment: CrossAxisAlignment.start,
    //                       children: [
    //                         SizedBox(
    //                           height: 125.h,
    //                           width: 150.w,
    //                           child: ClipRRect(
    //                               borderRadius: BorderRadius.vertical(
    //                                   bottom: Radius.circular(10)),
    //                               child: Image.network(
    //                                   dataKostbyLoc[index].coverImg,
    //                                   fit: BoxFit.fill)),
    //                         ),
    //                         Padding(
    //                           padding: EdgeInsets.symmetric(horizontal: 4),
    //                           child: Column(
    //                             crossAxisAlignment: CrossAxisAlignment.start,
    //                             children: [
    //                               SizedBox(height: 12.h),
    //                               DottedBorder(
    //                                 color: Colors.black,
    //                                 strokeWidth: 1,
    //                                 child: Text(dataKostbyLoc[index].kostType,
    //                                     style: GoogleFonts.inter(fontSize: 11)),
    //                               ),
    //                               SizedBox(height: 4.h),
    //                               Text(dataKostbyLoc[index].kostName,
    //                                   style: GoogleFonts.inter(fontSize: 11)),
    //                               SizedBox(height: 4.h),
    //                               Row(
    //                                 crossAxisAlignment:
    //                                     CrossAxisAlignment.start,
    //                                 children: [
    //                                   Icon(Icons.location_on_rounded, size: 13),
    //                                   Expanded(
    //                                     child: Text(
    //                                         dataKostbyLoc[index].location,
    //                                         style: GoogleFonts.inter(
    //                                             fontSize: 11)),
    //                                   )
    //                                 ],
    //                               ),
    //                               SizedBox(height: 6.h),
    //                               Align(
    //                                 alignment: Alignment.bottomRight,
    //                                 child: Text(
    //                                     "Rp. " +
    //                                         dataKostbyLoc[index]
    //                                             .roomPrice
    //                                             .toString() +
    //                                         " / Bulan",
    //                                     style: GoogleFonts.inter(fontSize: 11)),
    //                               )
    //                             ],
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   ),
    //                 );
    //               },
    //             ),
    //       SizedBox(height: 5.h),
    //       Align(
    //         alignment: Alignment.bottomRight,
    //         child: ElevatedButton(
    //             style: ElevatedButton.styleFrom(
    //               backgroundColor: ColorValues.primaryBlue,
    //               foregroundColor: Colors.white,
    //               minimumSize: Size(20.w, 30.h),
    //               shape: RoundedRectangleBorder(
    //                   borderRadius: BorderRadius.circular(10)),
    //             ),
    //             onPressed: () {
    //               SharedCode.navigatorPush(
    //                   context, NearByKost(location: location));
    //             },
    //             child: Row(
    //               mainAxisSize: MainAxisSize.min,
    //               children: [
    //                 Text('Lainnya', style: GoogleFonts.inter(fontSize: 12)),
    //                 Icon(Icons.double_arrow_rounded)
    //               ],
    //             )),
    //       )
    //     ],
    //   ),
    // );
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
                InkWell(
                  onTap: () {
                    SharedCode.navigatorPush(
                        context, BookingPayPage(kostPending: kostPending));
                  },
                  child: Container(
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
                                child: Image.network(
                                    kostPending[0].kost.coverImg,
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
                                    ],
                                  ),
                                  SizedBox(height: 7.h),
                                  Text(kostPending[0].kost.kostName,
                                      style: GoogleFonts.inter(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12)),
                                  SizedBox(height: 7.h),
                                  Text(
                                      "Total : Rp. " +
                                          kostPending[0].totalPrice,
                                      style: GoogleFonts.roboto(fontSize: 12)),
                                  SizedBox(height: 7.h),
                                  Text(
                                      "Durasi Sewa: " +
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
                                          // SharedCode.navigatorPush(
                                          //     context,
                                          //     ChatWidget(
                                          //         chats: chat,
                                          //         title: 'Seller 1'));
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
                ),
              ],
            ),
          )
        : Container();
  }

  filterWidget() {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15), bottomLeft: Radius.circular(15)),
      child: Drawer(
        width: 160.w,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text("Filter Fasilitas",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                        fontSize: 16)),
                SizedBox(height: 25.h),
                Text('Tempat Tidur',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        fontSize: 14)),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.bantal,
                      onChanged: (bool? value) {
                        int id = 1;
                        setState(() {
                          CheckStatus.bantal = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Bantal", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.kasur,
                      onChanged: (bool? value) {
                        int id = 2;
                        setState(() {
                          CheckStatus.kasur = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Kasur", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Divider(color: Colors.black),
                Text('Kamar mandi',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        fontSize: 14)),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.kamarMandi,
                      onChanged: (bool? value) {
                        int id = 3;
                        setState(() {
                          CheckStatus.kamarMandi = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Luar", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.laundry,
                      onChanged: (bool? value) {
                        int id = 4;
                        setState(() {
                          CheckStatus.laundry = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Dalam", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Divider(color: Colors.black),
                Text('Lain - lain',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        fontSize: 14)),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.lemari,
                      onChanged: (bool? value) {
                        int id = 5;
                        setState(() {
                          CheckStatus.lemari = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Lemari", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.meja,
                      onChanged: (bool? value) {
                        int id = 6;
                        setState(() {
                          CheckStatus.meja = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Meja", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.kursi,
                      onChanged: (bool? value) {
                        int id = 7;
                        setState(() {
                          CheckStatus.kursi = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Kursi", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Divider(color: Colors.black),
                Text('Sirkulasi Udara',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                        fontSize: 14)),
                SizedBox(height: 4.h),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.kipas,
                      onChanged: (bool? value) {
                        int id = 9;
                        setState(() {
                          CheckStatus.kipas = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("Kipas", style: TextStyle(fontSize: 14)),
                  ],
                ),
                Row(
                  children: [
                    Switch(
                      value: CheckStatus.ac,
                      onChanged: (bool? value) {
                        int id = 8;
                        setState(() {
                          CheckStatus.ac = value!;
                          if (value != false) {
                            idFacilityConfirm.add(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          } else {
                            idFacilityConfirm.remove(id);
                            print("LIST ID: " + idFacilityConfirm.toString());
                          }
                        });
                      },
                    ),
                    Text("AC", style: TextStyle(fontSize: 14)),
                  ],
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorValues.primaryBlue,
                      foregroundColor: Colors.white,
                      minimumSize: Size(double.infinity, 0.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () async {
                      if (idFacilityConfirm.isNotEmpty) {
                        setState(() {
                          _isLoad = true;
                        });
                        await getKostbyFacility();
                        setState(() {
                          _isLoad = false;
                        });
                      } else {
                        setState(() {
                          _isLoad = true;
                        });
                        await getKostPending();
                        setState(() {
                          _isLoad = false;
                          Navigator.pop(context);
                        });
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tampilkan Hasil',
                              style: GoogleFonts.inter(fontSize: 11)),
                          SizedBox(width: 7.w),
                          Icon(Icons.save, size: 15.w)
                        ],
                      ),
                    )),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade100,
                      foregroundColor: Colors.black,
                      minimumSize: Size(double.infinity, 0.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                          side: BorderSide(color: Colors.black)),
                    ),
                    onPressed: () {
                      setState(() {
                        CheckStatus.termasukListrik = false;
                        CheckStatus.bayarListrik = false;
                        CheckStatus.bantal = false;
                        CheckStatus.guling = false;
                        CheckStatus.kasur = false;
                        CheckStatus.kamarMandi = false;
                        CheckStatus.laundry = false;
                        CheckStatus.dapur = false;
                        CheckStatus.kulkas = false;
                        CheckStatus.katering = false;
                        CheckStatus.wifi = false;
                        CheckStatus.tv = false;
                        CheckStatus.lemari = false;
                        CheckStatus.jendela = false;
                        CheckStatus.meja = false;
                        CheckStatus.kursi = false;
                        CheckStatus.kipas = false;
                        CheckStatus.ac = false;
                      });
                      idFacilityConfirm.clear();
                      print("LIST ID: " + idFacilityConfirm.toString());
                    },
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Reset', style: GoogleFonts.inter(fontSize: 11)),
                          SizedBox(width: 8.w),
                          Icon(Icons.delete_forever, size: 15.w)
                        ],
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }

  kostByFacility() {
    return _isLoad
        ? LoadingAnimation()
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              filterWidget(),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: GridView.builder(
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.57,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10.0,
                      mainAxisSpacing: 10.0,
                    ),
                    itemCount: dataKostbyFacility!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          SharedCode.navigatorPush(
                              context,
                              DetailKost(
                                idKost: dataKostbyLoc[index].id.toString(),
                                model: dataKostbyLoc[index],
                              ));
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 5,
                          shadowColor: Colors.black,
                          child: Column(
                            children: [
                              SizedBox(
                                height: 125.h,
                                width: 150.w,
                                child: ClipRRect(
                                    borderRadius: BorderRadius.vertical(
                                        bottom: Radius.circular(10)),
                                    child: Image.network(
                                        dataKostbyFacility![index][0].coverImg,
                                        fit: BoxFit.cover)),
                              ),
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
                                          dataKostbyFacility![index][0]
                                              .kostType,
                                          style:
                                              GoogleFonts.inter(fontSize: 11)),
                                    ),
                                    SizedBox(height: 7.h),
                                    Text(dataKostbyFacility![index][0].kostName,
                                        style: GoogleFonts.inter(fontSize: 11)),
                                    SizedBox(height: 7.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.location_on_rounded,
                                            size: 13),
                                        Expanded(
                                          child: Text(
                                              dataKostbyFacility![index][0]
                                                  .location,
                                              style: GoogleFonts.inter(
                                                  fontSize: 11)),
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
                                          style:
                                              GoogleFonts.inter(fontSize: 11)),
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

  searchBar() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: SearchBar(
        controller: _seacrhController,
        onChanged: (String) async {
          if (_seacrhController.text == "") {
            setState(() {
              location = "jakarta";
              _isLoad = true;
            });
            await getKostbyLoc();
            await getKostbyPopular();
            setState(() {
              _isLoad = false;
            });
          } else {
            setState(() {
              location = _seacrhController.text;
              _isLoad = true;
            });
            await getKostbyLoc();
            await getKostbyPopular();
            setState(() {
              _isLoad = false;
            });
          }
        },
      ),
    );
  }

  buildKostPopular(KostbyPopularData dataPopular, int index) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        children: [
          ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(dataPopular.coverImg, fit: BoxFit.fill)),
          Positioned(
            top: 140,
            left: 15,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(dataPopular.kostName,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 17)),
                Text("Gambir, Jakarta",
                    style:
                        GoogleFonts.roboto(color: Colors.white, fontSize: 13)),
              ],
            ),
          ),
          Positioned(
            top: 165,
            left: 220,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: RatingBar(
                    initialRating: double.parse(dataPopular.rating),
                    itemCount: 5,
                    itemSize: 17.w,
                    ignoreGestures: true,
                    ratingWidget: RatingWidget(
                      full: Icon(
                        Icons.star,
                        color: Colors.yellow.shade700,
                      ),
                      half: Icon(
                        Icons.star_half,
                        color: Colors.yellow.shade700,
                      ),
                      empty: Icon(
                        Icons.star_border,
                        color: Colors.yellow.shade700,
                      ),
                    ),
                    onRatingUpdate: (double value) {},
                  ),
                ),
                Text(dataPopular.rating,
                    style: GoogleFonts.roboto(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
          ),
          Positioned(
            left: 285,
            child: IconButton(
                onPressed: () async {
                  SharedPreferences pref =
                      await SharedPreferences.getInstance();
                  if (pref.getString("token_user") == null && user == null) {
                    SharedCode.navigatorPush(context, RolePage());
                  } else if (user != null) {
                    await addNote(dataPopular);
                    setState(() {
                      _iconColor = ColorValues.primaryPurple;
                    });
                  } else {
                    await addNote(dataPopular);
                    setState(() {
                      _iconColor = ColorValues.primaryPurple;
                    });
                  }
                },
                icon: Icon(Icons.bookmark, color: _iconColor)),
          )
        ],
      ),
    );
  }

  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: dataKostbyPopular.length == 1
          ? 1
          : dataKostbyPopular.length == 2
              ? 2
              : dataKostbyPopular.length == 3
                  ? 3
                  : dataKostbyPopular.length == 4
                      ? 4
                      : dataKostbyPopular.length,
      effect: WormEffect(
        dotWidth: 13.w,
        dotHeight: 13.h,
      ),
    );
  }
}
