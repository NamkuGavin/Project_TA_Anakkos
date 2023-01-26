import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/ui-User/booking_page.dart';

class AlertDialogDates extends StatefulWidget {
  final KostDummyModel model;
  AlertDialogDates({Key? key, required this.model}) : super(key: key);

  @override
  State<AlertDialogDates> createState() => _AlertDialogDatesState();
}

class _AlertDialogDatesState extends State<AlertDialogDates> {
  String date_dari = "";
  String date_sampai = "";
  DateTime selectedDate_dari = DateTime.now();
  DateTime selectedDate_sampai = DateTime.now();
  DateTime? selected_dari;
  DateTime? selected_sampai;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');

  @override
  void initState() {
    date_dari = _dateFormat.format(selectedDate_dari);
    date_sampai = _dateFormat.format(selectedDate_sampai);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text(
          "Pilih Waktu Sewa:",
          style: TextStyle(
              fontSize: 15,
              color: ColorValues.primaryBlue,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 20.h),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Dari Tanggal',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showDatePicker_dari(context);
                  },
                  child: Container(
                    width: 110.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorValues.primaryPurple, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 30,
                    child: Center(
                      child: Text(date_dari.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              color: ColorValues.primaryPurple,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                )
              ],
            ),
            SizedBox(width: 25.w),
            Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    'Sampai Tanggal',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
                InkWell(
                  onTap: () {
                    _showDatePicker_sampai(context);
                  },
                  child: Container(
                    width: 110.w,
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: ColorValues.primaryPurple, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 3,
                          ),
                        ],
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    height: 30,
                    child: Center(
                      child: Text(date_sampai.toString(),
                          style: TextStyle(
                              fontSize: 13,
                              color: ColorValues.primaryPurple,
                              fontWeight: FontWeight.bold)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        SizedBox(height: 25.h),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorValues.primaryBlue,
            foregroundColor: Colors.white,
            minimumSize: Size(125.w, 33.h),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          ),
          onPressed: () {
            if (selected_sampai == null && selected_dari == null) {
              setState(() {
                selected_dari = DateTime.now();
                selected_sampai = DateTime.now();
              });
              print("DATES: " +
                  selected_dari.toString() +
                  " - " +
                  selected_sampai.toString());
              SharedCode.navigatorPush(
                  context,
                  BookingPage(
                    model: widget.model,
                    dateSampai: selected_sampai!,
                    dateDari: selected_dari!,
                  ));
            } else if (selected_dari == null) {
              setState(() {
                selected_dari = DateTime.now();
              });
              print("DATES: " +
                  selected_dari.toString() +
                  " - " +
                  selected_sampai.toString());
              SharedCode.navigatorPush(
                  context,
                  BookingPage(
                    model: widget.model,
                    dateSampai: selected_sampai!,
                    dateDari: selected_dari!,
                  ));
            } else if (selected_sampai == null) {
              setState(() {
                selected_sampai = DateTime.now();
              });
              print("DATES: " +
                  selected_dari.toString() +
                  " - " +
                  selected_sampai.toString());
              SharedCode.navigatorPush(
                  context,
                  BookingPage(
                    model: widget.model,
                    dateSampai: selected_sampai!,
                    dateDari: selected_dari!,
                  ));
            } else {
              print("DATES: " +
                  selected_dari.toString() +
                  " - " +
                  selected_sampai.toString());
              SharedCode.navigatorPush(
                  context,
                  BookingPage(
                    model: widget.model,
                    dateSampai: selected_sampai!,
                    dateDari: selected_dari!,
                  ));
            }
          },
          child: Text(
            'Book Now',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
        )
      ]),
    );
  }

  Future<void> _showDatePicker_dari(BuildContext context) async {
    selected_dari = await showDatePicker(
      context: context,
      initialDate: selectedDate_dari,
      firstDate: DateTime(1970),
      lastDate: DateTime(2030),
    );
    // final DateTime? selected_sampai = await showDatePicker(
    //   context: context,
    //   initialDate: selectedDate_sampai,
    //   firstDate: DateTime(1970),
    //   lastDate: DateTime.now(),
    // );

    if (selected_dari != null && selected_dari != selectedDate_dari) {
      setState(() {
        selectedDate_dari = selected_dari!;
        date_dari = _dateFormat.format(selected_dari!);
        // else if (selected_sampai != null &&
        //     selected_sampai != selectedDate_sampai) {
        //   selectedDate_sampai = selected_sampai;
        //   date_sampai = _dateFormat.format(selected_sampai);
        // }
      });
    }
  }

  Future<void> _showDatePicker_sampai(BuildContext context) async {
    // final DateTime? selected_dari = await showDatePicker(
    //   context: context,
    //   initialDate: selectedDate_dari,
    //   firstDate: DateTime(1970),
    //   lastDate: DateTime.now(),
    // );
    selected_sampai = await showDatePicker(
      context: context,
      initialDate: selectedDate_sampai,
      firstDate: DateTime(1970),
      lastDate: DateTime(2030),
    );

    if (selected_sampai != null && selected_sampai != selectedDate_sampai) {
      setState(() {
        // if (selected_dari != null && selected_dari != selectedDate_dari) {
        //   selectedDate_dari = selected_dari;
        //   date_dari = _dateFormat.format(selected_dari);
        // }
        selectedDate_sampai = selected_sampai!;
        date_sampai = _dateFormat.format(selected_sampai!);
      });
    }
  }
}
