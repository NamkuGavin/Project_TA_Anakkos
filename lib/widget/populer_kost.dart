import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/model/kost_by_popu_model.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';

class PopulerKost extends StatefulWidget {
  final String location;
  PopulerKost({Key? key, required this.location}) : super(key: key);

  @override
  State<PopulerKost> createState() => _PopulerKostState();
}

class _PopulerKostState extends State<PopulerKost> {
  bool _isLoad = false;
  List<KostbyPopularData>? dataKostbyPopular;
  List<KostDummyModel> popular = [
    KostDummyModel("assets/dummykos/kost_1.png", "Laki-laki", "Kost Skywalker",
        "Besito, Gebog", "Rp. 750.000 / bulan", 3.0, 243),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Hokage",
        "Besito, Gebog", "Rp. 550.000 / bulan", 2.0, 565),
    KostDummyModel("assets/dummykos/kost_3.png", "Laki-laki", "Kost Apasaja",
        "Besito, Gebog", "Rp. 850.000 / bulan", 5.0, 398),
    KostDummyModel("assets/dummykos/kost_4.png", "Campuran", "Kost Subadi",
        "Besito, Gebog", "Rp. 750.000 / bulan", 3.4, 745),
    KostDummyModel("assets/dummykos/kost_3.png", "Campuran", "Kost Pelangi",
        "Besito, Gebog", "Rp. 800.000 / bulan", 3.5, 321),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Star",
        "Besito, Gebog", "Rp. 900.000 / bulan", 3.7, 121),
    KostDummyModel("assets/dummykos/kost_1.png", "Perempuan", "Kost Taman",
        "Besito, Gebog", "Rp. 1.000.000 / bulan", 4.6, 111),
    KostDummyModel("assets/dummykos/kost_4.png", "Laki-laki", "Kost Regency",
        "Besito, Gebog", "Rp. 600.000 / bulan", 5.0, 123),
  ];

  Future getKostbyPopular() async {
    setState(() {
      _isLoad = true;
    });
    KostbyPopularModel _model =
        await ApiService().getKostbyPopu(location: widget.location);
    setState(() {
      dataKostbyPopular = _model.data;
      _isLoad = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKostbyPopular();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: _isLoad
            ? LoadingAnimation()
            : SingleChildScrollView(
                child: Stack(
                  children: [
                    Column(
                      children: [
                        headerAppbar(),
                        bodyList(),
                      ],
                    ),
                    Positioned(
                        top: 25,
                        left: 20,
                        child: Padding(
                          padding: EdgeInsets.only(left: 8),
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: Container(
                              height: 50.h,
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.3),
                                      spreadRadius: 2,
                                      blurRadius: 5,
                                      offset: Offset(
                                          0, 3), // changes position of shadow
                                    ),
                                  ],
                                  color: Colors.white),
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Center(
                                  child: Icon(Icons.arrow_back_ios_rounded),
                                ),
                              ),
                            ),
                          ),
                        )),
                  ],
                ),
              ),
        // Padding(
        //         padding: EdgeInsets.all(8.0),
        //         child: GridView.builder(
        //           gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        //             childAspectRatio: 0.57,
        //             crossAxisCount: 2,
        //             crossAxisSpacing: 10.0,
        //             mainAxisSpacing: 10.0,
        //           ),
        //           itemCount: dataKostbyPopular!.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             return InkWell(
        //               onTap: () {
        //                 // SharedCode.navigatorPush(context, DetailKost(model: widget.model));
        //               },
        //               child: Card(
        //                 color: Colors.white,
        //                 elevation: 5,
        //                 shadowColor: Colors.black,
        //                 child: Column(
        //                   crossAxisAlignment: CrossAxisAlignment.start,
        //                   children: [
        //                     SizedBox(
        //                       height: 125.h,
        //                       width: 150.w,
        //                       child: ClipRRect(
        //                           borderRadius: BorderRadius.vertical(
        //                               bottom: Radius.circular(10)),
        //                           child: Image.network(
        //                               dataKostbyPopular![index].coverImg,
        //                               fit: BoxFit.cover)),
        //                     ),
        //                     Padding(
        //                       padding: EdgeInsets.symmetric(horizontal: 4),
        //                       child: Column(
        //                         crossAxisAlignment: CrossAxisAlignment.start,
        //                         children: [
        //                           SizedBox(height: 12.h),
        //                           DottedBorder(
        //                             color: Colors.black,
        //                             strokeWidth: 1,
        //                             child: Text(
        //                                 dataKostbyPopular![index].kostType,
        //                                 style: GoogleFonts.inter(fontSize: 11)),
        //                           ),
        //                           SizedBox(height: 4.h),
        //                           Text(dataKostbyPopular![index].kostName,
        //                               style: GoogleFonts.inter(fontSize: 11)),
        //                           SizedBox(height: 4.h),
        //                           Row(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             children: [
        //                               Icon(Icons.location_on_rounded, size: 13),
        //                               Expanded(
        //                                 child: Text(
        //                                     dataKostbyPopular![index].location,
        //                                     style:
        //                                         GoogleFonts.inter(fontSize: 11)),
        //                               )
        //                             ],
        //                           ),
        //                           SizedBox(height: 6.h),
        //                           Align(
        //                             alignment: Alignment.bottomRight,
        //                             child: Text(
        //                                 "Rp. " +
        //                                     dataKostbyPopular![index]
        //                                         .roomPrice
        //                                         .toString() +
        //                                     " / Bulan",
        //                                 style: GoogleFonts.inter(fontSize: 11)),
        //                           )
        //                         ],
        //                       ),
        //                     )
        //                   ],
        //                 ),
        //               ),
        //             );
        //           },
        //         ),
        //       ),
      ),
    );
  }

  headerAppbar() {
    return Container(
      height: 50.h,
      width: double.infinity,
      color: Color(0xFFECECEC),
    );
  }

  bodyList() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 40.h),
          Text("More of “Popular”", style: TextStyle(fontSize: 16)),
          SizedBox(height: 10.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dataKostbyPopular!.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(13)),
                        child: Container(
                            width: 110.w,
                            child: Image.network(
                                dataKostbyPopular![index].coverImg,
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
                                children: [
                                  dataKostbyPopular![index].kostType == "Cowok"
                                      ? SvgPicture.asset(
                                          "assets/icon/cowok.svg")
                                      : dataKostbyPopular![index].kostType ==
                                              "Cewek"
                                          ? SvgPicture.asset(
                                              "assets/icon/cewek.svg",
                                              width: 14.w)
                                          : dataKostbyPopular![index]
                                                      .kostType ==
                                                  "Campur"
                                              ? SvgPicture.asset(
                                                  "assets/icon/campur.svg")
                                              : Container(),
                                  SizedBox(width: 5.w),
                                  Text(dataKostbyPopular![index].kostType,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12)),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Text(dataKostbyPopular![index].kostName,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Text(dataKostbyPopular![index].location,
                                  style: GoogleFonts.inter(fontSize: 12)),
                              SizedBox(height: 12.h),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Icon(Icons.star,
                                          color: Colors.yellow.shade600),
                                      SizedBox(width: 8.w),
                                      Text(dataKostbyPopular![index].rating,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12)),
                                    ],
                                  ),
                                  Text(
                                      "Rp . " +
                                          dataKostbyPopular![index].roomPrice +
                                          " / Bulan",
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12)),
                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
