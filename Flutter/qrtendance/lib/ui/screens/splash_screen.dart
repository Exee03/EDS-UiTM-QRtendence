import 'dart:async';
import 'package:flutter/material.dart';
import 'package:QRtendance/root.dart';
import 'package:QRtendance/utils/theme.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 3),
        () => Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new RootPage())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Hero(
            tag: 'semesterWidget',
            child: new Image(
              image: new AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 50.0,
                        backgroundImage: AssetImage('assets/logo/logo.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 10.0),
                      ),
                      Hero(
                        tag: 'appTitle',
                        child: Material(
                          color: Colors.transparent,
                          child: Text(
                            "QRtendance",
                            style: appTitleBig,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    CircularProgressIndicator(),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                    ),
                    Text(
                      "EDS",
                      softWrap: true,
                      textAlign: TextAlign.center,
                      style: cardTitleInv,
                    )
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
