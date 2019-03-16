import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/widgets/table/attendance_table.dart';
import 'package:QRtendance/ui/widgets/chart/class_chart.dart';
import 'package:QRtendance/utils/theme.dart';
import 'package:random_color/random_color.dart';

class AnalysisPage extends StatefulWidget {
  AnalysisPage({this.userId, this.classes});
  final String userId;
  final Classes classes;

  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: StreamBuilder(
                    stream: Firestore.instance
                        .collection('classes')
                        .where('userId', isEqualTo: widget.userId)
                        .where('semester', isEqualTo: widget.classes.semester)
                        .where('codeCourse',
                            isEqualTo: widget.classes.codeCourse)
                        .where('groupClass',
                            isEqualTo: widget.classes.groupClass)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Container(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      }
                      return Material(
                        child: new ListView.builder(
                          itemCount: snapshot.data.documents.length,
                          itemBuilder: (BuildContext context, int index) {
                            RandomColor _randomColor = RandomColor(index + 15);
                            Color _color = _randomColor.randomColor(
                                colorBrightness: ColorBrightness.light);
                            Color colors = _color;
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10.0, bottom: 10.0),
                              child: Card(
                                elevation: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Hero(
                                    tag:
                                        'analysisWidget${widget.classes.semester}${widget.classes.codeCourse}${widget.classes.groupClass}',
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
                                            'analysisTitle${widget.classes.semester}${widget.classes.codeCourse}${widget.classes.groupClass}',
                                        child: Material(
                                          color: Colors.transparent,
                                          child: ExpansionTile(
                                            title: Card(
                                              elevation: 0,
                                              color: Colors.white30,
                                              child: Container(
                                                height: 130,
                                                child: Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                                                  child: Stack(
                                                    children: <Widget>[
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 50.0),
                                                        child: Container(
                                                          color: Colors
                                                              .transparent,
                                                          height: 120,
                                                          child:
                                                              ClassChartWidget(
                                                            classes: Classes.fromMap(
                                                                snapshot.data
                                                                        .documents[
                                                                    index],
                                                                index),
                                                            userId:
                                                                widget.userId,
                                                          ),
                                                        ),
                                                      ),
                                                      Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: <Widget>[
                                                          Text(
                                                            snapshot
                                                                .data
                                                                .documents[
                                                                    index]
                                                                .data['day'],
                                                            style:
                                                                cardSmallTitle,
                                                          ),
                                                          Text(
                                                            snapshot
                                                                    .data
                                                                    .documents[
                                                                        index]
                                                                    .data[
                                                                'classTime'],
                                                            style:
                                                                cardSmallSubtitle,
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  height: 10,
                                                                  width: 10,
                                                                  color: Colors
                                                                      .green,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: Text(
                                                                    'Present',
                                                                    style:
                                                                        smallTextStyle,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(8.0),
                                                            child: Row(
                                                              children: <
                                                                  Widget>[
                                                                Container(
                                                                  height: 10,
                                                                  width: 10,
                                                                  color: Colors
                                                                      .red,
                                                                ),
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      left:
                                                                          8.0),
                                                                  child: Text(
                                                                    'Absent',
                                                                    style:
                                                                        smallTextStyle,
                                                                  ),
                                                                )
                                                              ],
                                                            ),
                                                          ),
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                        .only(
                                                                    top: 8.0),
                                                            child: Text(
                                                              'Total Student : ${widget.classes.numStudents.toString()}',
                                                              style:
                                                                  smallTextStyle,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                            children: <Widget>[
                                              TableAttendance(
                                                  classes: Classes.fromMap(
                                                      snapshot.data
                                                          .documents[index],
                                                      index),
                                                  userId: widget.userId)
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ),
              Hero(
                tag: 'semesterWidget',
                child: Container(
                  height: screenSize.height / 5,
                  width: screenSize.width,
                  decoration: ShapeDecoration(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                      bottomRight: Radius.elliptical(300.0, 100.0),
                      bottomLeft: Radius.elliptical(300.0, 100.0),
                    )),
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Hero(
          tag:
              'analysisCard${widget.classes.groupClass}${widget.classes.codeCourse}',
          child: Material(
            elevation: 0,
            // shadowColor: color,
            color: Colors.transparent,
            child: GridTile(
              child: Container(
                height: screenSize.height / 6,
                width: screenSize.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      widget.classes.groupClass,
                      style: cardTitleBig,
                    ),
                    Text(
                      widget.classes.codeCourse,
                      style: cardTitle,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 28),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back),
            ),
          ),
        ),
      ],
    );
  }
}
