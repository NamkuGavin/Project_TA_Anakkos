import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/helper/check_status.dart';

class AlertDialogFilter extends StatefulWidget {
  const AlertDialogFilter({Key? key}) : super(key: key);

  @override
  State<AlertDialogFilter> createState() => _AlertDialogFilterState();
}

class _AlertDialogFilterState extends State<AlertDialogFilter> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      content: Builder(builder: (context) {
        return SizedBox(
          height: 425.h,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Filter Fasilitas",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: Colors.black,
                      fontSize: 16)),
              SizedBox(height: 25.h),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Tempat Tidur',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45,
                                  fontSize: 14)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.bantal,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.bantal = value!;
                                  });
                                },
                              ),
                              Text("Bantal", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.kasur,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kasur = value!;
                                  });
                                },
                              ),
                              Text("Kasur", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(color: Colors.black),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Kamar mandi',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45,
                                  fontSize: 14)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.kamarMandi,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kamarMandi = value!;
                                  });
                                },
                              ),
                              Text("Luar", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.laundry,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.laundry = value!;
                                  });
                                },
                              ),
                              Text("Dalam", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 7.h),
              Divider(color: Colors.black),
              SizedBox(height: 7.h),
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Lain - lain',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45,
                                  fontSize: 14)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.lemari,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.lemari = value!;
                                  });
                                },
                              ),
                              Text("Lemari", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.meja,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.meja = value!;
                                  });
                                },
                              ),
                              Text("Meja", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.kursi,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kursi = value!;
                                  });
                                },
                              ),
                              Text("Kursi", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    VerticalDivider(color: Colors.black),
                    Padding(
                      padding: EdgeInsets.only(left: 12),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Sirkulasi Udara',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black45,
                                  fontSize: 14)),
                          SizedBox(height: 4.h),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.kipas,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.kipas = value!;
                                  });
                                },
                              ),
                              Text("Kipas", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: CheckStatus.ac,
                                onChanged: (bool? value) {
                                  setState(() {
                                    CheckStatus.ac = value!;
                                  });
                                },
                              ),
                              Text("AC", style: TextStyle(fontSize: 14)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: Container()),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorValues.primaryPurple,
                      foregroundColor: Colors.white,
                      minimumSize: Size(0.w, 0.h),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                    ),
                    onPressed: () {},
                    child: Padding(
                      padding: EdgeInsets.all(8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('Tampilkan Hasil', style: GoogleFonts.inter(fontSize: 14)),
                          SizedBox(width: 10.w),
                          Icon(Icons.save)
                        ],
                      ),
                    )),
              ),
            ],
          ),
        );
      }),
    );
  }
}
