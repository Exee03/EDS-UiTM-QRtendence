import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:QRtendance/ui/screens/pages/analysis_page.dart';
import 'package:QRtendance/utils/theme.dart';

class GroupChartWidget extends StatefulWidget {
  GroupChartWidget(this.classes, this.userId);
  final Classes classes;
  final String userId;
  @override
  _GroupChartWidgetState createState() => _GroupChartWidgetState();
}

class Days {
  final String day;
  final int count;

  Days(this.day, this.count);
}

class _GroupChartWidgetState extends State<GroupChartWidget> {
  int value;

  var dataArray = [
    Days('days', 0),
  ];

  @override
  void initState() {
    super.initState();
    dataArray.clear();
    loadData();
  }

  Future loadData() async {
    Firestore.instance
        .collection('attendance')
        .where('userId', isEqualTo: widget.userId)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .where('day', isEqualTo: 'Monday')
        .getDocuments()
        .then((data) {
      value = data.documents.length;
      if (value != 0) {
        setState(() {
          dataArray.add(Days('Mon', value));
        });
      }
    });

    Firestore.instance
        .collection('attendance')
        .where('userId', isEqualTo: widget.userId)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .where('day', isEqualTo: 'Tuesday')
        .getDocuments()
        .then((data) {
      value = data.documents.length;
      if (value != 0) {
        setState(() {
          dataArray.add(Days('Tue', value));
        });
      }
    });

    Firestore.instance
        .collection('attendance')
        .where('userId', isEqualTo: widget.userId)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .where('day', isEqualTo: 'Wednesday')
        .getDocuments()
        .then((data) {
      value = data.documents.length;
      if (value != 0) {
        setState(() {
          dataArray.add(Days('Wed', value));
        });
      }
    });

    Firestore.instance
        .collection('attendance')
        .where('userId', isEqualTo: widget.userId)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .where('day', isEqualTo: 'Thursday')
        .getDocuments()
        .then((data) {
      value = data.documents.length;
      if (value != 0) {
        setState(() {
          dataArray.add(Days('Thu', value));
        });
      }
    });

    Firestore.instance
        .collection('attendance')
        .where('userId', isEqualTo: widget.userId)
        .where('codeCourse', isEqualTo: widget.classes.codeCourse)
        .where('groupClass', isEqualTo: widget.classes.groupClass)
        .where('day', isEqualTo: 'Friday')
        .getDocuments()
        .then((data) {
      value = data.documents.length;
      if (value != 0) {
        setState(() {
          dataArray.add(Days('Fri', value));
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var series = [
      charts.Series(
          domainFn: (Days days, _) => days.day,
          measureFn: (Days days, _) => days.count,
          id: 'Days',
          data: dataArray,
          labelAccessorFn: (Days days, _) =>
              '${days.day} : ${days.count.toString()} student')
    ];

    var chart = charts.BarChart(
      series,
      vertical: false,
      barRendererDecorator: charts.BarLabelDecorator<String>(),
      domainAxis: charts.OrdinalAxisSpec(renderSpec: charts.NoneRenderSpec()),
    );

    if (dataArray.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: Text(
          'No data in this Group Class',
          style: mediumTextStyle,
        )),
      );
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
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
                          child: AnalysisPage(
                              userId: widget.userId, classes: widget.classes),
                        );
                      },
                    );
                  },
                  transitionDuration: Duration(milliseconds: 600),
                ),
              ),
          child: chart),
    );
  }
}
