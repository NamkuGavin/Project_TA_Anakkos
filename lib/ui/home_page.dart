import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/dummy/dummywidget.dart';

import '../dummy/dummy model/populer_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<KostDummyModel> items = [
    KostDummyModel("assets/dummykos/kost_1.png", "Laki-laki", "Kost Skywalker",
        "Besito, Gebog", "Rp. 750.000 / bulan"),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Hokage",
        "Besito, Gebog", "Rp. 550.000 / bulan"),
    KostDummyModel("assets/dummykos/kost_3.png", "Laki-laki", "Kost Apasaja",
        "Besito, Gebog", "Rp. 850.000 / bulan"),
    KostDummyModel("assets/dummykos/kost_4.png", "Campuran", "Kost Subadi",
        "Besito, Gebog", "Rp. 750.000 / bulan"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: SingleChildScrollView(
          child: Column(
            children: [
              popularKost(),
              nearbyKost(),
            ],
          ),
        ),
      ),
    );
  }

  appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          color: Colors.black,
          height: 2.h,
        ),
      ),
      actions: [
        IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.bookmark,
              color: HexColor("#F8ECEC"),
            ))
      ],
    );
  }

  popularKost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Popular kost",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        SizedBox(height: 10.h),
        Container(
          height: 420.h,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return DummyItems(model: items[index]);
            },
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: ColorValues.primaryPurple,
              onPrimary: Colors.white,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: Text('More',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold)))
      ],
    );
  }

  nearbyKost() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Near by kost",
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w500,
              fontSize: 14,
            )),
        Container(
          height: 420.h,
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return DummyItems(model: items[index]);
            },
          ),
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              primary: ColorValues.primaryPurple,
              onPrimary: Colors.white,
              minimumSize: Size(double.infinity, 50.h),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () {},
            child: Text('More',
                style: GoogleFonts.inter(fontWeight: FontWeight.bold)))
      ],
    );
  }
}
