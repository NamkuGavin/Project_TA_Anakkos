import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
    return Scaffold(
      appBar: appBarWidget(),
      body: _isLoad
          ? LoadingAnimation()
          : Padding(
              padding: EdgeInsets.all(8.0),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  childAspectRatio: 0.57,
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: dataKostbyLoc!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // SharedCode.navigatorPush(context, DetailKost(model: widget.model));
                      SharedCode.navigatorPush(
                          context,
                          DetailKost(
                            idKost: dataKostbyLoc![index].id.toString(),
                            model: dataKostbyLoc![index],
                          ));
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 5,
                      shadowColor: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 125.h,
                            width: 150.w,
                            child: ClipRRect(
                                borderRadius: BorderRadius.vertical(
                                    bottom: Radius.circular(10)),
                                child: Image.network(
                                    dataKostbyLoc![index].coverImg,
                                    fit: BoxFit.cover)),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12.h),
                                DottedBorder(
                                  color: Colors.black,
                                  strokeWidth: 1,
                                  child: Text(dataKostbyLoc![index].kostType,
                                      style: GoogleFonts.inter(fontSize: 11)),
                                ),
                                SizedBox(height: 4.h),
                                Text(dataKostbyLoc![index].kostName,
                                    style: GoogleFonts.inter(fontSize: 11)),
                                SizedBox(height: 4.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 13),
                                    Expanded(
                                      child: Text(
                                          dataKostbyLoc![index].location,
                                          style:
                                              GoogleFonts.inter(fontSize: 11)),
                                    )
                                  ],
                                ),
                                SizedBox(height: 6.h),
                                Align(
                                  alignment: Alignment.bottomRight,
                                  child: Text(
                                      "Rp. " +
                                          dataKostbyLoc![index]
                                              .roomPrice
                                              .toString() +
                                          " / Bulan",
                                      style: GoogleFonts.inter(fontSize: 11)),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
    );
  }

  appBarWidget() {
    return AppBar(
      backgroundColor: Colors.white,
      leading: IconButton(
          onPressed: () {
            SharedCode.navigatorPop(context);
          },
          icon: Icon(Icons.arrow_back_rounded, color: Colors.black)),
      title: Text("Near By Kost",
          style: GoogleFonts.inter(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black)),
    );
  }
}
