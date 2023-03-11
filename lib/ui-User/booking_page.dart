import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/paymentType_model.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/model/start_trans_model.dart';
import 'package:project_anakkos_app/ui-User/invoice_page.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_help.dart';
import 'package:project_anakkos_app/widget/custom_text_field.dart';
import 'package:project_anakkos_app/widget/timer.dart';

class BookingPage extends StatefulWidget {
  final StartTransData dataTrans;
  final StartTransModel dataMidtrans;
  BookingPage({Key? key, required this.dataTrans, required this.dataMidtrans})
      : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  List<PaymentTypeModel> paymentList = [
    PaymentTypeModel("Credit atau Debit Card", "assets/logo/card.png", 1),
    PaymentTypeModel("GoPay", "assets/logo/gopay.png", 2),
  ];
  PaymentTypeModel? paymentValue;
  bool showCardField = false;
  MidtransSDK? _midtrans;

  void initSDK() async {
    _midtrans = await MidtransSDK.init(
      config: MidtransConfig(
        clientKey: "SB-Mid-client-zZp8FY_6ph9SrxOP",
        merchantBaseUrl: 'https://api.sandbox.midtrans.com/v3/',
        // colorTheme: ColorTheme(
        //   colorPrimary: Theme.of(context).accentColor,
        //   colorPrimaryDark: Theme.of(context).accentColor,
        //   colorSecondary: Theme.of(context).accentColor,
        // ),
      ),
    );
    _midtrans?.setUIKitCustomSetting(
      skipCustomerDetailsPages: true,
    );
    _midtrans!.setTransactionFinishedCallback((result) {
      print(result.toJson());
    });
  }

  @override
  void initState() {
    super.initState();
    initSDK();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Payment", style: TextStyle(color: Colors.black)),
        leading: IconButton(
            onPressed: () {
              SharedCode.navigatorPop(context);
            },
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black)),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: GestureDetector(
              onTap: () {
                _showDialog(context);
              },
              child: SvgPicture.asset("assets/icon/Help.svg", width: 20.w),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TimerWidget(),
              SizedBox(height: 50.h),
              Text('Payment summary',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black45)),
              SizedBox(height: 10.h),
              Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.8),
                        spreadRadius: 2,
                        blurRadius: 5,
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
                            Text("Rp. " + widget.dataTrans.totalPrice)
                          ],
                        ),
                      ],
                    ),
                  )),
              SizedBox(height: 30.h),
              Text('Bayar dengan',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600, color: Colors.black45)),
              SizedBox(height: 5.h),
              DropdownButton2<PaymentTypeModel>(
                isExpanded: true,
                value: paymentValue,
                iconOnClick:
                    Icon(Icons.keyboard_arrow_up_rounded, color: Colors.black),
                icon: Icon(Icons.keyboard_arrow_down_rounded,
                    color: Colors.black),
                buttonPadding: EdgeInsets.symmetric(horizontal: 12),
                buttonDecoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                  ),
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.white,
                ),
                buttonHeight: 40.h,
                buttonWidth: double.infinity,
                buttonElevation: 2,
                dropdownDecoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                dropdownElevation: 4,
                offset: Offset(0, -10),
                onChanged: (PaymentTypeModel? newValue) {
                  setState(() {
                    paymentValue = newValue!;
                    if (newValue.id == 1) {
                      showCardField = true;
                    } else {
                      showCardField = false;
                    }
                  });
                },
                hint: Text(
                  'Pilih Payment Type',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.black45),
                  overflow: TextOverflow.ellipsis,
                ),
                isDense: true,
                underline: SizedBox.shrink(),
                items: paymentList.map((item) {
                  return DropdownMenuItem<PaymentTypeModel>(
                    child: Row(
                      children: [
                        Image.asset(item.logo, width: 25.w),
                        SizedBox(width: 15.w),
                        Text(item.type,
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 13,
                                color: Colors.black45)),
                      ],
                    ),
                    value: item,
                  );
                }).toList(),
              ),
              SizedBox(height: 10.h),
              showCardField
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Card Number',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffD6D6D6)),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorValues.primaryBlue),
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 168.w,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Exp date',
                                    hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w500),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD6D6D6)),
                                        borderRadius: BorderRadius.circular(8)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorValues.primaryBlue),
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                            SizedBox(
                              width: 168.w,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'CVV',
                                    hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w500),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD6D6D6)),
                                        borderRadius: BorderRadius.circular(8)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorValues.primaryBlue),
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 25.h),
                        Text('Alamat Tagihan',
                            style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                color: Colors.black45)),
                        SizedBox(height: 5.h),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Jalan',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffD6D6D6)),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorValues.primaryBlue),
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Nomor Suite atau APT',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffD6D6D6)),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorValues.primaryBlue),
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        TextField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                              hintText: 'Kota / Provinsi',
                              hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.black26,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                  borderSide:
                                      BorderSide(color: Color(0xffD6D6D6)),
                                  borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorValues.primaryBlue),
                                  borderRadius: BorderRadius.circular(8))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              width: 168.w,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Negara',
                                    hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w500),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD6D6D6)),
                                        borderRadius: BorderRadius.circular(8)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorValues.primaryBlue),
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                            SizedBox(
                              width: 168.w,
                              child: TextField(
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                    hintText: 'Zip Code',
                                    hintStyle: GoogleFonts.poppins(
                                        fontSize: 14,
                                        color: Colors.black26,
                                        fontWeight: FontWeight.w500),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color(0xffD6D6D6)),
                                        borderRadius: BorderRadius.circular(8)),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: ColorValues.primaryBlue),
                                        borderRadius:
                                            BorderRadius.circular(8))),
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Container(),
              SizedBox(height: 75.h),
              Container(
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
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text("Total: ",
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold)),
                          Text("Rp. " + widget.dataTrans.totalPrice,
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                      SizedBox(width: 70.w),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: ColorValues.primaryBlue,
                            foregroundColor: Colors.white,
                            minimumSize: Size(0.w, 40.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            _midtrans?.startPaymentUiFlow(
                              token: widget.dataMidtrans.snapToken,
                            );
                            SharedCode.navigatorPush(
                                context,
                                InvoicePage(
                                  dataTrans: widget.dataTrans,
                                ));
                          },
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('Bayar Sekarang',
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13)),
                              SizedBox(width: 5.w),
                              Icon(CupertinoIcons.money_dollar_circle)
                            ],
                          ))
                    ],
                  ),
                ),
              ),
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
            Text(widget.dataTrans.stayDuration)
          ],
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Electricity", style: GoogleFonts.roboto()),
            Text("Rp. " + widget.dataTrans.electricity)
          ],
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Room fees", style: GoogleFonts.roboto()),
            Text("Rp. " + widget.dataTrans.roomPrice)
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
                  child: Image.asset("assets/dummykos/kost_1.png",
                      fit: BoxFit.fill)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.dataTrans.kostName,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      SizedBox(height: 7.h),
                      DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        child: Text(widget.dataTrans.kostType,
                            style: GoogleFonts.inter(fontSize: 11)),
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded, size: 14),
                          Expanded(
                            child: Text(widget.dataTrans.location,
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

  Future _showDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogHelp();
      },
    );
  }
}
