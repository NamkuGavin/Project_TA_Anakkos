import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/ui/konfirmasi_page.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_help.dart';
import 'package:project_anakkos_app/widget/custom_text_field.dart';
import 'package:project_anakkos_app/widget/timer.dart';

class BookingPage extends StatefulWidget {
  final KostDummyModel model;
  final DateTime dateDari;
  final DateTime dateSampai;
  BookingPage(
      {Key? key,
      required this.model,
      required this.dateDari,
      required this.dateSampai})
      : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  final _noKartuController = TextEditingController();
  String tanggal_dari = "";
  String tanggal_sampai = "";
  final DateFormat _dateFormat = DateFormat('dd MMM yyyy');
  int detail1 = 55000;
  int detail2 = 13400;
  int detail3 = 500000;

  @override
  void initState() {
    tanggal_dari = _dateFormat.format(widget.dateDari);
    tanggal_sampai = _dateFormat.format(widget.dateSampai);
    super.initState();
  }

  Future _takePicture(BuildContext context) async {
    final navigator = Navigator.of(context);
    final ImagePicker picker = ImagePicker();
    XFile? pickedImage;

    try {
      pickedImage = await picker.pickImage(
          source: ImageSource.camera,
          preferredCameraDevice: CameraDevice.front);

      if (pickedImage != null) {
        await navigator.push(
          MaterialPageRoute(
            builder: (context) =>
                KonfirmasiPhotoPage(imagePath: pickedImage!.path),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("No image was selected"),
          ),
        );
      }
    } catch (e) {
      print(e);
      print("error");
    }
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
      ),
      body: Column(
        children: [
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimerWidget(),
                    SizedBox(height: 40.h),
                    Text(
                      'Bank account number',
                      style: GoogleFonts.roboto(
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 7.h),
                    CustomTextField(
                      isEnable: true,
                      isreadOnly: false,
                      controller: _noKartuController,
                      inputType: TextInputType.number,
                      validator: (value) =>
                          SharedCode().emptyNoValidator(value),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),
                    Card(
                        color: Colors.white,
                        elevation: 4,
                        shadowColor: Colors.black,
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Total payment",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.bold)),
                                  Text("Rp. " +
                                      NumberFormat()
                                          .format(detail1 + detail2 + detail3))
                                ],
                              ),
                            ],
                          ),
                        ))
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: Container(
                decoration: BoxDecoration(
                    border: Border(
                        top: BorderSide(color: Colors.black, width: 2.w))),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                              "Total: " +
                                  "Rp. " +
                                  NumberFormat()
                                      .format(detail1 + detail2 + detail3),
                              style: GoogleFonts.roboto(
                                  fontWeight: FontWeight.bold)),
                          GestureDetector(
                            onTap: () {
                              _showDialog(context);
                            },
                            child: SvgPicture.asset("assets/icon/Help.svg"),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: ColorValues.primaryPurple,
                            onPrimary: Colors.white,
                            minimumSize: Size(double.infinity, 50.h),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                          onPressed: () {
                            _takePicture(context);
                          },
                          child: Text('Pay Now',
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold))),
                    ),
                  ],
                )),
          ),
        ],
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
            Text(tanggal_dari + " - " + tanggal_sampai)
          ],
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Electricity", style: GoogleFonts.roboto()),
            Text("Rp. " + NumberFormat().format(detail1))
          ],
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Tax 10% & other fees", style: GoogleFonts.roboto()),
            Text("Rp. " + NumberFormat().format(detail2))
          ],
        ),
        SizedBox(height: 7.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Room fees", style: GoogleFonts.roboto()),
            Text("Rp. " + NumberFormat().format(detail3))
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
        Text("Payment summary"),
        SizedBox(height: 5.h),
        IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 100.w,
                  child:
                      Image.asset(widget.model.picture_kost, fit: BoxFit.fill)),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(widget.model.name_kost,
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 12)),
                      SizedBox(height: 7.h),
                      DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        child: Text(widget.model.type_kost,
                            style: GoogleFonts.inter(fontSize: 11)),
                      ),
                      SizedBox(height: 7.h),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded, size: 14),
                          Text(widget.model.location_kost,
                              style: GoogleFonts.inter(fontSize: 11))
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
