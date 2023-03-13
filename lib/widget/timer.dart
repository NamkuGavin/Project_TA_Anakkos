import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';

class TimerWidget extends StatefulWidget {
  const TimerWidget({Key? key}) : super(key: key);

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  var hours1;
  var mints1;
  var secs1;
  var countdownDuration1 = Duration();
  Duration duration1 = Duration();
  Timer? timer1;
  bool countDown1 = true;

  @override
  void initState() {
    hours1 = int.parse("24");
    mints1 = int.parse("00");
    secs1 = int.parse("00");
    countdownDuration1 =
        Duration(hours: hours1, minutes: mints1, seconds: secs1);
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
    final hours = twoDigits(duration1.inHours);
    final minutes = twoDigits(duration1.inMinutes.remainder(60));
    final seconds = twoDigits(duration1.inSeconds.remainder(60));
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      buildTimeCard(time: hours, header: 'HOURS'),
      SizedBox(
        width: 8.w,
      ),
      buildTimeCard(time: minutes, header: 'MINUTES'),
      SizedBox(
        width: 8.w,
      ),
      buildTimeCard(time: seconds, header: 'SECONDS'),
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
