import 'package:anim_search_bar/anim_search_bar.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/fliter_model.dart';
import 'package:project_anakkos_app/dummy/dummywidget.dart';
import 'package:project_anakkos_app/widget/nearby_kost.dart';
import 'package:project_anakkos_app/widget/populer_kost.dart';

import '../dummy/dummy model/populer_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<KostDummyModel> items = [
    KostDummyModel("assets/dummykos/kost_1.png", "Laki-laki", "Kost Skywalker",
        "Besito, Gebog", "Rp. 750.000 / bulan", 4.0, 232),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Hokage",
        "Besito, Gebog", "Rp. 550.000 / bulan", 2.0, 111),
    KostDummyModel("assets/dummykos/kost_3.png", "Laki-laki", "Kost Apasaja",
        "Besito, Gebog", "Rp. 850.000 / bulan", 1.4, 90),
    KostDummyModel("assets/dummykos/kost_4.png", "Campuran", "Kost Subadi",
        "Besito, Gebog", "Rp. 750.000 / bulan", 1.7, 980),
  ];

  static List<FilterModel?> _animals = [
    FilterModel(id: 1, name: "AC"),
    FilterModel(id: 2, name: "Lemari"),
    FilterModel(id: 3, name: "Meja"),
    FilterModel(id: 4, name: "Laundry"),
    FilterModel(id: 5, name: "Jendela"),
    FilterModel(id: 6, name: "Wifi"),
    FilterModel(id: 7, name: "Kursi"),
    FilterModel(id: 8, name: "TV"),
    FilterModel(id: 9, name: "Bantal"),
    FilterModel(id: 10, name: "Kamar Mandi"),
    FilterModel(id: 11, name: "Dapur"),
    FilterModel(id: 12, name: "Kulkas"),
    FilterModel(id: 13, name: "> 10 x 10 m"),
    FilterModel(id: 14, name: "< 10 x 10 m"),
  ];
  final _items = _animals
      .map((filter) => MultiSelectItem<FilterModel?>(filter, filter!.name))
      .toList();
  List<FilterModel?> _selectedAnimals2 = [];
  final _seacrhController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // filterWidget(),
            SizedBox(height: 10.h),
            ongoingKost(),
            SizedBox(height: 20.h),
            popularKost(),
            nearbyKost(),
          ],
        ),
      ),
    );
  }

  appBarWidget() {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      actions: [
        AnimSearchBar(
          boxShadow: false,
          width: 375,
          textController: _seacrhController,
          onSuffixTap: () {
            setState(() {
              _seacrhController.clear();
            });
          }, onSubmitted: (String ) {
            print("hihihihiha");
        },
        ),
      ],
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: Container(
          color: Colors.black,
          height: 0.2.h,
        ),
      ),
    );
  }

  popularKost() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Popular kost",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              )),
          SizedBox(height: 10.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return DummyItems(
                model: items[index],
                index: index,
              );
            },
          ),
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorValues.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(20.w, 30.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  SharedCode.navigatorPush(context, PopulerKost());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lainnya', style: GoogleFonts.inter(fontSize: 12)),
                    Icon(Icons.double_arrow_rounded)
                  ],
                )),
          )
          // SizedBox(height: 10.h),
          // GestureDetector(
          //   onTap: () {
          //     SharedCode.navigatorPush(context, PopulerKost());
          //   },
          //   child: Row(
          //     crossAxisAlignment: CrossAxisAlignment.end,
          //     mainAxisAlignment: MainAxisAlignment.end,
          //     children: [
          //       Icon(Icons.add, size: 15),
          //       Text('Lainnya', style: GoogleFonts.inter(fontSize: 12))
          //     ],
          //   ),
          // )
        ],
      ),
    );
  }

  nearbyKost() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Near by kost",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              )),
          SizedBox(height: 10.h),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: 0.7,
              crossAxisCount: 2,
              crossAxisSpacing: 10.0,
              mainAxisSpacing: 10.0,
            ),
            itemCount: items.length,
            itemBuilder: (BuildContext context, int index) {
              return DummyItems(
                model: items[index],
                index: index,
              );
            },
          ),
          SizedBox(height: 5.h),
          Align(
            alignment: Alignment.bottomRight,
            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorValues.primaryBlue,
                  foregroundColor: Colors.white,
                  minimumSize: Size(20.w, 30.h),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  SharedCode.navigatorPush(context, NearByKost());
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lainnya', style: GoogleFonts.inter(fontSize: 12)),
                    Icon(Icons.double_arrow_rounded)
                  ],
                )),
          )
        ],
      ),
    );
  }

  filterWidget() {
    return MultiSelectDialogField<FilterModel?>(
      items: _items,
      title: Text("Select Filter"),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        border: Border.all(
          color: Colors.black,
          width: 2.w,
        ),
      ),
      buttonIcon: Icon(
        Icons.filter_alt_rounded,
        color: Colors.black,
      ),
      buttonText: Text("Filter",
          style: GoogleFonts.roboto(
            color: Colors.black,
            fontSize: 15,
          )),
      listType: MultiSelectListType.CHIP,
      searchable: true,
      onConfirm: (List<FilterModel?> values) {
        _selectedAnimals2 = values;
      },
      chipDisplay: MultiSelectChipDisplay(
        onTap: (value) {
          setState(() {
            _selectedAnimals2.remove(value);
          });
        },
      ),
    );
  }

  ongoingKost() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text("Ongoing kost",
              style: GoogleFonts.inter(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              )),
          SizedBox(height: 10.h),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.8),
                  spreadRadius: 2,
                  blurRadius: 5, // changes position of shadow
                ),
              ],
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.horizontal(left: Radius.circular(10)),
                    child: Container(
                        height: 150.h,
                        width: 100.w,
                        child: Image.asset("assets/dummykos/kost_2.png",
                            fit: BoxFit.fill)),
                  ),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0XFFFD9900),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5))),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 5),
                                  child: Text("Pending",
                                      style: GoogleFonts.inter(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 11)),
                                ),
                              ),
                              Text("17 August 2022 ",
                                  style: GoogleFonts.roboto(fontSize: 12)),
                            ],
                          ),
                          SizedBox(height: 7.h),
                          Text("Kost Duniawi",
                              style: GoogleFonts.inter(
                                  fontWeight: FontWeight.bold, fontSize: 12)),
                          SizedBox(height: 7.h),
                          Text("Total : Rp. 568.400",
                              style: GoogleFonts.roboto(fontSize: 12)),
                          SizedBox(height: 7.h),
                          Text("Stay duration: 27 Aug - 27 Sep",
                              style: GoogleFonts.roboto(fontSize: 12)),
                          Align(
                            alignment: Alignment.bottomLeft,
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  side: BorderSide(
                                      width: 1,
                                      color: ColorValues.primaryPurple),
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  minimumSize: Size(0.w, 25.h),
                                ),
                                onPressed: () {},
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text('Chat Pemilik Kost',
                                        style: GoogleFonts.inter(fontSize: 10)),
                                    SizedBox(width: 5.w),
                                    Icon(CupertinoIcons.chat_bubble_text_fill,
                                        size: 15)
                                  ],
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
