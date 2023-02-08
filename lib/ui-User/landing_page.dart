import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/common/shared_code.dart';
import 'package:project_anakkos_app/common/size_config.dart';
import 'package:project_anakkos_app/ui-User/login_user.dart';
import 'package:project_anakkos_app/widget/bottomNavigation_user.dart';
import 'package:project_anakkos_app/widget/on_boarding_content.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final _controller = PageController();
  int _currentPage = 0;
  List colors = [Colors.white, Colors.white, Colors.white];

  AnimatedContainer _buildDots({int? index}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
        color: _currentPage == index
            ? ColorValues.primaryBlue
            : ColorValues.primaryBlue.withOpacity(0.5),
      ),
      margin: EdgeInsets.only(right: 5),
      height: 10,
      curve: Curves.easeIn,
      width: 10,
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    double height = SizeConfig.screenH!;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: (height * 0.9) - MediaQuery.of(context).padding.top,
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (value) => setState(() => _currentPage = value),
                itemCount: contents.length,
                itemBuilder: (context, i) {
                  return Padding(
                    padding: EdgeInsets.only(left: 40, right: 40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Anakkos",
                          style: textTheme.headline1!.copyWith(
                            color: ColorValues.primaryBlue,
                            letterSpacing: 5,
                          ),
                        ),
                        SizedBox(
                          height: 100.h,
                        ),
                        SvgPicture.asset(
                          contents[i].image,
                          height: SizeConfig.blockV! * 20,
                        ),
                        SizedBox(
                          height: 100.h,
                        ),
                        Text(
                          contents[i].title,
                          style: textTheme.headline5!
                              .copyWith(fontWeight: FontWeight.w700),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 16.h,
                        ),
                        Text(
                          contents[i].desc,
                          textAlign: TextAlign.center,
                          style: textTheme.bodyText1!.copyWith(
                            color: Color(0xff9B9B9B),
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        Container(
                          height: 72.h,
                          decoration: BoxDecoration(color: Colors.transparent),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              height: (height * 0.13) - MediaQuery.of(context).padding.top,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _currentPage + 1 == contents.length
                      ? Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _controller.jumpToPage(0);
                                },
                                style: TextButton.styleFrom(
                                    elevation: 0,
                                    textStyle: textTheme.headline6),
                                child: Text("Kembali"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  contents.length,
                                  (int index) => _buildDots(index: index),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  SharedCode.navigatorReplacement(
                                      context, NavigationWidgetBarUser());
                                },
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle: textTheme.headline6!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                child: Text("Mulai"),
                              ),
                            ],
                          ),
                        )
                      : Padding(
                          padding: EdgeInsets.only(right: 30, left: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton(
                                onPressed: () {
                                  _controller.jumpToPage(2);
                                },
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle: textTheme.headline6!
                                      .copyWith(color: Colors.red),
                                ),
                                child: Text("Lewati"),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: List.generate(
                                  contents.length,
                                  (int index) => _buildDots(index: index),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  _controller.nextPage(
                                    duration: Duration(milliseconds: 200),
                                    curve: Curves.easeIn,
                                  );
                                },
                                style: TextButton.styleFrom(
                                  elevation: 0,
                                  textStyle: textTheme.headline6!
                                      .copyWith(fontWeight: FontWeight.bold),
                                ),
                                child: Text("Lanjut"),
                              ),
                            ],
                          ),
                        ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
