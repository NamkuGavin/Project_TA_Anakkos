import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/dummy/dummy_bookmark.dart';

class BookmarkPage extends StatefulWidget {
  const BookmarkPage({Key? key}) : super(key: key);

  @override
  State<BookmarkPage> createState() => _BookmarkPageState();
}

class _BookmarkPageState extends State<BookmarkPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
            onPressed: () {
              SharedCode.navigatorPop(context);
            },
            icon: Icon(Icons.arrow_back_rounded, color: Colors.black)),
        title: Text("Bookmark", style: GoogleFonts.roboto(color: Colors.black)),
      ),
      body: BookmarkList.bookmarkItems.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset(
                    'assets/lottie/not_found.json',
                    width: 250.w,
                    repeat: false,
                  ),
                  Text(
                    'Bookmark masih kosong',
                    style: Theme.of(context).textTheme.headline3!.copyWith(
                          fontSize: 20,
                          color: Color(0XFF9B9B9B),
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: BookmarkList.bookmarkItems.length,
              itemBuilder: (BuildContext context, int index) {
                return Card(
                  color: Colors.white,
                  elevation: 4,
                  shadowColor: Colors.black,
                  child: IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            width: 100,
                            child: Image.asset(
                                BookmarkList.bookmarkItems[index].picture_kost,
                                fit: BoxFit.fill)),
                        Expanded(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    DottedBorder(
                                      color: Colors.black,
                                      strokeWidth: 1,
                                      child: Text(
                                          BookmarkList
                                              .bookmarkItems[index].type_kost,
                                          style:
                                              GoogleFonts.inter(fontSize: 10)),
                                    ),
                                    IconButton(
                                        onPressed: () async {
                                          setState(() {
                                            BookmarkList.bookmarkItems.remove(
                                                BookmarkList
                                                    .bookmarkItems[index]);
                                            print("BOOKMARK LENGTH: " +
                                                BookmarkList
                                                    .bookmarkItems.length
                                                    .toString());
                                          });
                                        },
                                        icon: Icon(Icons.bookmark,
                                            color: ColorValues.primaryPurple))
                                  ],
                                ),
                                Text(
                                    BookmarkList.bookmarkItems[index].name_kost,
                                    style: GoogleFonts.inter(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11)),
                                SizedBox(height: 5.h),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Icon(Icons.location_on_rounded, size: 13),
                                    Text(
                                        BookmarkList
                                            .bookmarkItems[index].location_kost,
                                        style: GoogleFonts.inter(fontSize: 10))
                                  ],
                                ),
                                Align(
                                  alignment: AlignmentDirectional.bottomEnd,
                                  child: Text(
                                      BookmarkList
                                          .bookmarkItems[index].price_kost,
                                      style: GoogleFonts.inter(fontSize: 10)),
                                )
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }),
    );
  }
}
