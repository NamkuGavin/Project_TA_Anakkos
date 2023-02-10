import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AlertDialogImage extends StatefulWidget {
  const AlertDialogImage({Key? key}) : super(key: key);

  @override
  State<AlertDialogImage> createState() => _AlertDialogImageState();
}

class _AlertDialogImageState extends State<AlertDialogImage> {
  int activeIndex = 0;
  final assetImage = [
    "assets/dummykos/room1.png",
    "assets/dummykos/room3.png",
    "assets/dummykos/room2.png",
    "assets/dummykos/room2.png",
    "assets/dummykos/room1.png",
    "assets/dummykos/room2.png",
    "assets/dummykos/room3.png",
  ];
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      content: Builder(builder: (context) {
        return SizedBox(
          width: 275.w,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CarouselSlider.builder(
                options: CarouselOptions(
                    viewportFraction: 1,
                    height: 400.h,
                    enableInfiniteScroll: false,
                    enlargeCenterPage: true,
                    onPageChanged: (index, reason) {
                      setState(() {
                        activeIndex = index;
                      });
                    }),
                itemCount: assetImage.length,
                itemBuilder: (context, index, realIndex) {
                  final asset_image = assetImage[index];

                  return buildImage(asset_image, index);
                },
              ),
              SizedBox(height: 25.h),
              buildIndicator(),
            ],
          ),
        );
      }),
    );
  }

  buildImage(String asset_image, int index) {
    return Container(
      width: double.infinity,
      color: Colors.grey,
      child: Image.asset(asset_image, fit: BoxFit.fitHeight),
    );
  }

  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: assetImage.length,
      effect: ScrollingDotsEffect(
        fixedCenter: true,
        dotWidth: 14.w,
        dotHeight: 14.h,
      ),
    );
  }
}
