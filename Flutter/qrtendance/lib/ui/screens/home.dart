import 'package:flutter/material.dart';
import 'package:QRtendance/ui/screens/tabs/home_tab.dart';
import 'package:QRtendance/ui/screens/tabs/summary_tab.dart';
import 'package:QRtendance/ui/screens/tabs/profile_tab.dart';
import 'package:QRtendance/utils/theme.dart';

class HomePage extends StatefulWidget {
  HomePage({this.onSignedOut, this.userId});
  final String userId;
  final VoidCallback onSignedOut;

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int currentTab = 0;

  HomeTab one;
  SummaryTab two;
  ProfileTab three;
  List<Widget> pages;
  Widget currentPage;

  get onSignedOut => widget.onSignedOut;

  @override
  void initState() {
    one = HomeTab(userId: widget.userId);
    two = SummaryTab(userId: widget.userId);
    three = ProfileTab(onSignedOut: onSignedOut, userId: widget.userId);

    pages = [one, two, three];

    currentPage = one;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: currentPage,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentTab,
        onTap: (int index) {
          setState(() {
            currentTab = index;
            currentPage = pages[index];
          });
        },
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(
              'Home',
              style: smallTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assessment),
            title: Text(
              'Summary',
              style: smallTextStyle,
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            title: Text(
              'Profile',
              style: smallTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
