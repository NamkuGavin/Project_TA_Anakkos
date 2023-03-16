import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/db_helper.dart';
import 'package:project_anakkos_app/dummy/dummy_bookmark.dart';
import 'package:project_anakkos_app/model/db_model/kost_model.dart';
import 'package:project_anakkos_app/model/history_model.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  late List<KostFav> kostFav;
  bool _isLoad = false;

  @override
  void initState() {
    super.initState();
    refreshKost();
  }

  // @override
  // void dispose() {
  //   KostDatabase.instance.close();
  //   super.dispose();
  // }

  Future refreshKost() async {
    setState(() {
      _isLoad = true;
    });
    this.kostFav = await KostDatabase.instance.readAll();
    setState(() {
      _isLoad = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFFECECEC),
        title: Text("Favorite",
            style: GoogleFonts.roboto(color: Colors.black, fontSize: 15)),
      ),
      body: _isLoad
          ? LoadingAnimation()
          : kostFav.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset(
                        'assets/lottie/not_found.json',
                        width: 225.w,
                        repeat: false,
                      ),
                      Text(
                        'Favorite masih kosong',
                        style: Theme.of(context).textTheme.headline3!.copyWith(
                              fontSize: 17,
                              color: Color(0XFF9B9B9B),
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ],
                  ),
                )
              : Padding(
                  padding: EdgeInsets.all(15),
                  child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.65,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10.0,
                        mainAxisSpacing: 10.0,
                      ),
                      itemCount: kostFav.length,
                      itemBuilder: (BuildContext context, int index) {
                        final kost = kostFav[index];
                        return Stack(
                          children: [
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                                child: Image.network(
                                  kost.coverImg,
                                  fit: BoxFit.fill,
                                  height: 225.h,
                                  width: 400.w,
                                )),
                            Positioned(
                              top: 175,
                              left: 13,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(kost.name,
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15)),
                                  SizedBox(height: 10.h),
                                  Text("Rp. " + kost.price + " / Bulan",
                                      style: GoogleFonts.roboto(
                                          color: Colors.white, fontSize: 12)),
                                ],
                              ),
                            ),
                            Positioned(
                              left: 115,
                              child: IconButton(
                                  onPressed: () async {
                                    await KostDatabase.instance
                                        .delete(kost.id!);
                                    refreshKost();
                                  },
                                  icon:
                                      Icon(Icons.favorite, color: Colors.red)),
                            ),
                            Positioned(
                              left: 10,
                              top: 10,
                              child: Row(
                                children: [
                                  kost.type == "Cowok"
                                      ? SvgPicture.asset(
                                          "assets/icon/cowok1.svg")
                                      : kost.type == "Cewek"
                                          ? SvgPicture.asset(
                                              "assets/icon/cewek1.svg",
                                              width: 14.w)
                                          : kost.type == "Campur"
                                              ? SvgPicture.asset(
                                                  "assets/icon/campur1.svg")
                                              : Container(),
                                  SizedBox(width: 8.w),
                                  Text(kost.type,
                                      style: GoogleFonts.roboto(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w500,
                                          fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        );
                        //   Card(
                        //   color: Colors.white,
                        //   elevation: 4,
                        //   shadowColor: Colors.black,
                        //   child: IntrinsicHeight(
                        //     child: Row(
                        //       crossAxisAlignment: CrossAxisAlignment.stretch,
                        //       mainAxisAlignment: MainAxisAlignment.start,
                        //       children: [
                        //         Container(
                        //             width: 100,
                        //             child: Image.network(kost.coverImg,
                        //                 fit: BoxFit.fill)),
                        //         Expanded(
                        //           child: Padding(
                        //             padding: EdgeInsets.all(8.0),
                        //             child: Column(
                        //               mainAxisAlignment: MainAxisAlignment.start,
                        //               crossAxisAlignment: CrossAxisAlignment.start,
                        //               children: [
                        //                 Row(
                        //                   mainAxisAlignment:
                        //                       MainAxisAlignment.spaceBetween,
                        //                   children: [
                        //                     DottedBorder(
                        //                       color: Colors.black,
                        //                       strokeWidth: 1,
                        //                       child: Text(kost.type,
                        //                           style: GoogleFonts.inter(
                        //                               fontSize: 10)),
                        //                     ),
                        //                     IconButton(
                        //                         onPressed: () async {
                        //                           await KostDatabase.instance
                        //                               .delete(kost.id!);
                        //                           refreshKost();
                        //                         },
                        //                         icon: Icon(Icons.bookmark,
                        //                             color:
                        //                                 ColorValues.primaryPurple))
                        //                   ],
                        //                 ),
                        //                 Text(kost.name,
                        //                     style: GoogleFonts.inter(
                        //                         fontWeight: FontWeight.bold,
                        //                         fontSize: 11)),
                        //                 SizedBox(height: 5.h),
                        //                 Row(
                        //                   crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                   children: [
                        //                     Icon(Icons.location_on_rounded,
                        //                         size: 13),
                        //                     Expanded(
                        //                       child: Text(kost.location,
                        //                           style: GoogleFonts.inter(
                        //                               fontSize: 10)),
                        //                     )
                        //                   ],
                        //                 ),
                        //                 Align(
                        //                   alignment: AlignmentDirectional.bottomEnd,
                        //                   child: Padding(
                        //                     padding: EdgeInsets.symmetric(
                        //                         vertical: 8, horizontal: 12),
                        //                     child: Text(kost.price,
                        //                         style: GoogleFonts.inter(
                        //                             fontSize: 10)),
                        //                   ),
                        //                 )
                        //               ],
                        //             ),
                        //           ),
                        //         )
                        //       ],
                        //     ),
                        //   ),
                        // );
                      }),
                ),
    );
  }
}
