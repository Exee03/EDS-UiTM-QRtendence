import 'package:flutter/material.dart';
import 'package:qrtendance/ui/widgets/class_list.dart';
import 'package:qrtendance/ui/screens/tabs/home_tab.dart';
import 'package:qrtendance/ui/screens/tabs/profile_tab.dart';

class HomePage extends StatefulWidget {
  HomePage({this.onSignedOut, this.userId});
  String userId;
  final VoidCallback onSignedOut;

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int currentTab = 0;

  HomeTab one;
  ClassList two;
  ProfileTab three;
  List<Widget> pages;
  Widget currentPage;

  get onSignedOut => widget.onSignedOut;

  @override
  void initState() {
    one = HomeTab(userId: widget.userId);
    two = ClassList();
    three = ProfileTab(onSignedOut,userId: widget.userId);

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
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo),
            title: Text('Photo'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('Settings'),
          )
        ],
      ),
    );
  }
}
