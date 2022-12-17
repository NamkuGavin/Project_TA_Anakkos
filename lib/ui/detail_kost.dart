import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';

class DetailKost extends StatefulWidget {
  final KostDummyModel model;
  DetailKost({Key? key, required this.model}) : super(key: key);

  @override
  State<DetailKost> createState() => _DetailKostState();
}

class _DetailKostState extends State<DetailKost> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorValues.primaryPurple,
        mini: true,
        onPressed: () {
          SharedCode.navigatorPop(context);
        },
        child: Icon(Icons.arrow_back_rounded, size: 17),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startTop,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailHeader(),
            detailFasilitas(),
          ],
        ),
      ),
    );
  }

  detailHeader() {
    return Column(
      children: [
        Container(
            width: double.infinity,
            child: Image.asset(widget.model.picture_kost,
                fit: BoxFit.cover, height: 300.h)),
        Card(
            color: Colors.white,
            elevation: 4,
            shadowColor: Colors.black,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(widget.model.name_kost),
                      IconButton(
                          onPressed: () {},
                          icon: Icon(Icons.bookmark, color: Colors.grey[300]))
                    ],
                  ),
                  Row(
                    children: [
                      DottedBorder(
                        color: Colors.black,
                        strokeWidth: 1,
                        child: Text(widget.model.type_kost),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.location_on_rounded, size: 13),
                          Text(widget.model.location_kost,
                              style: GoogleFonts.inter(fontSize: 10))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ))
      ],
    );
  }

  detailFasilitas() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Text("Fasilitas Kamar"),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Cube.svg")),
                Expanded(flex: 7, child: Text("5x4 meter")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Electric.svg")),
                Expanded(flex: 7, child: Text("Termasuk Listrik")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Bed.svg")),
                Expanded(flex: 7, child: Text("Kasur (Spring)")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Wind.svg")),
                Expanded(flex: 7, child: Text("AC")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Table.svg")),
                Expanded(flex: 7, child: Text("Meja")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Expanded(child: SvgPicture.asset("assets/icon/Cupboard.svg")),
                Expanded(flex: 7, child: Text("Lemari")),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 6),
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 2, color: ColorValues.primaryPurple),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {},
                child: Text('Lihat semua fasilitas di kamar ini',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }
}
