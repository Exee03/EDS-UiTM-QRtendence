import 'dart:async';

import 'package:QRtendance/ui/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/widgets/card/time_card.dart';
import 'package:QRtendance/utils/theme.dart';
import 'package:random_color/random_color.dart';

class GroupPage extends StatefulWidget {
  GroupPage({this.userId, this.classes, this.color});
  final String userId;
  final Classes classes;
  final Color color;

  @override
  GroupPageState createState() {
    return new GroupPageState();
  }
}

class GroupPageState extends State<GroupPage> {

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
        _day = formatDate(picked, [DD]);
        print(_classDate);
        print(_day);
      });
      _selectTime(context);
    }
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
      _submit();
    }
  }

  Future _submit() async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('classes');
      await reference.add({
        'userId': widget.userId,
        'groupClass': widget.classes.groupClass,
        'day': _day,
        'classTime': _classTime,
        'semester': widget.classes.semester,
        'codeCourse': widget.classes.codeCourse
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          body: Hero(
            tag: 'groupClass${widget.classes.groupClass}',
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.1, 0.9],
                  colors: [
                    widget.color,
                    Colors.white54,
                  ],
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('classes')
                      .where('userId', isEqualTo: widget.userId)
                      .where('semester',
                          isEqualTo: widget.classes.semester)
                      .where('codeCourse', isEqualTo: widget.classes.codeCourse)
                      .where('groupClass', isEqualTo: widget.classes.groupClass)
                      // .orderBy('day', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return new Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return ListView.builder(
                        itemCount: snapshot.data.documents.length,
                        itemBuilder: (BuildContext context, int index) {
                          RandomColor _randomColor = RandomColor(index + 15);
                          Color _color = _randomColor.randomColor(
                              colorBrightness: ColorBrightness.light);
                          Color colors = _color;
                          DocumentSnapshot ds = snapshot.data.documents[index];
                          return new TimeCard(
                            classes: Classes.fromMap(ds, index),
                            userId: widget.userId,
                            color: colors,
                          );
                        });
                  },
                ),
              ),
            ),
          ),
          floatingActionButton: FloatingActionButton(
              onPressed: () {
                _selectDate(context);
              },
              elevation: 5.0,
              child: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
        Hero(
          tag: 'groupTitle${widget.classes.groupClass}',
          child: Material(
            elevation: 3,
            shadowColor: widget.color,
            color: Colors.white30,
            child: GridTile(
              child: Container(
                height: MediaQuery.of(context).size.height / 6,
                width: MediaQuery.of(context).size.width,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.classes.groupClass,
                        style: cardTitleBig,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                builder: (BuildContext context) => new HomePage()), (Route<dynamic> route) => false),
                icon: Icon(Icons.home),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
