import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/ui/widgets/card/class_card.dart';
import 'package:QRtendance/utils/theme.dart';
import 'package:random_color/random_color.dart';

class GroupCard extends StatefulWidget {
  GroupCard({this.document, this.userId});
  final String userId;
  final List<DocumentSnapshot> document;

  @override
  _GroupCardState createState() => _GroupCardState();
}

class _GroupCardState extends State<GroupCard> {
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  String _classDate;
  String _day;
  String _classTime;

  Future<Null> _selectDate(BuildContext context, int index) async {
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
      _selectTime(context, index);
    }
  }

  Future<Null> _selectTime(BuildContext context, int index) async {
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
      _submit(index);
    }
  }

  Future _submit(int index) async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('classes');
      await reference.add({
        'userId': widget.userId,
        'groupClass': widget.document[index].data['groupClass'],
        'day': _day,
        'classTime': _classTime,
        'semester': widget.document[index].data['semester'],
        'codeCourse': widget.document[index].data['codeCourse']
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: widget.document.length,
      itemBuilder: (BuildContext context, int index) {
        RandomColor _randomColor = RandomColor(index + 15);
        Color _color =
            _randomColor.randomColor(colorBrightness: ColorBrightness.light);
        Color colors = _color;
        String groupClass = widget.document[index].data['groupClass'];
        return Padding(
          padding: const EdgeInsets.only(left: 10.0, right: 10.0, bottom: 10.0),
          child: Card(
              elevation: 0,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Hero(
                  tag: 'groupClass${widget.document[index].data['groupClass']}',
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: [0.1, 0.9],
                        colors: [
                          colors,
                          Colors.white54,
                        ],
                      ),
                    ),
                    child: Hero(
                      tag:
                          'groupTitle${widget.document[index].data['groupClass']}',
                      child: Material(
                        color: Colors.transparent,
                        child: ExpansionTile(
                          leading: Container(
                              height: 50,
                              width: 50,
                              child: FittedBox(
                                  fit: BoxFit.fill, child: Icon(Icons.school))),
                          title: new Text(
                            groupClass,
                            style: cardTitle,
                          ),
                          children: <Widget>[
                            Container(
                              height: MediaQuery.of(context).size.height / 15,
                              child: FlatButton(
                                color: Colors.white24,
                                onPressed: () => _selectDate(context, index),
                                textColor: colors,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    Icon(Icons.add),
                                    Text('ADD CLASS', style: mediumTextStyle),
                                  ],
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Container(
                                height: MediaQuery.of(context).size.height / 3,
                                child: StreamBuilder(
                                  stream: Firestore.instance
                                      .collection('classes')
                                      .where('userId', isEqualTo: widget.userId)
                                      .where('semester',
                                          isEqualTo: widget
                                              .document[index].data['semester'])
                                      .where('codeCourse',
                                          isEqualTo: widget.document[index]
                                              .data['codeCourse'])
                                      .where('groupClass',
                                          isEqualTo: widget.document[index]
                                              .data['groupClass'])
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (!snapshot.hasData) {
                                      return Container(
                                        child: Center(
                                          child: Text(
                                            'No class has been set.\nPlease add new class',
                                            style: mediumTextStyle,
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      );
                                    }
                                    return ClassCardNew(
                                        document: snapshot.data.documents,
                                        userId: widget.userId,
                                        color: colors);
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )),
        );
      },
    );
  }
}
