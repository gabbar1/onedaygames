import 'package:flutter/material.dart';
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
    case 1:return  Profile();
    case 2:return  Winner();
    break;
    default: return DashboardPage();
  }
}


class _HomeNavigatorState extends State<HomeNavigator> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: callPage(_CurrentIdex),
    bottomNavigationBar: BottomNavigationBar(items:
        const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
        icon: Icon(Icons.home),
    label: 'Home',
    ),BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Profile',
    ),BottomNavigationBarItem(
    icon: Icon(Icons.home),
    label: 'Winners',
    ),
    ],
    currentIndex: _CurrentIdex,
    onTap: (value){
    _CurrentIdex=value;
    setState(() {

    });},
    selectedItemColor: Colors.amber[800],
    ));
  }
}
