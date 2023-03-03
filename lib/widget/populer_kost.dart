import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
                itemCount: dataKostbyPopular!.length,
                itemBuilder: (BuildContext context, int index) {
                  return InkWell(
                    onTap: () {
                      // SharedCode.navigatorPush(context, DetailKost(model: widget.model));
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
                                    dataKostbyPopular![index].coverImg,
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
                                  child: Text(
                                      dataKostbyPopular![index].kostType,
                                      style: GoogleFonts.inter(fontSize: 11)),
                                ),
                                SizedBox(height: 4.h),
                                Text(dataKostbyPopular![index].kostName,
                                    style: GoogleFonts.inter(fontSize: 11)),
                                SizedBox(height: 4.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 13),
                                    Expanded(
                                      child: Text(
                                          dataKostbyPopular![index].location,
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
                                          dataKostbyPopular![index]
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
      title: Text("Populer Kost",
          style: GoogleFonts.inter(
              fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black)),
    );
  }
}
