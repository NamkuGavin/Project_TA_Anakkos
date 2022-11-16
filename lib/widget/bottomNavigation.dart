import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/ui/home_page.dart';

class NavigationWidgetBar extends StatefulWidget {
  const NavigationWidgetBar({Key? key}) : super(key: key);

  @override
  State<NavigationWidgetBar> createState() => _NavigationWidgetBarState();
}

class _NavigationWidgetBarState extends State<NavigationWidgetBar> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: TabBarView(
          children: [
            HomePage(),
            Center(
              child: Text("2nd Screen"),
            ),
            Center(
              child: Text("3rd Screen"),
            ),
            Center(
              child: Text("4th Screen"),
            ),
          ],
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.black, width: 2.w))),
          child: TabBar(
            labelColor: ColorValues.primaryPurple,
            unselectedLabelColor: HexColor("#D9D9D9"),
            indicatorColor: ColorValues.primaryPurple,
            indicatorWeight: 6,
            tabs: [
              Tab(
                icon: Icon(Icons.home),
              ),
              Tab(
                icon: Icon(Icons.chat),
              ),
              Tab(
                icon: Icon(Icons.history),
              ),
              Tab(
                icon: Icon(Icons.person),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
// Center(
// child: _pages.elementAt(_selectedIndex), //New
// ),
