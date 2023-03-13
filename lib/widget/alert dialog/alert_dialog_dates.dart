import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/model/login_model.dart';
import 'package:project_anakkos_app/model/start_trans_model.dart';
import 'package:project_anakkos_app/ui-User/booking_page.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class AlertDialogDates extends StatefulWidget {
  final String idKost;
  final KostbyLocationData model;
  AlertDialogDates({Key? key, required this.idKost, required this.model})
      : super(key: key);

  @override
  State<AlertDialogDates> createState() => _AlertDialogDatesState();
}

class _AlertDialogDatesState extends State<AlertDialogDates> {
  String date_dari = "";
  DateTime selectedDate_dari = DateTime.now();
  DateTime? selected_dari;
  DateTime? selected_sampai;
  DateTime? dueDate;
  final DateFormat _dateFormat = DateFormat('dd-MM-yyyy');
  final DateFormat _dateFormatAPI = DateFormat('dd MMM yyyy');
  bool _isLoad = false;
  StartTransData? dataTrans;
  StartTransModel? dataMidtrans;
  MidtransSDK? _midtrans;

  Future startTrans() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      _isLoad = true;
    });
    LoginModel result = await ApiService().getLogin(
        email: pref.getString("email_user").toString(),
        password: pref.getString("pass_user").toString());
    StartTransModel start = await ApiService().startTransaksi(
        token: result.token,
        user_id: result.data.id.toString(),
        stay_duration: _dateFormatAPI.format(selected_dari!) +
            " - " +
            _dateFormatAPI.format(selected_sampai!),
        due_date: _dateFormatAPI.format(dueDate!),
        kost_id: widget.idKost);
    pref.setString("token_snapMidtrans", start.snapToken);
    setState(() {
      dataTrans = start.data;
      dataMidtrans = start;
      _isLoad = false;
    });
  }

  @override
  void initState() {
    date_dari = _dateFormat.format(selectedDate_dari);
    super.initState();
  }

  @override
  void dispose() {
    _midtrans?.removeTransactionFinishedCallback();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.zero,
      content: _isLoad
          ? LoadingAnimation()
          : Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
              Text(
                "Pilih Waktu Sewa:",
                style: TextStyle(
                    fontSize: 15,
                    color: ColorValues.primaryBlue,
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20.h),
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
              SizedBox(height: 25.h),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorValues.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(125.w, 33.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () async {
                  if (selected_dari == null) {
                    setState(() {
                      selected_dari = DateTime.now();
                      selected_sampai = DateTime(selectedDate_dari.year,
                              selectedDate_dari.month, selectedDate_dari.day)
                          .add(Duration(days: 31));
                      dueDate = DateTime(selected_sampai!.year,
                              selected_sampai!.month, selected_sampai!.day)
                          .add(Duration(days: 3));
                    });
                    print("DATES: " +
                        selected_dari.toString() +
                        " - " +
                        selected_sampai.toString());
                    await startTrans();
                    await SharedCode.navigatorPush(
                        context,
                        BookingPage(
                          model: widget.model,
                          dataTrans: dataTrans!,
                          dataMidtrans: dataMidtrans!,
                        ));
                  } else {
                    setState(() {
                      selected_sampai = DateTime(selectedDate_dari.year,
                              selectedDate_dari.month, selectedDate_dari.day)
                          .add(Duration(days: 31));
                      dueDate = DateTime(selected_sampai!.year,
                              selected_sampai!.month, selected_sampai!.day)
                          .add(Duration(days: 3));
                    });
                    print("DATES: " +
                        selected_dari.toString() +
                        " - " +
                        selected_sampai.toString());
                    await startTrans();
                    await SharedCode.navigatorPush(
                        context,
                        BookingPage(
                          dataTrans: dataTrans!,
                          dataMidtrans: dataMidtrans!,
                          model: widget.model,
                        ));
                  }
                },
                child: Text(
                  'Book Now',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13),
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
}
