import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui-Seller/home_seller.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_seller.dart';

class AlertDialogConfirmSeller extends StatefulWidget {
  const AlertDialogConfirmSeller({Key? key}) : super(key: key);

  @override
  State<AlertDialogConfirmSeller> createState() =>
      _AlertDialogConfirmSellerState();
}

class _AlertDialogConfirmSellerState extends State<AlertDialogConfirmSeller> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text("Apakah kamu ingin menyewa kos ini ?",
                textAlign: TextAlign.center),
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    minimumSize: Size(0.w, 0.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    SharedCode.navigatorPop(context);
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.close),
                        SizedBox(width: 10.w),
                        Text('Tidak', style: GoogleFonts.inter(fontSize: 12)),
                      ],
                    ),
                  )),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    minimumSize: Size(0.w, 0.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () {
                    SharedCode.navigatorReplacement(
                        context, NavigationWidgetBarSeller());
                  },
                  child: Padding(
                    padding: EdgeInsets.all(8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Iya', style: GoogleFonts.inter(fontSize: 12)),
                        SizedBox(width: 10.w),
                        Icon(Icons.check)
                      ],
                    ),
                  )),
            ],
          )
        ],
      ),
    );
  }
}
