import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/ui/widgets/class_detail.dart';
import 'package:qrtendance/utils/FadePageRoute.dart';
import 'package:qrtendance/utils/hero_dialog_route.dart';

class ClassWidget extends StatefulWidget {
  ClassWidget({this.userId, this.semester, this.classes, this.color});
  final String userId;
  final String semester;
  final Classes classes;
  final Color color;

  @override
  ClassWidgetState createState() {
    return new ClassWidgetState();
  }
}

class ClassWidgetState extends State<ClassWidget> {
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  String _classDate;
  String _day;
  String _classTime;

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      firstDate: new DateTime(2018),
      initialDate: _date,
      lastDate: new DateTime(2025),
    );
    if (picked != null && picked != _date) {
      setState(() {
        // _classDate = formatDate(picked, [
        //   dd,
        //   '/',
        //   mm,
        //   '/',
        //   yyyy,
        // ]);
        _day = formatDate(picked, [D]);
        print(_classDate);
        print(_day);
      });
    }
    _selectTime(context);
  }

  Future<Null> _selectTime(BuildContext context) async {
    TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: _time,
    );

    if (picked != null && picked != _time) {
      String hour;
      setState(() {
        if (picked.hour.toInt() == 0) {
          hour = '12';
        } else if (picked.hour.toInt() > 12) {
          hour = (picked.hour.toInt() - 12).toString();
        } else {
          hour = picked.hour.toString();
        }
        if (picked.period.toString() == 'DayPeriod.am') {
          if (picked.minute.toInt() < 10) {
            _classTime = '$hour:0${picked.minute} AM';
          } else {
            _classTime = '$hour:${picked.minute} AM';
          }
        } else {
          if (picked.minute.toInt() < 10) {
            _classTime = '$hour:0${picked.minute} PM';
          } else {
            _classTime = '$hour:${picked.minute} PM';
          }
        }
        print('time = $_classTime');
      });
    }
    _submit();
  }

  Future _submit() async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('classes');
      await reference.add({
        'userId': widget.userId,
        'groupClass': widget.classes.groupClass,
        'day': _day,
        'classTime': _classTime,
        'semester': widget.semester,
        'codeCourse': widget.classes.codeCourse
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'groupClass${widget.classes.groupClass}',
      child: Scaffold(
        backgroundColor: widget.color,
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('classes')
              .where('userId', isEqualTo: widget.userId)
              .where('semester', isEqualTo: widget.semester)
              .where('codeCourse', isEqualTo: widget.classes.codeCourse)
              .where('groupClass', isEqualTo: widget.classes.groupClass)
              // .orderBy('day', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return new GroupClassList(
                document: snapshot.data.documents,
                userId: widget.userId,
                classes: widget.classes,
                color: widget.color);
          },
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              _selectDate(context);
            },
            elevation: 5.0,
            backgroundColor: Colors.blue,
            child: Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
    );
  }
}

class GroupClassList extends StatelessWidget {
  GroupClassList({this.document, this.userId, this.classes, this.color});
  final Classes classes;
  final String userId;
  final List<DocumentSnapshot> document;
  final Color color;
  final bool showQR = true;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int index) {
        String day = document[index].data['day'];
        String time = document[index].data['classTime'];
        return Card(
          color: color,
          child: new Container(
            height: 210.0,
            padding: showQR
                ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
                : const EdgeInsets.all(0.0),
            child: Material(
                color: Colors.blue,
                elevation: showQR ? 8.0 : 0.0,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                        FadePageRoute(widget: ClassDetail(userId: userId, classes: Classes.fromMap(
                              document[index],
                              index,
                            ),
                            color: color,)));
                  },
                  child: Container(
                    margin: const EdgeInsets.all(16.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              Row(
                                children: <Widget>[
                                  Text(day),
                                  Spacer(),
                                  Icon(
                                    Icons.flight_takeoff,
                                    color: Colors.white,
                                    size: 40.0,
                                  ),
                                  Spacer(),
                                  Text(time),
                                ],
                              ),
                              SizedBox(height: 16.0),
                              Container(
                                height: 0.5,
                                color: Colors.white,
                              ),
                              SizedBox(height: 16.0),
                              // Text(classes.groupClass),
                            ],
                          ),
                        ),
                        SizedBox(width: 10.0),
                        showQR
                            ? Hero(
                                tag: "qrcode$day$time",
                                child: Image.asset(
                                  "assets/images/qrcode.png",
                                  width: 80.0,
                                  color: Colors.white,
                                ),
                              )
                            : Container(),
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );
  }
}
