import 'dart:async';
import 'package:QRtendance/utils/formatters.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:QRtendance/ui/widgets/card/student_card.dart';
import 'package:QRtendance/utils/theme.dart';

class AttendancePage extends StatefulWidget {
  AttendancePage({this.userId, this.classes, this.color});
  final Classes classes;
  final String userId;
  final Color color;
  @override
  AttendancePageState createState() {
    return new AttendancePageState();
  }
}

class AttendancePageState extends State<AttendancePage> {
  final GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  DateTime _date = new DateTime.now();
  String result = "data";
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

  Future _scanQR() async {
    try {
      String qrResult = await BarcodeScanner.scan();
      setState(() {
        result = qrResult;
      });
      _submit();
    } on PlatformException catch (ex) {
      if (ex.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          result = "Camera permission was denied";
        });
      } else {
        setState(() {
          result = "Unknow Error $ex";
        });
      }
    } on FormatException {
      setState(() {
        result = "You pressed the back button before scanning anything";
      });
    }
  }

  Future _submit() async {
    Query reference = Firestore.instance
        .collection('attendance')
        .where('day', isEqualTo: widget.classes.day)
        .where('classTime', isEqualTo: widget.classes.classTime)
        .where('scanData', isEqualTo: result);
    reference.getDocuments().then((data) {
      if (data.documents.isEmpty == true) {
        Firestore.instance.runTransaction((Transaction transaction) async {
          CollectionReference reference =
              Firestore.instance.collection('attendance');
          await reference.add({
            'userId': widget.userId,
            'groupClass': widget.classes.groupClass,
            'day': widget.classes.day,
            'classTime': widget.classes.classTime,
            'semester': widget.classes.semester,
            'codeCourse': widget.classes.codeCourse,
            'classDate': formatDate(_date, [dd, '/', mm, '/', yyyy]),
            'scanData': result,
            'scanTime': _date,
          });
        });
      } else {
        scaffoldKey.currentState.showSnackBar(SnackBar(
          content: new Text(
            'Error: $result is already scanned!',
            textAlign: TextAlign.center,
            style: smallTextStyleInv,
          ),
          duration: new Duration(seconds: 10),
        ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
    if (currentStudent == null && totalStudent == null) {
      return Material(
        child: Center(
          child: Container(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
    return Hero(
      tag: 'classWidget${widget.classes.day}${widget.classes.classTime}',
      child: Scaffold(
        key: scaffoldKey,
        floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () => _scanQR(),
          child: Container(
              padding: EdgeInsets.all(8),
              color: Colors.transparent,
              child: Image.asset(
                'assets/images/scan_card.png',
                color: Colors.white,
              )),
        ),
        body: Stack(
          children: <Widget>[
            CustomScrollView(
              slivers: <Widget>[
                SliverAppBar(
                  backgroundColor: widget.color,
                  expandedHeight: 150.0,
                  forceElevated: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Material(
                      color: Colors.white54,
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Column(
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
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
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          widget.classes.day,
                                          style: cardTitleBig,
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          widget.classes.classTime,
                                          style: cardTitleBig,
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 20.0),
                                child: Container(
                                  height: 0.5,
                                  color: Colors.black,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 50.0),
                                child: Container(
                                  child: Column(
                                    children: <Widget>[
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('Current : ',
                                              style: cardSubtitle),
                                          Text(currentStudent.toString(),
                                              style: cardSubtitle)
                                        ],
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: <Widget>[
                                          Text('Total : ', style: cardSubtitle),
                                          Text(totalStudent.toString(),
                                              style: cardSubtitle)
                                        ],
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
                StreamBuilder(
                  stream: Firestore.instance
                      .collection("attendance")
                      .where('userId', isEqualTo: widget.userId)
                      .where('semester', isEqualTo: widget.classes.semester)
                      .where('codeCourse', isEqualTo: widget.classes.codeCourse)
                      .where('groupClass', isEqualTo: widget.classes.groupClass)
                      .where('day', isEqualTo: widget.classes.day)
                      .where('classTime', isEqualTo: widget.classes.classTime)
                      .snapshots(),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (!snapshot.hasData) {
                      return SliverFillRemaining(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return SliverPadding(
                      padding: const EdgeInsets.only(
                          top: 20.0, bottom: 60.0, right: 20.0, left: 20.0),
                      sliver: SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            DocumentSnapshot ds =
                                snapshot.data.documents[index];
                            return Hero(
                              tag: 'classesCard$index',
                              child: Container(
                                child: StudentsCard(
                                  context: context,
                                  classes: Classes.fromMap(ds, index),
                                  userId: widget.userId,
                                  color: widget.color,
                                ),
                              ),
                            );
                          },
                          childCount: snapshot.data.documents.length,
                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class EditDialog extends StatelessWidget {
  EditDialog(this.textController, this.classes);
  var textController;
  final Classes classes;
  Future _add() async {
    Firestore.instance.runTransaction((Transaction transaction) async {
      DocumentReference reference =
          Firestore.instance.collection('students').document(classes.scanData);
      await reference.setData({
        'name': textController.text,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    print(classes.id);
    return Center(
      child: SimpleDialog(
        title: Text(
          'Edit',
          style: cardTitleBig,
          textAlign: TextAlign.center,
        ),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text('Please enter the name only and make sure the name is correct.', style: smallTextStyle,),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              child: new TextField(
                maxLines: 8,
                controller: textController,
                inputFormatters: [UpperCaseTextFormatter()],
                decoration: InputDecoration(
                  labelText: "Student Name",
                  hintText: "Hint : ALI BIN ABU",
                  fillColor: Colors.blue,
                  border: OutlineInputBorder(),
                ),
              ),
            ),
          ),
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SizedBox(
              width: 250.0,
              child: FloatingActionButton.extended(
                icon: Icon(Icons.add),
                onPressed: () {
                  _add();
                  Navigator.pop(context, textController.text);
                },
                label: Text(
                  'ADD NAME',
                  style: bigTextStyle,
                ),
                elevation: 5.0,
              ),
            ),
          )
        ],
      ),
    );
  }
}
