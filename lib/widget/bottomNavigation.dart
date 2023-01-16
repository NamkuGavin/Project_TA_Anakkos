import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/ui/chat_page.dart';
import 'package:project_anakkos_app/ui/history_page.dart';
import 'package:project_anakkos_app/ui/home_page.dart';
import 'package:project_anakkos_app/ui/profile_page.dart';

class NavigationWidgetBar extends StatefulWidget {
  const NavigationWidgetBar({Key? key}) : super(key: key);

  @override
  State<NavigationWidgetBar> createState() => _NavigationWidgetBarState();
}

class _NavigationWidgetBarState extends State<NavigationWidgetBar> {
  int selectedIndex = 0;

  final pages = [HomePage(), ChatPage(), HistoryPage(), ProfilePage()];

  final items = <Widget>[
    Icon(Icons.home, size: 30),
    Icon(Icons.chat, size: 30),
    Icon(Icons.history, size: 30),
    Icon(Icons.person, size: 30),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: pages[selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: selectedIndex,
        items: items,
        onTap: (index) => setState(() => this.selectedIndex = index),
      ),
      // Container(
      //   decoration: BoxDecoration(
      //       border: Border(top: BorderSide(color: Colors.black, width: 2.w))),
      //   child: BottomNavigationBar(
      //     type: BottomNavigationBarType.fixed,
      //     showSelectedLabels: false,
      //     showUnselectedLabels: false,
      //     selectedIconTheme:
      //         IconThemeData(color: ColorValues.primaryPurple, size: 30),
      //     selectedItemColor: ColorValues.primaryPurple,
      //     unselectedIconTheme: IconThemeData(color: HexColor("#D9D9D9")),
      //     unselectedItemColor: HexColor("#D9D9D9"),
      //     currentIndex: _selectedIndex,
      //     onTap: _onItemTapped,
      //     items: [
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.home),
      //         label: 'Home',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.chat),
      //         label: 'Chat',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.history),
      //         label: 'History',
      //       ),
      //       BottomNavigationBarItem(
      //         icon: Icon(Icons.person),
      //         label: 'Profile',
      //       ),
      //     ],
      //   ),
      // ),
    );
  }

  // void _onItemTapped(int index) {
  //   setState(() {
  //     _selectedIndex = index;
  //   });
  // }
}
