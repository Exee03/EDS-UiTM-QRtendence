import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/utils/formatters.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:QRtendance/utils/theme.dart';

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

  DateTime picked;
  int _numStudents = 1;
  String _groupClass;

  String numberValidator(String value) {
    if (value == null) {
      return null;
    }
    final n = num.tryParse(value);
    if (n == null) {
      return '"$value" is not a valid number';
    }
    return null;
  }

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
          'semester': widget.classes.semester,
          'numStudents': _numStudents,
        });
      });
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    //   return Scaffold(
    //     backgroundColor: Colors.white,
    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //     floatingActionButton: SizedBox(
    //       width: 250.0,
    //       child: Hero(
    //         tag: 'addGroup',
    //         child: FloatingActionButton.extended(
    //           icon: Icon(Icons.add, color: Colors.white,),
    //           onPressed: _submit,
    //           label: Text('ADD GROUP',style: mediumTextStyleInv,),
    //           elevation: 5.0,
    //         ),
    //       ),
    //     ),
    //     body: new Padding(
    //       padding: const EdgeInsets.all(20.0),
    //       child: new Form(
    //         key: _formKey,
    //         child: ListView(
    //           children: <Widget>[
    //             Padding(
    //               padding:
    //                   const EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
    //               child: new TextFormField(
    //                 controller: MaskedTextController(mask: 'AAA0000A0'),
    //                 inputFormatters: [UpperCaseTextFormatter()],
    //                 maxLength: 9,
    //                 decoration: new InputDecoration(
    //                     labelText: "Group Class",
    //                     hintText: "Hint : PEE2001A1",
    //                     fillColor: Colors.blue,
    //                     border: OutlineInputBorder()),
    //                 validator: (val) {
    //                   if (val.length < 9) {
    //                     return 'Please enter Group Class';
    //                   }
    //                 },
    //                 onSaved: (val) => _groupClass = val,
    //               ),
    //             ),
    //             Padding(
    //               padding:
    //                   const EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
    //               child: new TextFormField(
    //                 keyboardType: TextInputType.number,
    //                 controller: MaskedTextController(mask: '00'),
    //                 maxLength: 2,
    //                 decoration: new InputDecoration(
    //                     labelText: "Number of Student",
    //                     hintText: "Hint : 30",
    //                     fillColor: Colors.blue,
    //                     border: OutlineInputBorder()),
    //                 validator: (val) {
    //                   if (val.length < 2) {
    //                     return 'Please enter Number of Student';
    //                   }
    //                 },
    //                 onSaved: (val) => _numStudents = int.parse(val),
    //               ),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    return Scaffold(
      backgroundColor: Colors.white,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: SizedBox(
        width: 250.0,
        child: Hero(
          tag: 'addGroup',
          child: FloatingActionButton.extended(
            icon: Icon(
              Icons.add,
              color: Colors.white,
            ),
            onPressed: () => _submit(),
            label: Text(
              'ADD GROUP',
              style: mediumTextStyleInv,
            ),
            elevation: 5.0,
          ),
        ),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
                child: new TextFormField(
                  controller: MaskedTextController(mask: 'AAA0000A0'),
                  inputFormatters: [UpperCaseTextFormatter()],
                  maxLength: 9,
                  decoration: new InputDecoration(
                      labelText: "Group Class",
                      hintText: "Hint : PEE2001A1",
                      fillColor: Colors.blue,
                      border: OutlineInputBorder()),
                  validator: (val) {
                    if (val.length < 9) {
                      return 'Please enter Group Class';
                    }
                  },
                  onSaved: (val) => _groupClass = val,
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.only(top: 50.0, right: 10.0, left: 10.0),
                child: new TextFormField(
                  controller: MaskedTextController(mask: '00'),
                  inputFormatters: <TextInputFormatter>[
                    WhitelistingTextInputFormatter.digitsOnly
                  ],
                  maxLength: 2,
                  decoration: new InputDecoration(
                      labelText: "Number of Student",
                      hintText: "Hint : 10",
                      border: OutlineInputBorder()),
                  validator: numberValidator,
                  onSaved: (val) => _numStudents = int.parse(val),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
