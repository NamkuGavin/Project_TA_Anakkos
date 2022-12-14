import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/ui/detail_kost.dart';

import 'dummy model/populer_model.dart';

class DummyItems extends StatefulWidget {
  final KostDummyModel model;
  final int index;
  DummyItems({Key? key, required this.model, required this.index})
      : super(key: key);

  @override
  State<DummyItems> createState() => _DummyItemsState();
}

class _DummyItemsState extends State<DummyItems> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        print("INDEX: " + widget.index.toString());
        SharedCode.navigatorPush(context, DetailKost(model: widget.model));
      },
      child: Card(
        color: Colors.white,
        elevation: 4,
        shadowColor: Colors.black,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
                child:
                    Image.asset(widget.model.picture_kost, fit: BoxFit.cover),
                aspectRatio: 2),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 5.h),
                  DottedBorder(
                    color: Colors.black,
                    strokeWidth: 1,
                    child: Text(widget.model.type_kost,
                        style: GoogleFonts.inter(fontSize: 10)),
                  ),
                  SizedBox(height: 5.h),
                  Text(widget.model.name_kost,
                      style: GoogleFonts.inter(fontSize: 10)),
                  SizedBox(height: 5.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.location_on_rounded, size: 13),
                      Text(widget.model.location_kost,
                          style: GoogleFonts.inter(fontSize: 10))
                    ],
                  ),
                  SizedBox(height: 5.h),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(widget.model.price_kost,
                        style: GoogleFonts.inter(fontSize: 10)),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
