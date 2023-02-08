import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/ui-Seller/chat_seller.dart';
import 'package:project_anakkos_app/ui-Seller/home_seller.dart';
import 'package:project_anakkos_app/ui-Seller/profile_seller.dart';
import 'package:project_anakkos_app/ui-User/chat_page.dart';
import 'package:project_anakkos_app/ui-User/history_page.dart';
import 'package:project_anakkos_app/ui-User/home_page.dart';
import 'package:project_anakkos_app/ui-User/profile_page.dart';

class NavigationWidgetBarSeller extends StatefulWidget {
  const NavigationWidgetBarSeller({Key? key}) : super(key: key);

  @override
  State<NavigationWidgetBarSeller> createState() =>
      _NavigationWidgetBarSellerState();
}

class _NavigationWidgetBarSellerState extends State<NavigationWidgetBarSeller> {
  int _selectedIndex = 0;

  List _pages = [HomeSeller(), ChatSeller(), ProfileSeller()];

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
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.chat_bubble_text_fill, size: 25),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.profile_circled, size: 25),
            label: 'Profile',
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
