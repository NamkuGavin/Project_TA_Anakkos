import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/model/kost_by_loc_model.dart';
import 'package:project_anakkos_app/ui-User/detail_kost.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';

class NearByKost extends StatefulWidget {
  final String location;
  NearByKost({Key? key, required this.location}) : super(key: key);

  @override
  State<NearByKost> createState() => _NearByKostState();
}

class _NearByKostState extends State<NearByKost> {
  bool _isLoad = false;
  List<KostbyLocationData>? dataKostbyLoc;
  List<KostDummyModel> nearby = [
    KostDummyModel("assets/dummykos/kost_1.png", "Laki-laki", "Kost Skywalker",
        "Besito, Gebog", "Rp. 750.000 / bulan", 4.3, 200),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Hokage",
        "Besito, Gebog", "Rp. 550.000 / bulan", 5.0, 100),
    KostDummyModel("assets/dummykos/kost_3.png", "Laki-laki", "Kost Apasaja",
        "Besito, Gebog", "Rp. 850.000 / bulan", 3.0, 150),
    KostDummyModel("assets/dummykos/kost_4.png", "Campuran", "Kost Subadi",
        "Besito, Gebog", "Rp. 750.000 / bulan", 1.0, 125),
    KostDummyModel("assets/dummykos/kost_3.png", "Campuran", "Kost Pelangi",
        "Besito, Gebog", "Rp. 800.000 / bulan", 4.5, 300),
    KostDummyModel("assets/dummykos/kost_2.png", "Perempuan", "Kost Star",
        "Besito, Gebog", "Rp. 900.000 / bulan", 4.3, 500),
    KostDummyModel("assets/dummykos/kost_1.png", "Perempuan", "Kost Taman",
        "Besito, Gebog", "Rp. 1.000.000 / bulan", 4.7, 768),
    KostDummyModel("assets/dummykos/kost_4.png", "Laki-laki", "Kost Regency",
        "Besito, Gebog", "Rp. 600.000 / bulan", 4.8, 163),
  ];

  Future getKostbyLoc() async {
    setState(() {
      _isLoad = true;
    });
    KostbyLocationModel _model =
        await ApiService().getKostbyLoc(location: widget.location);
    setState(() {
      dataKostbyLoc = _model.data;
      _isLoad = false;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getKostbyLoc();
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
        //           itemCount: dataKostbyLoc!.length,
        //           itemBuilder: (BuildContext context, int index) {
        //             return InkWell(
        //               onTap: () {
        //                 // SharedCode.navigatorPush(context, DetailKost(model: widget.model));
        //                 SharedCode.navigatorPush(
        //                     context,
        //                     DetailKost(
        //                       idKost: dataKostbyLoc![index].id.toString(),
        //                       model: dataKostbyLoc![index],
        //                     ));
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
        //                               dataKostbyLoc![index].coverImg,
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
        //                             child: Text(dataKostbyLoc![index].kostType,
        //                                 style: GoogleFonts.inter(fontSize: 11)),
        //                           ),
        //                           SizedBox(height: 4.h),
        //                           Text(dataKostbyLoc![index].kostName,
        //                               style: GoogleFonts.inter(fontSize: 11)),
        //                           SizedBox(height: 4.h),
        //                           Row(
        //                             crossAxisAlignment: CrossAxisAlignment.start,
        //                             children: [
        //                               Icon(Icons.location_on_rounded, size: 13),
        //                               Expanded(
        //                                 child: Text(
        //                                     dataKostbyLoc![index].location,
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
        //                                     dataKostbyLoc![index]
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
          Text("More of “Near by”", style: TextStyle(fontSize: 16)),
          SizedBox(height: 10.h),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: dataKostbyLoc!.length,
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
                            child: Image.network(dataKostbyLoc![index].coverImg,
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
                                  dataKostbyLoc![index].kostType == "Cowok"
                                      ? SvgPicture.asset(
                                          "assets/icon/cowok.svg")
                                      : dataKostbyLoc![index].kostType ==
                                              "Cewek"
                                          ? SvgPicture.asset(
                                              "assets/icon/cewek.svg",
                                              width: 14.w)
                                          : dataKostbyLoc![index].kostType ==
                                                  "Campur"
                                              ? SvgPicture.asset(
                                                  "assets/icon/campur.svg")
                                              : Container(),
                                  SizedBox(width: 5.w),
                                  Text(dataKostbyLoc![index].kostType,
                                      style: GoogleFonts.roboto(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12)),
                                ],
                              ),
                              SizedBox(height: 20.h),
                              Text(dataKostbyLoc![index].kostName,
                                  style: GoogleFonts.inter(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 15)),
                              Text(dataKostbyLoc![index].location,
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
                                      Text(dataKostbyLoc![index].rating,
                                          style: GoogleFonts.roboto(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 12)),
                                    ],
                                  ),
                                  Text(
                                      "Rp . " +
                                          dataKostbyLoc![index].roomPrice +
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
