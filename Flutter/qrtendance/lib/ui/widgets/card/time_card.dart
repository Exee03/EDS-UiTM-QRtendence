import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/attendance_page.dart';
import 'package:QRtendance/utils/theme.dart';

class TimeCard extends StatefulWidget {
  TimeCard({this.classes, this.userId, this.color});
  final String userId;
  final Classes classes;
  final Color color;

  @override
  _TimeCardState createState() => _TimeCardState();
}

class _TimeCardState extends State<TimeCard> {
  int currentStudent;
  int totalStudent;

  Future loadData() async {
    Firestore.instance
        .collection('attendance')
        .where('userId', isEqualTo: widget.userId)
        .where('semester', isEqualTo: widget.classes.semester)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .where('day', isEqualTo: widget.classes.day)
        .where('classTime', isEqualTo: widget.classes.classTime)
        .getDocuments()
        .then((data) {
      setState(() {
        currentStudent = data.documents.length;
      });
    });
    Firestore.instance
        .collection('groupClass')
        .where('userId', isEqualTo: widget.userId)
        .where('semester', isEqualTo: widget.classes.semester)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .snapshots()
        .listen((onData) => onData.documents.forEach((doc) {
              setState(() {
                totalStudent = doc['numStudents'];
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    return new Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 30),
      child: GestureDetector(
        onTap: () => Navigator.of(context).push(
              PageRouteBuilder<Null>(
                pageBuilder: (
                  BuildContext context,
                  Animation<double> animation,
                  Animation<double> secondaryAnimation,
                ) {
                  return AnimatedBuilder(
                    animation: animation,
                    builder: (
                      BuildContext context,
                      Widget child,
                    ) {
                      return Opacity(
                        opacity: animation.value,
                        child: AttendancePage(
                          userId: widget.userId,
                          classes: widget.classes,
                          color:widget.color
                        ),
                      );
                    },
                  );
                },
                transitionDuration: Duration(milliseconds: 600),
              ),
            ),
        child: Hero(
          tag: 'classWidget${widget.classes.day}${widget.classes.classTime}',
          child: Card(
            elevation: 0,
            color: Colors.white30,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                color: Colors.transparent,
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 50.0,
                            width: 50.0,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(Icons.schedule),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    widget.classes.day,
                                    style: cardTitle,
                                  ),
                                  Text(
                                    widget.classes.classTime,
                                    style: cardTitle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Container(
                        height: 0.5,
                        color: Colors.black,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Current : ', style: cardSubtitle),
                                  Text(currentStudent.toString(),
                                      style: cardSubtitle)
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Text('Total : ', style: cardSubtitle),
                                  Text(totalStudent.toString(),
                                      style: cardSubtitle)
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
