import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:project_anakkos_app/api_url_config/api_config.dart';
import 'package:project_anakkos_app/model/image_model.dart';
import 'package:project_anakkos_app/widget/loadingWidget.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AlertDialogImage extends StatefulWidget {
  final String idKost;
  const AlertDialogImage({Key? key, required this.idKost}) : super(key: key);

  @override
  State<AlertDialogImage> createState() => _AlertDialogImageState();
}

class _AlertDialogImageState extends State<AlertDialogImage> {
  List<ImageData>? dataImage;
  bool _isLoad = false;
  int activeIndex = 0;

  Future getImage() async {
    setState(() {
      _isLoad = true;
    });
    ImageModel _resImg =
        await ApiService().getImageRoom(kost_id: widget.idKost);
    setState(() {
      dataImage = _resImg.data;
      _isLoad = false;
    });
  }

  @override
  void initState() {
    super.initState();
    getImage();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.all(0),
      content: Builder(builder: (context) {
        return _isLoad
            ? LoadingAnimation()
            : SizedBox(
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
                      itemCount: dataImage!.length,
                      itemBuilder: (context, index, realIndex) {
                        final asset_image = dataImage![index];

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

  buildImage(ImageData asset_image, int index) {
    return Container(
      width: double.infinity,
      color: Colors.grey,
      child: Image.network(asset_image.img, fit: BoxFit.fitHeight),
    );
  }

  buildIndicator() {
    return AnimatedSmoothIndicator(
      activeIndex: activeIndex,
      count: dataImage!.length,
      effect: ScrollingDotsEffect(
        fixedCenter: true,
        dotWidth: 14.w,
        dotHeight: 14.h,
      ),
    );
  }
}
