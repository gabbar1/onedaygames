import 'package:convex_bottom_navigation/convex_bottom_navigation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:oneday/Winner/Winners.dart';
import 'package:oneday/profile/Profile.dart';

import 'dashboard.dart';

class HomeNavigator extends StatefulWidget {
  @override
  _HomeNavigatorState createState() => _HomeNavigatorState();
}
int _CurrentIdex=0;

Widget callPage(int currentIdex){
  switch(currentIdex){
    case 0 : return DashboardPage();
    case 1:return  Winner();
    case 2:return  Profile();
    break;
    default: return DashboardPage();
  }
}


class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: callPage(_CurrentIdex),
        bottomNavigationBar:ConvexBottomNavigation(
          activeIconColor: Colors.amber,
          inactiveIconColor: Colors.grey,
          textColor: Colors.grey,
          circleSize: CircleSize.BIG,
          bigIconPadding: 10.0,
          tabs: [
            TabData(
                icon: SvgPicture.asset("assets/icons/home.svg"),
                title: "home"),
            TabData(
                icon: SvgPicture.asset("assets/icons/winners.svg"),
                title: "winner"),
            TabData(
                icon: SvgPicture.asset("assets/icons/profile.svg"),
                title: "profile"),
          ],
          onTabChangedListener: (position) {
            setState(() {
              _CurrentIdex = position;
            });
          },
        )

   );
  }
}
