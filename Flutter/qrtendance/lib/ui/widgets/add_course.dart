import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/utils/formatters.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';

class AddCourse extends StatefulWidget {
  AddCourse({this.userId, this.classes});
  final Classes classes;
  final String userId;
  @override
  AddCourseState createState() {
    return new AddCourseState();
  }
}

class AddCourseState extends State<AddCourse> {
  final db = Firestore.instance;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();

  String _codeCourse;
  String _programme;

  void _addData() {
    if (_formKey.currentState.validate()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _formKey.currentState.save();
      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference =
            Firestore.instance.collection('codeCourse');
        await reference.add({
          'userId': widget.userId,
          'codeCourse': _codeCourse,
          'semester': widget.classes.semester,
          'programme': _programme,
        });
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SimpleDialog(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  new TextFormField(
                    autofocus: true,
                    controller: MaskedTextController(mask: 'AAA000'),
                    inputFormatters: [UpperCaseTextFormatter()],
                    maxLength: 6,
                    decoration: new InputDecoration(
                      labelText: "Course Code",
                      hintText: "  Hint : EEE111",
                      fillColor: Colors.grey,
                    ),
                    validator: (val) {
                      if (val.length < 6) {
                        return 'Please enter Course Code';
                      }
                    },
                    onSaved: (val) => _codeCourse = val,
                  ),
                  new TextFormField(
                    controller: MaskedTextController(mask: 'AA000'),
                    inputFormatters: [UpperCaseTextFormatter()],
                    maxLength: 5,
                    decoration: new InputDecoration(
                      labelText: "Programme",
                      hintText: "Hint : EE200",
                      fillColor: Colors.grey,
                    ),
                    validator: (val) {
                      if (val.length < 5) {
                        return 'Please enter Programme Code';
                      }
                    },
                    onSaved: (val) => _programme = val,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 250.0,
              child: Hero(
                tag: 'addCourse',
                child: FloatingActionButton.extended(
                  icon: Icon(Icons.add),
                  onPressed: () => _addData(),
                  label: Text('ADD COURSE'),
                  elevation: 5.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
