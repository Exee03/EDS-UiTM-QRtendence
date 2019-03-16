import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:date_format/date_format.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/attendance_page.dart';
import 'package:QRtendance/ui/screens/pages/ml_detail.dart';
import 'package:QRtendance/utils/dialog_page_route.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/utils/theme.dart';

class StudentsCard extends StatefulWidget {
  StudentsCard({this.context, this.classes, this.userId, this.color});
  final BuildContext context;
  final String userId;
  final Classes classes;
  final Color color;
  @override
  _StudentsCardState createState() => _StudentsCardState();
}

class _StudentsCardState extends State<StudentsCard> {
  static const String CAMERA_SOURCE = 'CAMERA_SOURCE';
  static const String GALLERY_SOURCE = 'GALLERY_SOURCE';

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  var resultTxt = new TextEditingController();
  String studentName;

  @override
  void initState() {
    super.initState();
    print(widget.classes.scanData);
    print(studentName);
    buildText(context, widget.classes.scanData);
  }

  @override
  Widget build(BuildContext context) {
    if (studentName == null) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Column(
      children: <Widget>[
        Container(
          margin: EdgeInsets.all(10.0),
          child: Card(
            elevation: 0,
            child: Slidable(
              delegate: new SlidableDrawerDelegate(),
              actionExtentRatio: 0.25,
              child: new Container(
                color: widget.color,
                child: Container(
                  color: Colors.white30,
                  child: new ListTile(
                    isThreeLine: true,
                    leading: Text(
                        formatDate(widget.classes.scanTime, [hh, ':', nn, am]),
                        style: cardSmallSubtitle),
                    title: new Text(
                      widget.classes.scanData,
                      style: cardSmallTitle,
                    ),
                    subtitle: Column(
                      children: <Widget>[
                        Text(
                          studentName,
                          style: cardSmallSubtitle,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              actions: <Widget>[
                new IconSlideAction(
                  caption: 'Scan Name',
                  color: Colors.green,
                  icon: Icons.camera,
                  onTap: () => onPickImageSelected(CAMERA_SOURCE),
                ),
              ],
              secondaryActions: <Widget>[
                new IconSlideAction(
                  caption: 'Edit Name',
                  color: Colors.black45,
                  icon: Icons.edit,
                  onTap: () async {
                    final result = await Navigator.push(
                        context,
                        HeroDialogRoute(
                            builder: (BuildContext context) =>
                                EditDialog(resultTxt, widget.classes)));
                    setState(() {
                      studentName = result.toString();
                    });
                  },
                ),
                new IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () async {
                    final WriteBatch _batch = Firestore.instance.batch();
                    CollectionReference col =
                        Firestore.instance.collection('attendance');
                    QuerySnapshot _query = await col
                        .where('scanData', isEqualTo: widget.classes.scanData)
                        .where('day', isEqualTo: widget.classes.day)
                        .where('classTime', isEqualTo: widget.classes.classTime)
                        .getDocuments();
                    _query.documents.forEach((doc) {
                      _batch.delete(col.document(doc.documentID));
                    });
                    await _batch.commit();
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _showDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("No Data", style: cardTitle, textAlign: TextAlign.center,),
          content: Container(
            child: Column(
              children: <Widget>[
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal :10.0),
                  child: Text('Please scan the Student Card', style: cardSmallTitle,),
                ),
                SizedBox(height: 20,),
                FittedBox(
                  fit: BoxFit.cover,
                  child: Image.asset('assets/images/student_card_sample.png'),
                )
              ],
            ),
          ),
          actions: <Widget>[
            new FlatButton(
              child: new Text("OK"),
              onPressed: () {
                Navigator.pop(context);
                onPickImageSelected(CAMERA_SOURCE);
              },
            ),
          ],
        );
      },
    );
  }

  Future buildText(BuildContext context, String studentId) async {
    Firestore.instance
        .collection('students')
        .document(studentId)
        .get()
        .then((result) {
      if (!result.exists) {
        _showDialog();
      } else {
        studentName = result.data['name'];
      }
    });
    print(studentName);
  }

  void onPickImageSelected(String source) async {
    var imageSource;
    if (source == CAMERA_SOURCE) {
      imageSource = ImageSource.camera;
    } else {
      imageSource = ImageSource.gallery;
    }

    final scaffold = _scaffoldKey.currentState;

    try {
      final file = await ImagePicker.pickImage(source: imageSource);
      if (file == null) {
        throw Exception('File is not available');
      }

      final result = await Navigator.push(
        widget.context,
        new MaterialPageRoute(builder: (context) => MLDetail(file)),
      );
      print('asdasdasd$result');
      if (result != null) {
        setState(() {
          resultTxt.text = result;
          studentName = result;
        });
        Navigator.push(
            context,
            HeroDialogRoute(
                builder: (BuildContext context) =>
                    EditDialog(resultTxt, widget.classes))).then((edited) {
          if (edited != null) {
            print(edited);
            setState(() {
              resultTxt.text = edited;
              studentName = edited;
            });
          }
        });
      }
    } catch (e) {
      scaffold.showSnackBar(SnackBar(
        content: Text(e.toString()),
      ));
    }
  }
}
