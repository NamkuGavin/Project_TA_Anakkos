import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui/booking_page.dart';

class AlertDialogDates extends StatefulWidget {
  const AlertDialogDates({Key? key}) : super(key: key);

  @override
  State<AlertDialogDates> createState() => _AlertDialogDatesState();
}

class _AlertDialogDatesState extends State<AlertDialogDates> {
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
    return AlertDialog(
      content: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        Text(
          "Choose your stay date:",
          style: TextStyle(
              fontSize: 12,
              color: ColorValues.primaryBlue,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
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
                      width: 100,
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
                      width: 100,
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
        ),
        Container(
          width: 120,
          child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(ColorValues.primaryBlue),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)))),
            onPressed: () {
              SharedCode.navigatorPush(context, BookingPage());
            },
            child: Text(
              'Book Now',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),
          ),
        )
      ]),
    );
  }

  Future<void> _showDatePicker_dari(BuildContext context) async {
    final DateTime? selected_dari = await showDatePicker(
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
        selectedDate_dari = selected_dari;
        date_dari = _dateFormat.format(selected_dari);
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
    final DateTime? selected_sampai = await showDatePicker(
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
        selectedDate_sampai = selected_sampai;
        date_sampai = _dateFormat.format(selected_sampai);
      });
    }
  }
}
