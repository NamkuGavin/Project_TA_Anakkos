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
  List<KostSellerData> items = [];
  bool _isLoad = false;

  Future getKostSeller() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoad = true;
    });
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_owner").toString(),
        password: pref.getString("pass_owner").toString());
    KostSellerModel res = await ApiService()
        .getKostSeller(id_seller: result.data.id, token: result.token);
    setState(() {
      items = res.data;
    });
    setState(() {
      _isLoad = false;
    });
  }

  @override
  void initState() {
    getKostSeller();
    super.initState();
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
    return items.isEmpty
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
        : InkWell(
            onTap: () {
              SharedCode.navigatorPush(context, DetailSellerKost());
            },
            child: ListView.builder(
                itemCount: items.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(width: 0.5)),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.horizontal(
                                  left: Radius.circular(10)),
                              child: Container(
                                  width: 100.w,
                                  child: items[index].kostImg != "kosong"
                                      ? Image.network(items[index].kostImg,
                                          fit: BoxFit.fill)
                                      : Text(items[index].kostImg)),
                            ),
                            Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(items[index].kostName,
                                        style: GoogleFonts.inter(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 11)),
                                    SizedBox(height: 7.h),
                                    Container(
                                      decoration: BoxDecoration(
                                          color:
                                              items[index].status == "Rejected"
                                                  ? Colors.red
                                                  : Colors.green,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(5))),
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 5),
                                        child: Text(items[index].status,
                                            style: GoogleFonts.inter(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 10)),
                                      ),
                                    ),
                                    SizedBox(height: 7.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.star,
                                            size: 15, color: Colors.black),
                                        SizedBox(width: 4.w),
                                        Text(items[index].avgRating,
                                            style:
                                                GoogleFonts.inter(fontSize: 11))
                                      ],
                                    ),
                                    SizedBox(height: 7.h),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Icon(Icons.person,
                                            size: 15, color: Colors.black),
                                        SizedBox(width: 4.w),
                                        Text(items[index].unitRented.toString(),
                                            style:
                                                GoogleFonts.inter(fontSize: 11))
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 35.h,
                                          width: 40.w,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon:
                                                  Icon(CupertinoIcons.pencil)),
                                        ),
                                        SizedBox(width: 4.w),
                                        SizedBox(
                                          height: 35.h,
                                          width: 40.w,
                                          child: IconButton(
                                              onPressed: () {},
                                              icon: Icon(CupertinoIcons.trash)),
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
                }),
          );
  }

  appbarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: Text("Dashboard", style: GoogleFonts.roboto(color: Colors.black)),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          color: Colors.black,
          height: 0.2.h,
        ),
      ),
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
