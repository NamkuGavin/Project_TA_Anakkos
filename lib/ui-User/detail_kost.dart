import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:dotted_line/dotted_line.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_bloc/flutter_form_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/populer_model.dart';
import 'package:project_anakkos_app/dummy/dummy%20model/ulasan_model.dart';
import 'package:project_anakkos_app/dummy/dummy_bookmark.dart';
import 'package:project_anakkos_app/ui-User/booking_page.dart';
import 'package:project_anakkos_app/ui-User/role_page.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_dates.dart';
import 'package:project_anakkos_app/widget/alert%20dialog/alert_dialog_image.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailKost extends StatefulWidget {
  final KostDummyModel model;
  DetailKost({Key? key, required this.model}) : super(key: key);

  @override
  State<DetailKost> createState() => _DetailKostState();
}

class _DetailKostState extends State<DetailKost> {
  Color _iconColor = Colors.grey;
  String pemilikkost = "Julia";
  String jumlahUlasan = "143";
  final user = FirebaseAuth.instance.currentUser;
  Uri _url = Uri.parse('https://maps.app.goo.gl/BEx6Yyowr6YSuKnp7');

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

  @override
  void initState() {
    if (BookmarkList.bookmarkItems.contains(widget.model) == true) {
      setState(() {
        _iconColor = ColorValues.primaryPurple;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: NestedScrollView(
          headerSliverBuilder: (context, scrolling) {
            return <Widget>[
              SliverOverlapAbsorber(
                handle:
                    NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                sliver: SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  expandedHeight: 250.h,
                  forceElevated: scrolling,
                  flexibleSpace: FlexibleSpaceBar(background: detailAppbar()),
                ),
              ),
            ];
          },
          body: ListView(
            children: [
              detailHeader(),
              detailFasilitas(),
              detailPeraturan(),
              fotoKostWidget(),
              mapKost(),
              pemilikKost(),
              commentUser(),
              SizedBox(height: 25.h),
              sewaButton(),
            ],
          ),
        ),
      ),
    );
  }

  detailAppbar() {
    return Stack(
      children: [
        Image.asset(widget.model.picture_kost,
            fit: BoxFit.cover, width: double.infinity, height: double.infinity),
        Positioned(
            top: 25,
            left: 20,
            child: CircleAvatar(
              backgroundColor: ColorValues.primaryBlue,
              child: IconButton(
                onPressed: () {
                  SharedCode.navigatorPop(context);
                },
                icon: Icon(
                  Icons.arrow_back_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            )),
      ],
    );
  }

  detailFasilitas() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
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
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  side: BorderSide(width: 1, color: ColorValues.primaryPurple),
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  minimumSize: Size(0.w, 30.h),
                ),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    context: context,
                    builder: (context) => buildSheet(),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Lihat Fasilitas',
                        style: GoogleFonts.inter(fontSize: 12)),
                    Icon(Icons.double_arrow_rounded, size: 20)
                  ],
                ))
          ],
        ),
      ),
    );
  }

  buildSheet() {
    return makeDismissible(
      child: DraggableScrollableSheet(
          initialChildSize: 0.75,
          minChildSize: 0.3,
          maxChildSize: 0.75,
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
              padding: EdgeInsets.all(20),
              child: ListView(
                controller: controller,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Text("Fasilitas Kamar",
                        style: GoogleFonts.roboto(
                            fontWeight: FontWeight.bold, fontSize: 20)),
                  ),
                  Text(
                      widget.model.name_kost +
                          ", " +
                          widget.model.location_kost,
                      style: GoogleFonts.roboto()),
                  Padding(
                    padding: EdgeInsets.only(top: 25),
                    child: Text("Spesifikasi Kamar",
                        style: GoogleFonts.roboto(fontSize: 17)),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Cube.svg")),
                        Expanded(flex: 7, child: Text("5x4 meter")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 4),
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
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: DottedLine(dashColor: Colors.black),
                  ),
                  Text("Tempat Tidur", style: GoogleFonts.roboto(fontSize: 17)),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Pillow.svg")),
                        Expanded(flex: 7, child: Text("Bantal")),
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
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: DottedLine(dashColor: Colors.black),
                  ),
                  Text("Pendingin / Sirkulasi Udara",
                      style: GoogleFonts.roboto(fontSize: 17)),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Fan.svg")),
                        Expanded(flex: 7, child: Text("Kipas Angin")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      children: [
                        Expanded(
                            child: SvgPicture.asset("assets/icon/Window.svg")),
                        Expanded(flex: 7, child: Text("Jendela")),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: DottedLine(dashColor: Colors.black),
                  ),
                  Text("Furniture", style: GoogleFonts.roboto(fontSize: 17)),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Row(
                      children: [
                        Expanded(
                            child:
                                SvgPicture.asset("assets/icon/Cupboard.svg")),
                        Expanded(flex: 7, child: Text("Lemari")),
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
                            child: SvgPicture.asset("assets/icon/Chair.svg")),
                        Expanded(flex: 7, child: Text("Kursi")),
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
                        Text(widget.model.rating_kost.toString(),
                            style: GoogleFonts.roboto(fontSize: 12)),
                        SizedBox(width: 3),
                        Icon(Icons.circle, size: 6, color: Colors.grey[400]),
                        SizedBox(width: 3),
                        Text(
                          "(" + jumlahUlasan + " Ulasan)",
                          style: GoogleFonts.roboto(
                              fontSize: 12, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  Text(widget.model.location_kost,
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
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12),
                        width: 275.w,
                        height: 75.h,
                        child: TextField(
                          decoration: InputDecoration(
                              hintText: 'Tulis Komenmu...',
                              hintStyle: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black38,
                                  fontWeight: FontWeight.w500),
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Color(0xffD6D6D6), width: 2),
                                  borderRadius: BorderRadius.circular(25)),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: ColorValues.primaryBlue),
                                  borderRadius: BorderRadius.circular(25))),
                        ),
                      ),
                      RawMaterialButton(
                        constraints: BoxConstraints(minWidth: 0),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        onPressed: () {},
                        elevation: 2.0,
                        fillColor: ColorValues.primaryBlue,
                        child: Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                        padding: EdgeInsets.all(12),
                        shape: CircleBorder(),
                      )
                    ],
                  )
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

  detailPeraturan() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4, horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text("Peraturan Kamar"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: SvgPicture.asset("assets/icon/Bed_maks.svg")),
                  Expanded(
                      flex: 7,
                      child: Text("Tipe ini bisa diisi maks. 1 orang/kamar")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                      child: SvgPicture.asset("assets/icon/Couple_heart.svg")),
                  Expanded(flex: 7, child: Text("Tidak untuk pasutri")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: SvgPicture.asset("assets/icon/Child.svg")),
                  Expanded(flex: 7, child: Text("Tidak boleh bawa anak")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Text("Peraturan Kost"),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                      child: SvgPicture.asset("assets/icon/Time_maks.svg")),
                  Expanded(flex: 7, child: Text("Akses 05.00 - 22.00")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                      child: SvgPicture.asset("assets/icon/Ban_smoking.svg")),
                  Expanded(flex: 7, child: Text("Dilarang Merokok")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(
                      child: SvgPicture.asset("assets/icon/No_animal.svg")),
                  Expanded(flex: 7, child: Text("Dilarang bawa hewan")),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child: Row(
                children: [
                  Expanded(child: SvgPicture.asset("assets/icon/Bill.svg")),
                  Expanded(flex: 7, child: Text("Denda kerusakan barang kos")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  detailHeader() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(widget.model.name_kost,
                    style: GoogleFonts.roboto(
                        fontSize: 20, fontWeight: FontWeight.w500)),
                IconButton(
                    onPressed: () async {
                      SharedPreferences pref =
                          await SharedPreferences.getInstance();
                      if (pref.getString("token") == null && user == null) {
                        SharedCode.navigatorPush(context, RolePage());
                      } else if (user != null) {
                        BookmarkList.bookmarkItems.add(widget.model);
                        print("BOOKMARK LENGTH: " +
                            BookmarkList.bookmarkItems.length.toString());
                        setState(() {
                          _iconColor = ColorValues.primaryPurple;
                        });
                      } else {
                        print("APPS LOGIN");
                      }
                    },
                    icon: Icon(Icons.bookmark, color: _iconColor))
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
                    Icon(Icons.location_on_rounded, size: 15),
                    SizedBox(width: 2.w),
                    Text(widget.model.location_kost,
                        style: GoogleFonts.inter(fontSize: 12))
                  ],
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: Row(
                children: [
                  Icon(Icons.star, color: ColorValues.primaryPurple, size: 20),
                  SizedBox(width: 5.w),
                  Text(widget.model.rating_kost.toString() +
                      " (" +
                      widget.model.jumlahrating_kost.toString() +
                      ")")
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  pemilikKost() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Pemilik Kost",
              style: GoogleFonts.roboto(fontSize: 20),
            ),
            Row(
              children: [
                Image.asset("assets/icon/Pemilik_kost.png", width: 75.w),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(pemilikkost,
                        style: GoogleFonts.roboto(
                            fontSize: 17, fontWeight: FontWeight.bold)),
                    Text("Bergabung 19 Juli 2022",
                        style: GoogleFonts.roboto(fontSize: 12)),
                  ],
                ),
              ],
            ),
            SizedBox(height: 5.h),
            Text("Info Tambahan",
                style: GoogleFonts.roboto(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            SizedBox(height: 5.h),
            Text(
                "Lagi cari kos campur di daerah Setiabudi? Kost MamiRooms Dian Setiabudi Tipe A Jakarta Selatan 582DS adalah pilihan pas untukmu yang sedang cari kos di kawasan dekat kampus, warung makan, mall, dan halte MRT. Kamu bisa dengan mudah menjangkau tempat-tempat strategis seperti Direktorat Jenderal Imigrasi (1.1 km), DBS Bank Tower (1.2 km), Lippo Kuningan (1.6 km), Gedung Ditjen Administrasi Hukum Umum (1.9 km), Sahid Sudirman Center (1.9 km). Kami menyediakan kos khusus karyawan dengan akses kunci 24 jam, yang dilengkapi balkon, layanan kebersihan harian, dan banyak dilalui angkutan umum.",
                style: GoogleFonts.roboto(fontSize: 13)),
            SizedBox(height: 10.h),
            Align(
              alignment: Alignment.bottomRight,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side:
                        BorderSide(width: 1, color: ColorValues.primaryPurple),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    minimumSize: Size(0.w, 30.h),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Tanya Pemilik Kost',
                          style: GoogleFonts.inter(fontSize: 12)),
                      SizedBox(width: 5.w),
                      Icon(CupertinoIcons.chat_bubble_text_fill, size: 17)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  commentUser() {
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
              "(" + jumlahUlasan + " Ulasan)",
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

  sewaButton() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.8),
            spreadRadius: 2,
            blurRadius: 5, // changes position of shadow
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 13),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(widget.model.price_kost,
                style: GoogleFonts.inter(
                    fontSize: 14, fontWeight: FontWeight.bold)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorValues.primaryBlue,
                    foregroundColor: Colors.white,
                    minimumSize: Size(0.w, 40.h),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    SharedPreferences pref =
                        await SharedPreferences.getInstance();
                    if (pref.getString("token") == null && user == null) {
                      SharedCode.navigatorPush(context, RolePage());
                    } else if (user != null) {
                      _showDialog(context);
                    } else {
                      print("APPS LOGIN");
                    }
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Sewa Kamar',
                          style: GoogleFonts.inter(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                      SizedBox(width: 5.w),
                      Icon(CupertinoIcons.shopping_cart)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  Future _showDialog(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogDates(model: widget.model);
      },
    );
  }

  mapKost() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child:
                  Text("Lokasi Kost", style: GoogleFonts.roboto(fontSize: 20)),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Icon(Icons.location_pin),
                  Text("Kudus, Bashir", style: GoogleFonts.roboto()),
                ],
              ),
            ),
            Center(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      side: BorderSide(
                          width: 1, color: ColorValues.primaryPurple),
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      minimumSize: Size(double.infinity, 40.h)),
                  onPressed: () {
                    _launchUrl();
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Click sini untuk liat lokasi kost',
                          style: GoogleFonts.inter(fontSize: 13)),
                      SizedBox(width: 10.w),
                      Icon(CupertinoIcons.location_solid, size: 17)
                    ],
                  )),
            )
          ],
        ),
      ),
    );
  }

  fotoKostWidget() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shadowColor: Colors.black,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(vertical: 6),
              child:
                  Text("Preview Kost", style: GoogleFonts.roboto(fontSize: 20)),
            ),
            GestureDetector(
              onTap: () {
                _showImage(context);
              },
              child: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Image.asset("assets/dummykos/foto_kos.png"),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future _showImage(context) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialogImage();
      },
    );
  }

  Future<void> _launchUrl() async {
    if (!await launchUrl(_url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $_url');
    }
  }
}
