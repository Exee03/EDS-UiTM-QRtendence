import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class ClassChartWidget extends StatefulWidget {
  ClassChartWidget({this.classes, this.userId});
  final Classes classes;
  final String userId;
  @override
  _ClassChartWidgetState createState() => _ClassChartWidgetState();
}

class Student {
  final String status;
  final int count;
  final charts.Color color;

  Student(this.status, this.count, Color color):this.color=charts.Color(r: color.red, g: color.green, b: color.blue,a: color.alpha);
}

class _ClassChartWidgetState extends State<ClassChartWidget> {
  int value;
  int remainingStudent;
  int totalStudent;

  var dataArray = [
    Student('present', 0, Colors.grey),
  ];

  @override
  void initState() {
    super.initState();
    dataArray.clear();
    loadData();
  }

  Future loadData() async {
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
                value = data.documents.length;
                remainingStudent = totalStudent - value;
                setState(() {
                  dataArray.add(Student('Present', value, Colors.green));
                  dataArray.add(Student('Absent', remainingStudent, Colors.red));
                });
              });
            }));
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
        domainFn: (Student days, _) => days.status,
        measureFn: (Student days, _) => days.count,
        colorFn: (Student days,_) => days.color,
        id: 'Days',
        data: dataArray,
        labelAccessorFn: (Student days,_) => '${days.count}',
      )
    ];

    var chart = charts.PieChart(
      series,
      defaultRenderer: charts.ArcRendererConfig(
        arcRendererDecorators: [charts.ArcLabelDecorator()],
        // arcWidth: 20,
      ),
      animate: true,
    );

    if (dataArray.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: CircularProgressIndicator()),
      );
    }
    return chart;
  }
}
