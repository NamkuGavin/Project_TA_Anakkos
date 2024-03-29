import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/riwayat_model.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/seller_model.dart';
import 'package:project_anakkos_app/model/kost_seller_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/ui-Seller/addkost_seller1.dart';
import 'package:project_anakkos_app/ui-Seller/detail_seller.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeSeller extends StatefulWidget {
  const HomeSeller({Key? key}) : super(key: key);

  @override
  State<HomeSeller> createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  ValueNotifier<List<KostSellerData>> items =
      ValueNotifier<List<KostSellerData>>([]);
  // List<KostSellerData> items = [];
  bool _isLoad = false;
  Timer? timer;

  Future getKostSeller() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    KostSellerModel res = await ApiService().getKostSeller(
        id_seller: pref.getInt("id_seller")!,
        token: pref.getString("token_owner")!);
    setState(() {
      items.value = res.data;
    });
  }

  Future deleteKost(String kost_id) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoad = true;
    });
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_owner").toString(),
        password: pref.getString("pass_owner").toString());
    await ApiService().deleteKost(token: result.token, kost_id: kost_id);
    await getKostSeller();
    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    // timer = Timer.periodic(Duration(seconds: 3), (Timer t) => getKostSeller());
    getKostSeller();
    super.initState();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(),
      body: _isLoad ? LoadingAnimation() : kostSeller(),
      floatingActionButton: buttonAdd(),
    );
  }

  kostSeller() {
    return items.value.isEmpty
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
        : ValueListenableBuilder(
            valueListenable: items,
            builder: (context, value, child) {
              return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                      onTap: () {
                        timer?.cancel();
                        SharedCode.navigatorPush(
                            context,
                            DetailSellerKost(
                              dataDetail: value[index],
                              idKost: value[index].kostId,
                            ));
                      },
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                                child: Container(
                                    width: 100.w,
                                    child: value[index].kostImg != "kosong"
                                        ? Image.network(value[index].kostImg,
                                            fit: BoxFit.fill)
                                        : Image.asset(
                                            "assets/dummykos/kost_1.png",
                                            fit: BoxFit.fill)),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(value[index].kostName,
                                          style: GoogleFonts.inter(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 12)),
                                      SizedBox(height: 7.h),
                                      Container(
                                        decoration: BoxDecoration(
                                            color:
                                                value[index].status == "pending"
                                                    ? Colors.yellow.shade800
                                                    : value[index].status ==
                                                            "rejected"
                                                        ? Colors.red
                                                        : Colors.green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(5))),
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 5),
                                          child: Text(value[index].status,
                                              style: GoogleFonts.inter(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 11)),
                                        ),
                                      ),
                                      SizedBox(height: 7.h),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Icon(Icons.star_half,
                                              size: 21,
                                              color: Colors.yellow.shade700),
                                          SizedBox(width: 4.w),
                                          Text(
                                              value[index].avgRating.toString(),
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold))
                                        ],
                                      ),
                                      SizedBox(height: 7.h),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          SvgPicture.asset(
                                              "assets/icon/room.svg",
                                              width: 18.w),
                                          SizedBox(width: 4.w),
                                          Text(
                                              value[index]
                                                  .unitRented
                                                  .toString(),
                                              style: GoogleFonts.inter(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF8E8E8E)))
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Container(),
                                          InkWell(
                                            onTap: () {},
                                            child: Container(
                                              height: 40.h,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.3),
                                                      spreadRadius: 2,
                                                      blurRadius: 5,
                                                      offset: Offset(0,
                                                          3), // changes position of shadow
                                                    ),
                                                  ],
                                                  color: Colors.red),
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Center(
                                                    child: Icon(
                                                  Icons.delete,
                                                  color: Colors.white,
                                                )),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  });
            },
          );
  }

  appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Color(0xFFECECEC),
      toolbarHeight: 75.h,
      title: Text("Dashboard",
          style: GoogleFonts.roboto(color: Colors.black, fontSize: 18)),
    );
  }

  buttonAdd() {
    return Container(
      height: 60.h,
      child: FittedBox(
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorValues.primaryBlue,
              foregroundColor: Colors.white,
              minimumSize: Size(0.w, 30.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {
              timer?.cancel();
              SharedCode.navigatorPush(context, AddKostPage1());
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Buat Kost Baru',
                    style: GoogleFonts.inter(
                        fontWeight: FontWeight.bold, fontSize: 11)),
                SizedBox(width: 5.w),
                Icon(CupertinoIcons.plus, size: 20)
              ],
            )),
      ),
    );
  }
}
