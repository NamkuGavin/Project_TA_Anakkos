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
  int _selectedIndex = 0;

  List _pages = [
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
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
            border: Border(top: BorderSide(color: Colors.black, width: 2.w))),
        child: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          selectedIconTheme:
              IconThemeData(color: ColorValues.primaryPurple, size: 30),
          selectedItemColor: ColorValues.primaryPurple,
          unselectedIconTheme: IconThemeData(color: HexColor("#D9D9D9")),
          unselectedItemColor: HexColor("#D9D9D9"),
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat),
              label: 'Chat',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: 'History',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
