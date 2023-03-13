import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/main.dart';
import 'package:project_anakkos_app/model/history_model.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_user.dart';

class InvoicePagePay extends StatefulWidget {
  final List<HistoryData> kostPending;
  InvoicePagePay({Key? key, required this.kostPending}) : super(key: key);

  @override
  State<InvoicePagePay> createState() => _InvoicePagePayState();
}

class _InvoicePagePayState extends State<InvoicePagePay> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 40.h),
              Center(
                child: Text(
                  'Success!',
                  style: Theme.of(context).textTheme.headline3!.copyWith(
                        fontSize: 25,
                        color: Color(0XFF9B9B9B),
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
              Lottie.asset(
                'assets/lottie/success.json',
                width: 125.w,
                repeat: false,
              ),
              SizedBox(height: 25.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
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
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          infoKost(),
                          Divider(thickness: 1),
                          detailHarga(),
                          Divider(thickness: 1),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("Total payment",
                                  style: GoogleFonts.roboto(
                                      fontWeight: FontWeight.bold)),
                              Text("Rp. " +
                                  widget.kostPending[0].kost.totalPrice)
                            ],
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 50.h),
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
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 25),
                    child: Column(
                      children: [
                        Text("Yay pesanan Anda telah selesai",
                            style: GoogleFonts.roboto(
                                fontWeight: FontWeight.bold)),
                        SizedBox(height: 3.h),
                        Text("Pesanan sudah tersimpan di riwayat anda",
                            style: GoogleFonts.roboto()),
                      ],
                    ),
                  )),
              SizedBox(height: 10.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                            width: 1, color: ColorValues.primaryPurple),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        minimumSize: Size(0.w, 30.h),
                      ),
                      onPressed: () {
                        SharedCode.navigatorReplacement(
                            context, NavigationWidgetBarUser());
                      },
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.keyboard_double_arrow_left_rounded),
                          SizedBox(width: 5.w),
                          Text('Kembali Beranda',
                              style: GoogleFonts.inter(fontSize: 12)),
                        ],
                      )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  detailHarga() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Detail", style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
        SizedBox(height: 3.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Stay duration", style: GoogleFonts.roboto()),
            SizedBox(width: 75.w),
            Expanded(child: Text(widget.kostPending[0].stayDuration))
          ],
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Electricity", style: GoogleFonts.roboto()),
            Text("Rp. " + widget.kostPending[0].kost.elecPrice)
          ],
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Room fees", style: GoogleFonts.roboto()),
            Text("Rp. " + widget.kostPending[0].kost.roomPrice)
          ],
        ),
      ],
    );
  }

  infoKost() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 100.w,
                  child: Image.network(widget.kostPending[0].kost.coverImg,
                      fit: BoxFit.fill)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.kostPending[0].kost.kostName,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      SizedBox(height: 7.h),
                      DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        child: Text(widget.kostPending[0].kost.kostType,
                            style: GoogleFonts.inter(fontSize: 11)),
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded, size: 14),
                          Expanded(
                            child: Text(widget.kostPending[0].kost.location,
                                style: GoogleFonts.inter(fontSize: 11)),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
