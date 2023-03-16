import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:project_anakkos_app/common/color_values.dart';
import 'package:project_anakkos_app/ui-User/bookmark_page.dart';
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

  List _pages = [HomePage(), ChatPage(), BookmarkPage(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: GNav(
        padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        haptic: true,
        gap: 8,
        activeColor: Color(0xFF386BF6),
        selectedIndex: _selectedIndex,
        onTabChange: _onItemTapped,
        tabs: [
          GButton(
            leading: _selectedIndex == 0
                ? SvgPicture.asset(
                    "assets/icon_navbar_new/home-active.svg",
                    width: 25.w,
                  )
                : SvgPicture.asset(
                    "assets/icon_navbar_new/home.svg",
                    width: 25.w,
                  ),
            icon: CupertinoIcons.home,
            text: 'Beranda',
          ),
          GButton(
            leading: _selectedIndex == 1
                ? SvgPicture.asset("assets/icon_navbar_new/message-active.svg")
                : SvgPicture.asset("assets/icon_navbar_new/message.svg"),
            icon: CupertinoIcons.chat_bubble_text_fill,
            text: 'Chat',
          ),
          GButton(
            leading: _selectedIndex == 2
                ? SvgPicture.asset(
                    "assets/icon_navbar_new/favorite-active.svg",
                    width: 25.w,
                  )
                : SvgPicture.asset(
                    "assets/icon_navbar_new/favorite.svg",
                    width: 25.w,
                  ),
            icon: CupertinoIcons.square_favorites,
            text: 'Favorite',
          ),
          GButton(
            leading: _selectedIndex == 3
                ? SvgPicture.asset("assets/icon_navbar_new/profile-active.svg")
                : SvgPicture.asset("assets/icon_navbar_new/profile.svg"),
            icon: CupertinoIcons.profile_circled,
            text: 'Profil',
          ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      print(_selectedIndex);
    });
  }
}
