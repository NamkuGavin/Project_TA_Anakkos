import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';

class BookingPage extends StatefulWidget {
  const BookingPage({Key? key}) : super(key: key);

  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String pemilikkost = "Julia";
  String date_dari = "";
  String date_sampai = "";
  DateTime selectedDate_dari = DateTime.now();
  DateTime selectedDate_sampai = DateTime.now();
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    date_dari = _dateFormat.format(selectedDate_dari);
    date_sampai = _dateFormat.format(selectedDate_sampai);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Summary", style: TextStyle(color: Colors.black)),
        leading: IconButton(
            onPressed: () {
              SharedCode.navigatorPop(context);
            },
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black)),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Choose your stay date:", style: GoogleFonts.lato(fontSize: 15)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 13),
            child: InkWell(
              onTap: () {
                _showDialog(context);
              },
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: ColorValues.primaryPurple,
                      width: 2.w // red as border color
                      ),
                  boxShadow: [
                    BoxShadow(color: Colors.grey, blurRadius: 8.0),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      date_dari + " - " + date_sampai,
                      style: TextStyle(
                          fontWeight: FontWeight.w400,
                          color: ColorValues.primaryPurple,
                          fontSize: 12),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Icon(Icons.keyboard_arrow_down_sharp,
                        size: 18, color: ColorValues.primaryPurple)
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: Card(
              color: Colors.white,
              elevation: 4,
              shadowColor: Colors.black,
              child: Row(
                children: [
                  Image.asset("assets/icon/Pemilik_kost.png", width: 75.w),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Kost dikelola oleh " + pemilikkost,
                          style: GoogleFonts.roboto(fontSize: 15)),
                      Text("Bergabung 19 Juli 2022",
                          style: GoogleFonts.roboto(fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Future _showDialog(context) async {
    return await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Text(
                  "Pilih Hari",
                  style: TextStyle(
                      fontSize: 12,
                      color: Color(0XFF2787BD),
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Dari Tanggal',
                            style: TextStyle(
                                color: Color(0xFF2787BD),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              _showDatePicker_dari(context);
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Color(0xFFC1DDED),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 30,
                              child: Center(
                                child: Text(date_dari.toString(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0XFF2787BD),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          )
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            'Sampai Tanggal',
                            style: TextStyle(
                                color: Color(0xFF2787BD),
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          ),
                          InkWell(
                            onTap: () {
                              _showDatePicker_sampai(context);
                            },
                            child: Container(
                              width: 100,
                              decoration: BoxDecoration(
                                  color: Color(0xFFC1DDED),
                                  borderRadius: BorderRadius.circular(10)),
                              height: 30,
                              child: Center(
                                child: Text(date_sampai.toString(),
                                    style: TextStyle(
                                        fontSize: 13,
                                        color: Color(0XFF2787BD),
                                        fontWeight: FontWeight.bold)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 120,
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all<Color>(Color(0xFF2787BD)),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12)))),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
                  ),
                )
              ]);
            },
          ),
        );
      },
    );
  }

  Future<void> _showDatePicker_dari(BuildContext context) async {
    final DateTime? selected_dari = await showDatePicker(
      context: context,
      initialDate: selectedDate_dari,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );
    // final DateTime? selected_sampai = await showDatePicker(
    //   context: context,
    //   initialDate: selectedDate_sampai,
    //   firstDate: DateTime(1970),
    //   lastDate: DateTime.now(),
    // );

    setState(() {
      if (selected_dari != null && selected_dari != selectedDate_dari) {
        selectedDate_dari = selected_dari;
        date_dari = _dateFormat.format(selected_dari);
      }
      // else if (selected_sampai != null &&
      //     selected_sampai != selectedDate_sampai) {
      //   selectedDate_sampai = selected_sampai;
      //   date_sampai = _dateFormat.format(selected_sampai);
      // }
    });
  }

  Future<void> _showDatePicker_sampai(BuildContext context) async {
    // final DateTime? selected_dari = await showDatePicker(
    //   context: context,
    //   initialDate: selectedDate_dari,
    //   firstDate: DateTime(1970),
    //   lastDate: DateTime.now(),
    // );
    final DateTime? selected_sampai = await showDatePicker(
      context: context,
      initialDate: selectedDate_sampai,
      firstDate: DateTime(1970),
      lastDate: DateTime.now(),
    );

    setState(() {
      // if (selected_dari != null && selected_dari != selectedDate_dari) {
      //   selectedDate_dari = selected_dari;
      //   date_dari = _dateFormat.format(selected_dari);
      // }
      if (selected_sampai != null && selected_sampai != selectedDate_sampai) {
        selectedDate_sampai = selected_sampai;
        date_sampai = _dateFormat.format(selected_sampai);
      }
    });
  }
}
