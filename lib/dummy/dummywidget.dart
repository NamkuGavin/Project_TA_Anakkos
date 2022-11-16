import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';

import 'dummy model/populer_model.dart';

class DummyItems extends StatefulWidget {
  final KostDummyModel model;
  DummyItems({Key? key, required this.model}) : super(key: key);

  @override
  State<DummyItems> createState() => _DummyItemsState();
}

class _DummyItemsState extends State<DummyItems> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {},
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
      ),
    );
  }
}
