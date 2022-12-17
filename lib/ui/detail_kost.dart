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
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            detailHeader(),
            Divider(
              color: Colors.grey[400],
              thickness: 1,
            ),
            detailFasilitas(),
          ],
        ),
      ),
    );
  }

  detailHeader() {
    return Padding(
      padding: EdgeInsets.only(bottom: 8),
      child: Column(
        children: [
          Container(
              width: double.infinity,
              child: Image.asset(widget.model.picture_kost,
                  fit: BoxFit.cover, height: 300.h)),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.model.name_kost,
                        style: GoogleFonts.roboto(fontSize: 20)),
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
                      child: Padding(
                        padding: EdgeInsets.all(3),
                        child: Text(widget.model.type_kost,
                            style: GoogleFonts.roboto(fontSize: 13)),
                      ),
                    ),
                    SizedBox(width: 15.w),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on_rounded, size: 13),
                        SizedBox(width: 5.w),
                        Text(widget.model.location_kost,
                            style: GoogleFonts.inter(fontSize: 10))
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  detailFasilitas() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
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
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => buildSheet(),
                  );
                },
                child: Text('Lihat semua fasilitas di kamar ini',
                    style: GoogleFonts.inter(fontWeight: FontWeight.bold))),
          )
        ],
      ),
    );
  }

  buildSheet() {
    return makeDismissible(
      child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.vertical(top: Radius.circular(20))),
              padding: EdgeInsets.all(12),
              child: ListView(
                controller: controller,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text("Fasilitas Kamar"),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Cube.svg")),
                        Expanded(flex: 7, child: Text("5x4 meter")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                SvgPicture.asset("assets/icon/Electric.svg")),
                        Expanded(flex: 7, child: Text("Termasuk Listrik")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Bed.svg")),
                        Expanded(flex: 7, child: Text("Kasur (Spring)")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Wind.svg")),
                        Expanded(flex: 7, child: Text("AC")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Table.svg")),
                        Expanded(flex: 7, child: Text("Meja")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                SvgPicture.asset("assets/icon/Cupboard.svg")),
                        Expanded(flex: 7, child: Text("Lemari")),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  makeDismissible({required Widget child}) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        SharedCode.navigatorPop(context);
      },
      child: GestureDetector(onTap: () {}, child: child),
    );
  }
}
