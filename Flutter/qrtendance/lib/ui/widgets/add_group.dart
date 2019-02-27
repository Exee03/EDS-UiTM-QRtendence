import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/utils/formatters.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:date_format/date_format.dart';

class AddGroup extends StatefulWidget {
  AddGroup({this.userId, this.classes});
  final Classes classes;
  final String userId;
  @override
  AddGroupState createState() {
    return new AddGroupState();
  }
}

class AddGroupState extends State<AddGroup> {
  final db = Firestore.instance;
  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = new GlobalKey<FormState>();
  // DateTime _date = new DateTime.now();

  DateTime picked;

  String _programme;
  String _part;
  String _codeCourse;
  String _numStudents;
  // String _classDate;
  // String _day;
  String _groupClass;

  // Future _selectDate(BuildContext context) async {
  //   picked = await showDatePicker(
  //     context: context,
  //     firstDate: new DateTime(2018),
  //     initialDate: _date,
  //     lastDate: new DateTime(2025),
  //   );
  //   if (picked != null && picked != _date) {
  //     setState(() {
  //       _classDate = formatDate(picked, [
  //         dd,
  //         '/',
  //         mm,
  //         '/',
  //         yyyy,
  //       ]);
  //       _day = formatDate(picked, [D]);
  //       print(_classDate);
  //       print(_day);
  //     });
  //     return picked;
  //   }
  // }

  Future _submit() async {
    if (_formKey.currentState.validate()) {
      SystemChannels.textInput.invokeMethod('TextInput.hide');
      _formKey.currentState.save();
      Firestore.instance.runTransaction((Transaction transaction) async {
        CollectionReference reference =
            Firestore.instance.collection('groupClass');
        await reference.add({
          'userId': widget.userId,
          'codeCourse': widget.classes.codeCourse,
          'groupClass': _groupClass,
          'semester':widget.classes.semester,
          'numStudents': _numStudents,
        });
      });
      Navigator.pop(context);
    }
  }

  void performLogin() async {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lime,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 250.0,
        child: Hero(
          tag: 'addGroup',
          child: FloatingActionButton.extended(
            icon: Icon(Icons.add),
            onPressed: _submit,
            label: Text('ADD GROUP'),
            elevation: 5.0,
          ),
        ),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: new Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Text(widget.userId),
              Text(widget.classes.codeCourse),
              new TextFormField(
                controller: MaskedTextController(mask: 'AAA0000A0'),
                inputFormatters: [UpperCaseTextFormatter()],
                maxLength: 9,
                decoration: new InputDecoration(
                  labelText: "Group Class",
                  hintText: "Hint : PEE2001A1",
                  fillColor: Colors.grey,
                ),
                validator: (val) {
                  if (val.length < 9) {
                    return 'Please enter Group Class';
                  }
                },
                onSaved: (val) => _groupClass = val,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 80.0),
                child: new TextFormField(
                  controller: MaskedTextController(mask: '00'),
                  maxLength: 2,
                  decoration: new InputDecoration(
                    labelText: "Number of Students",
                    hintText: "Hint : 30",
                    fillColor: Colors.grey,
                  ),
                  validator: (val) {
                    if (val.length < 2) {
                      return 'Please enter number of Students';
                    }
                  },
                  onSaved: (val) => _numStudents = val,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
