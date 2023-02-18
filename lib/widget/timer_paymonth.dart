import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';

class TimerPay extends StatefulWidget {
  const TimerPay({Key? key}) : super(key: key);

  @override
  State<TimerPay> createState() => _TimerPayState();
}

class _TimerPayState extends State<TimerPay> {
  var days1;
  var hours1;
  var mints1;
  var countdownDuration1 = Duration();
  Duration duration1 = Duration();
  Timer? timer1;
  bool countDown1 = true;

  @override
  void initState() {
    days1 = int.parse("03");
    hours1 = int.parse("00");
    mints1 = int.parse("00");
    countdownDuration1 = Duration(days: days1, hours: hours1, minutes: mints1);
    startTimer1();
    super.initState();
  }

  @override
  void deactivate() {
    if (timer1!.isActive) {
      timer1!.cancel();
      print('DEACTIVATE');
    } else {
      startTimer1();
      print('ACTIVATE');
    }
    super.deactivate();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
      SizedBox(
        height: 20.h,
      ),
      buildTime1(),
      SizedBox(
        height: 10.h,
      ),
      Text(
        "before payment expired",
        style: GoogleFonts.roboto(fontSize: 17),
      ),
    ]);
  }

  void startTimer1() {
    if (timer1 == null) {
      timer1 = Timer.periodic(Duration(seconds: 1), (_) => addTime1());
    }
    if (timer1!.isActive) {
      setState(() => duration1 = countdownDuration1);
    } else {
      setState(() => duration1 = Duration());
    }
  }

  void addTime1() {
    final addSeconds = 1;
    setState(() {
      final seconds = duration1.inSeconds - addSeconds;
      if (seconds < 0) {
        timer1?.cancel();
        print("TIME'S UP");
      } else {
        duration1 = Duration(seconds: seconds);
      }
    });
  }

  Widget buildTime1() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final days = twoDigits(duration1.inDays);
    final hours = twoDigits(duration1.inHours.remainder(24));
    final minutes = twoDigits(duration1.inMinutes.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: days, header: 'DAYS'),
      SizedBox(
        width: 8.w,
      ),
      buildTimeCard(time: hours, header: 'HOURS'),
      SizedBox(
        width: 8.w,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
    ]);
  }

  Widget buildTimeCard({required String time, required String header}) =>
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: Color(0xFFF8ECEC),
                borderRadius: BorderRadius.circular(10)),
            child: Text(
              time,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0XFF455A64),
                  fontSize: 35),
            ),
          ),
          SizedBox(
            height: 12.h,
          ),
          Text(header, style: TextStyle(color: Colors.black45, fontSize: 12)),
        ],
      );
}
