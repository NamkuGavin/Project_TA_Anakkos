import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/riwayat_model.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/seller_model.dart';
import 'package:project_anakkos_app/ui-Seller/addkost_seller1.dart';

class HomeSeller extends StatefulWidget {
  const HomeSeller({Key? key}) : super(key: key);

  @override
  State<HomeSeller> createState() => _HomeSellerState();
}

class _HomeSellerState extends State<HomeSeller> {
  List<SellerDummyModel> items = [
    SellerDummyModel("assets/dummykos/kost_4.png", "Kost Subadi", "Disewakan",
        "4.9 rating", "10 tenant"),
    SellerDummyModel("assets/dummykos/kost_2.png", "Kost Skywalker",
        "Sewa Gagal", "5.0 rating", "15 tenant"),
    SellerDummyModel("assets/dummykos/kost_3.png", "Kost Hokage", "Disewakan",
        "4.0 rating", "5 tenant"),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appbarWidget(),
      body: kostSeller(),
      floatingActionButton: buttonAdd(),
    );
  }

  kostSeller() {
    return items.isEmpty
        ? Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                  child: SvgPicture.asset("assets/icon/empty_list.svg",
                      width: 125.w)),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Center(
                    child: Text("Belum ada Kost yang di Sewakan",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold, fontSize: 15))),
              )
            ],
          )
        : ListView.builder(
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
                              child: Image.asset(
                                  items[index].picture_kost_seller,
                                  fit: BoxFit.fill)),
                        ),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(items[index].nama_kost_seller,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11)),
                                SizedBox(height: 7.h),
                                Container(
                                  decoration: BoxDecoration(
                                      color: items[index].status_kost_seller ==
                                              "Sewa Gagal"
                                          ? Colors.red
                                          : Colors.green,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 5),
                                    child: Text(items[index].status_kost_seller,
                                        style: GoogleFonts.inter(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 10)),
                                  ),
                                ),
                                SizedBox(height: 7.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.star,
                                        size: 15, color: Colors.black),
                                    SizedBox(width: 4.w),
                                    Text(items[index].rating_kost_seller,
                                        style: GoogleFonts.inter(fontSize: 11))
                                  ],
                                ),
                                SizedBox(height: 7.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.person,
                                        size: 15, color: Colors.black),
                                    SizedBox(width: 4.w),
                                    Text(items[index].tenant_kost_seller,
                                        style: GoogleFonts.inter(fontSize: 11))
                                  ],
                                ),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(
                                      height: 35.h,
                                      width: 40.w,
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(CupertinoIcons.pencil)),
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
            });
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
                Text('Sewa Kost',
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
