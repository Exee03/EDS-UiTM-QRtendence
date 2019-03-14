import 'dart:async';
import 'package:date_format/date_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/utils/theme.dart';

class AttendanceModel {
  final DateTime time;
  final String studentId;
  final String studentName;
  const AttendanceModel({this.time, this.studentId, this.studentName});
}

var attendance = <AttendanceModel>[
  AttendanceModel(time: DateTime.now(), studentId: '0', studentName: 'aaa')
];

class TableAttendance extends StatefulWidget {
  TableAttendance({this.classes, this.userId});
  final Classes classes;
  final String userId;

  @override
  _TableAttendanceState createState() => _TableAttendanceState();
}

class _TableAttendanceState extends State<TableAttendance> {
  Future loadData() async {
    Firestore.instance
        .collection('attendance')
        .where('userId', isEqualTo: widget.userId)
        .where('semester', isEqualTo: widget.classes.semester)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .where('day', isEqualTo: widget.classes.day)
        .where('classTime', isEqualTo: widget.classes.classTime)
        .snapshots()
        .listen((onData) => onData.documents.forEach((doc) {
              Firestore.instance
                  .collection('students')
                  .document(doc['scanData'])
                  .get()
                  .then((data) {
                setState(() {
                  attendance.add(AttendanceModel(
                      time: doc['scanTime'],
                      studentId: doc['scanData'],
                      studentName: data['name']));
                });
              });
            }));
  }

  Widget bodyData() => DataTable(
        columns: <DataColumn>[
          DataColumn(
              label: Row(children: <Widget>[
            Container(
                width: 60,
                child: Text(
                  'Time',
                  textAlign: TextAlign.center,
                  style: smallTextStyle,
                )),
            Container(
                width: 90,
                child: Text(
                  'StudentID',
                  textAlign: TextAlign.center,
                  style: smallTextStyle,
                )),
            Container(
                width: 120,
                child: Text(
                  'Name',
                  textAlign: TextAlign.center,
                  style: smallTextStyle,
                ))
          ])),
        ],
        rows: attendance
            .map((data) => DataRow(
                  cells: [
                    DataCell(Row(
                      children: <Widget>[
                        Container(
                            width: 60,
                            child: Text(
                              formatDate(data.time, [h, ':', nn, ' ', am]),
                              textAlign: TextAlign.center,
                              style: extraSmallTextStyle,
                            )),
                        Container(
                            width: 90,
                            child: Text(
                              data.studentId,
                              textAlign: TextAlign.center,
                              style: extraSmallTextStyle,
                            )),
                        Container(
                            width: 150,
                            child: Text(
                              data.studentName,
                              textAlign: TextAlign.center,
                              style: extraSmallTextStyle,
                              overflow: TextOverflow.clip,
                            ))
                      ],
                    )),
                  ],
                ))
            .toList(),
      );

  @override
  void initState() {
    super.initState();
    attendance.clear();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    if (attendance.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          'No data in this Class',
          style: smallTextStyle,
        )),
      );
    }
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: bodyData(),
    );
  }
}
