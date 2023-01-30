import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/ui-User/chat_page.dart';
import 'package:project_anakkos_app/ui-User/history_page.dart';
import 'package:project_anakkos_app/ui-User/home_page.dart';
import 'package:project_anakkos_app/ui-User/profile_page.dart';

class NavigationWidgetBarUser extends StatefulWidget {
  const NavigationWidgetBarUser({Key? key}) : super(key: key);

  @override
  State<NavigationWidgetBarUser> createState() =>
      _NavigationWidgetBarUserState();
}

class _NavigationWidgetBarUserState extends State<NavigationWidgetBarUser> {
  int _selectedIndex = 0;

  List _pages = [HomePage(), ChatPage(), HistoryPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [
            BoxShadow(color: Colors.black38, spreadRadius: 3, blurRadius: 10),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(30.0),
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: true,
            showUnselectedLabels: false,
            selectedIconTheme: IconThemeData(color: ColorValues.primaryPurple),
            selectedItemColor: ColorValues.primaryPurple,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            items: [
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.home, size: 30),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.chat_bubble_text_fill, size: 30),
                label: 'Chat',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.history, size: 30),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(CupertinoIcons.profile_circled, size: 30),
                label: 'Profile',
              ),
            ],
          ),
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
