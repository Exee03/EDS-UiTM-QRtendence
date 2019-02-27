import 'dart:async';

import 'package:flutter/material.dart';
// import 'package:hero_ticket_animation/common/ticket_card.dart';
// import 'package:hero_ticket_animation/model/ticket.dart';
// import 'package:hero_ticket_animation/theme.dart';
import 'package:after_layout/after_layout.dart';
import 'package:qrtendance/model/classes_model.dart';

class ClassDetail extends StatefulWidget {
  ClassDetail({this.userId, this.classes, this.color});
  final Classes classes;
  final String userId;
  final Color color;
  @override
  ClassDetailState createState() {
    return new ClassDetailState();
  }
}

class ClassDetailState extends State<ClassDetail>
    with AfterLayoutMixin<ClassDetail> {
  bool showCorner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue, //primaryColor,
      body: Column(
        children: <Widget>[
          SizedBox(height: 50.0),
          Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: InkWell(
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 50.0,
                ),
                onTap: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ),
          SizedBox(height: 40.0),
          Spacer(),
          Hero(
            tag: "qrcode${widget.classes.day}${widget.classes.classTime}",
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                getCorners(),
                Image.asset(
                  "assets/images/qrcode.png",
                  width: 140.0,
                  color: Colors.white,
                ),
              ],
            ),
          ),
          SizedBox(height: 80.0),
        ],
      ),
    );
  }

  Widget getCorners() {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      width: showCorner ? 140 : 80,
      height: showCorner ? 140 : 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisSize: showCorner ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RotatedBox(
                  quarterTurns: 0,
                  child: Image.asset(
                    "assets/images/corners.png",
                    width: 25.0,
                  )),
              RotatedBox(
                  quarterTurns: 1,
                  child: Image.asset(
                    "assets/images/corners.png",
                    width: 25.0,
                  )),
            ],
          ),
          Spacer(),
          Row(
            mainAxisSize: showCorner ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              RotatedBox(
                  quarterTurns: 3,
                  child: Image.asset(
                    "assets/images/corners.png",
                    width: 25.0,
                  )),
              RotatedBox(
                  quarterTurns: 2,
                  child: Image.asset(
                    "assets/images/corners.png",
                    width: 25.0,
                  )),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void afterFirstLayout(BuildContext context) {
    startTimer();
  }

  startTimer() {
    var duration = Duration(milliseconds: 300);
    Timer(duration, showCorners);
  }

  showCorners() {
    setState(() {
      showCorner = true;
    });
  }
}
