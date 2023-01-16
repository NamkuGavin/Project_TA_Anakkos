import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

class AlertDialogHelp extends StatefulWidget {
  const AlertDialogHelp({Key? key}) : super(key: key);

  @override
  State<AlertDialogHelp> createState() => _AlertDialogHelpState();
}

class _AlertDialogHelpState extends State<AlertDialogHelp> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(child: SvgPicture.asset("assets/icon/Help.svg", height: 50.h)),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Center(child: Text("How to pay")),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("1. Go to your nearest atm machine",
                style: GoogleFonts.roboto()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text(
                "2. Transfer the payment amount to the owner bank account (Shown above)",
                style: GoogleFonts.roboto()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("3. Take a photo of the transfer receipt",
                style: GoogleFonts.roboto()),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 4),
            child: Text("4. Wait for the owner to verify your payment",
                style: GoogleFonts.roboto()),
          ),
        ],
      ),
    );
  }
}
