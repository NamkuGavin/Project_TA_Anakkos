import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/ulasan_model.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class DetailSellerKost extends StatefulWidget {
  const DetailSellerKost({Key? key}) : super(key: key);

  @override
  State<DetailSellerKost> createState() => _DetailSellerKostState();
}

class _DetailSellerKostState extends State<DetailSellerKost> {
  List<UlasanDummyModel> items = [
    UlasanDummyModel(
        "assets/icon/photo_profile.png",
        "Gavin Arasyi",
        4.5,
        "10 October",
        "Menyewa selama 1 bulan",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile1.png",
        "Kholifatul Maghfirullah",
        4.0,
        "5 September",
        "Menyewa selama 1 tahun",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile1.png",
        "Sidqi Atallah",
        4.3,
        "10 Juni",
        "Menyewa selama 2 tahun",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile1.png",
        "Reza Indra",
        3.9,
        "1 Januari",
        "Menyewa selama 365 Hari",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile.png",
        "Gavin Arasyi",
        5.0,
        "31 Desember",
        "Menyewa selama 1 tahun",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile.png",
        "Kholifatul Maghfirullah",
        4.0,
        "5 September",
        "Menyewa selama 1 tahun",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile.png",
        "Iqbal",
        4.5,
        "17 Agustus",
        "Menyewa selama 2 tahun",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile1.png",
        "Iqbal",
        4.3,
        "16 Agustus",
        "Menyewa selama 12 bulan",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
    UlasanDummyModel(
        "assets/icon/photo_profile.png",
        "Muhammad Gavin",
        5.0,
        "17 Agustus",
        "Menyewa selama 1 bulan",
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut ultricies iaculis nisl."),
  ];
  List<String> pending = [
    "Bayar Katering",
    "Bayar Laundry",
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              detailHeader(),
              statSeller(),
              grafikSeller(),
              commentFromUser(),
            ],
          ),
        ),
      ),
    );
  }

  detailHeader() {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.transparent,
            image: DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(
                "assets/dummykos/kost_1.png",
              ),
            ),
          ),
          height: 225.h,
        ),
        Container(
          height: 225.h,
          decoration: BoxDecoration(
              color: Colors.white,
              gradient: LinearGradient(
                  begin: FractionalOffset.topRight,
                  end: FractionalOffset.topLeft,
                  colors: [
                    Colors.grey.withOpacity(0.0),
                    Colors.black.withOpacity(0.8),
                  ],
                  stops: [
                    0.0,
                    1.0
                  ])),
        ),
        Positioned(
          top: 30,
          left: 30,
          child: Text("Kost Subadi",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.white)),
        ),
        Positioned(
          top: 75,
          left: 30,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.location_on_rounded, color: Colors.white, size: 20.w),
              SizedBox(width: 7.w),
              Text("Kudus, Besito",
                  style: GoogleFonts.inter(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white))
            ],
          ),
        ),
        Positioned(
          top: 150,
          left: 30,
          child: Text("Active",
              style: GoogleFonts.inter(
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                  color: Color(0xFF2BE32F))),
        ),
      ],
    );
  }

  statSeller() {
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Text("Penghasilan", style: TextStyle(fontSize: 17)),
          SizedBox(height: 15.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 35, top: 15, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          SvgPicture.asset("assets/icon/currency.svg"),
                          SizedBox(width: 7.w),
                          Text("Keuntungan")
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text("Rp. 500.000",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.h),
                      Text("per October 2022"),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 20, top: 15, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star_border, size: 17),
                          SizedBox(width: 4.w),
                          Text("Rating Kos")
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text("4.7 Avg",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold)),
                      SizedBox(height: 5.h),
                      Text("per October 2022"),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 25, top: 15, bottom: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outlined, size: 17),
                          SizedBox(width: 4.w),
                          Text("Unit Tersewa")
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text("15 Unit",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15.h),
                      Row(
                        children: [
                          Icon(Icons.person_outlined, size: 17),
                          SizedBox(width: 4.w),
                          Text("Unit Tersisa")
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text("5 Unit",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(12),
                  ),
                ),
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 5),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.person_outlined, size: 17),
                          SizedBox(width: 4.w),
                          Text("Pembayaran Pending")
                        ],
                      ),
                      SizedBox(height: 10.h),
                      Text("2 Pending",
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold)),
                      SizedBox(height: 15.h),
                      SizedBox(
                        height: 50,
                        width: 150.w,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: pending.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Text("- " + pending[index]);
                          },
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  commentFromUser() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Ulasan Penyewa",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            Text(
              "(143 Ulasan)",
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.grey[600]),
            ),
            listviewTopUlasan(),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: Colors.transparent,
                  isScrollControlled: true,
                  context: context,
                  builder: (context) => buildUlasan(),
                );
              },
              child: Center(
                child: Column(
                  children: [
                    Text("Lihat semua ulasan",
                        style: GoogleFonts.roboto(fontSize: 12)),
                    Icon(
                      Icons.arrow_drop_down_rounded,
                      color: ColorValues.primaryPurple,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  listviewTopUlasan() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 2,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Image.asset(items[index].picture_ulasan, width: 50.w),
                  Expanded(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(items[index].nama_ulasan,
                            style: GoogleFonts.roboto(
                                fontSize: 12, fontWeight: FontWeight.bold)),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.star,
                                color: ColorValues.primaryPurple, size: 12),
                            SizedBox(width: 3),
                            Text(items[index].rating_ulasan.toString(),
                                style: GoogleFonts.roboto(fontSize: 11)),
                            SizedBox(width: 3),
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(Icons.circle,
                                  size: 6, color: Colors.grey[400]),
                            ),
                            SizedBox(width: 3),
                            Text(items[index].tanggal_ulasan,
                                style: GoogleFonts.roboto(fontSize: 11)),
                            SizedBox(width: 3),
                            Padding(
                              padding: EdgeInsets.only(top: 3),
                              child: Icon(Icons.circle,
                                  size: 6, color: Colors.grey[400]),
                            ),
                            SizedBox(width: 3),
                            Text(items[index].lamasewa_ulasan,
                                style: GoogleFonts.roboto(fontSize: 11)),
                          ],
                        ),
                        SizedBox(height: 2.h),
                        Text(items[index].isi_ulasan,
                            style: GoogleFonts.roboto(fontSize: 12)),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  buildUlasan() {
    return makeDismissible(
      child: DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.3,
          maxChildSize: 0.8,
          builder: (_, controller) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 5,
                    blurRadius: 10,
                  ),
                ],
              ),
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Ulasan Penyewa",
                      style: GoogleFonts.roboto(
                          fontSize: 20, fontWeight: FontWeight.bold)),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Icon(Icons.star,
                            color: ColorValues.primaryPurple, size: 12),
                        SizedBox(width: 3),
                        Text("4.5", style: GoogleFonts.roboto(fontSize: 12)),
                        SizedBox(width: 3),
                        Icon(Icons.circle, size: 6, color: Colors.grey[400]),
                        SizedBox(width: 3),
                        Text(
                          "(143 Ulasan)",
                          style: GoogleFonts.roboto(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text("Kudus, Besito",
                      style: GoogleFonts.roboto(fontWeight: FontWeight.bold)),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 15),
                      child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: items.length,
                          controller: controller,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  Image.asset(items[index].picture_ulasan,
                                      width: 50.w),
                                  Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(items[index].nama_ulasan,
                                            style: GoogleFonts.roboto(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold)),
                                        Row(
                                          mainAxisSize: MainAxisSize.min,
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(Icons.star,
                                                color:
                                                    ColorValues.primaryPurple,
                                                size: 11),
                                            SizedBox(width: 3),
                                            Text(
                                                items[index]
                                                    .rating_ulasan
                                                    .toString(),
                                                style: GoogleFonts.roboto(
                                                    fontSize: 12)),
                                            SizedBox(width: 3),
                                            Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: Icon(Icons.circle,
                                                  size: 6,
                                                  color: Colors.grey[400]),
                                            ),
                                            SizedBox(width: 3),
                                            Text(items[index].tanggal_ulasan,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 11)),
                                            SizedBox(width: 3),
                                            Padding(
                                              padding: EdgeInsets.only(top: 3),
                                              child: Icon(Icons.circle,
                                                  size: 6,
                                                  color: Colors.grey[400]),
                                            ),
                                            SizedBox(width: 3),
                                            Text(items[index].lamasewa_ulasan,
                                                style: GoogleFonts.roboto(
                                                    fontSize: 11)),
                                          ],
                                        ),
                                        Text(items[index].isi_ulasan,
                                            style: GoogleFonts.roboto(
                                                fontSize: 12)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
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

  grafikSeller() {
    final List<ChartData> chartData = [
      ChartData("Januari", 1000000),
      ChartData("Februari", 750000),
      ChartData("Maret", 500000),
      ChartData("April", 400000),
      ChartData("Mei", 500000),
      ChartData("Juni", 1000000),
      ChartData("Juli", 2000000),
      ChartData("Agustus", 750000),
      ChartData("September", 500000),
      ChartData("Oktober", 500000),
      ChartData("November", 250000),
      ChartData("Desember", 250000),
    ];
    return Padding(
      padding: EdgeInsets.all(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 5.h),
          Text("Chart Penghasilan", style: TextStyle(fontSize: 17)),
          SizedBox(height: 15.h),
          Container(
            decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff8A8A8A).withOpacity(0.1),
                    blurRadius: 5,
                    spreadRadius: 1,
                    offset: Offset(0, 3),
                  )
                ],
                borderRadius: BorderRadius.circular(10)),
            child: SfCartesianChart(
                tooltipBehavior: TooltipBehavior(enable: true),
                primaryYAxis: NumericAxis(
                    // majorGridLines: MajorGridLines(width: 0),
                    // minorGridLines: MinorGridLines(width: 0)
                    ),
                primaryXAxis: CategoryAxis(
                    interval: 1,
                    labelRotation: 90,
                    labelStyle: TextStyle(fontSize: 10)
                    // majorGridLines: MajorGridLines(width: 0),
                    // minorGridLines: MinorGridLines(width: 0),
                    ),
                series: <CartesianSeries>[
                  AreaSeries<ChartData, String>(
                      color: Colors.blue.shade100,
                      borderColor: Colors.blue,
                      borderWidth: 2,
                      dataSource: chartData,
                      xValueMapper: (ChartData exp, _) => exp.x,
                      yValueMapper: (ChartData exp, _) => exp.y),
                ]),
          ),
        ],
      ),
    );
  }
}

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final num y;
}
