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
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        selectedItemColor: ColorValues.primaryPurple,
        unselectedItemColor: Color(0XFF9B9B9B),
        selectedFontSize: 12,
        unselectedFontSize: 12,
        selectedLabelStyle: textTheme.bodyText2,
        unselectedLabelStyle: textTheme.bodyText2,
        showUnselectedLabels: true,
        showSelectedLabels: true,
        elevation: 5,
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.home, size: 25),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text_fill, size: 25),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history, size: 25),
            label: 'Riwayat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled, size: 25),
            label: 'Profil',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
}
