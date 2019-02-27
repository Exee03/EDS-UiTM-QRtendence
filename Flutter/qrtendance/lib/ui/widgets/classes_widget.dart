import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/ui/widgets/add_semester.dart';

class ClassesWidget extends StatelessWidget {
  ClassesWidget(this.context, this.classes);
  final Classes classes;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'classesCard${classes.id}',
      child: Scaffold(
        backgroundColor: Colors.amber,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        body: Container(
          child: Column(
            children: <Widget>[
              Text(classes.codeCourse),
              RaisedButton(onPressed: () {AddSemester();},)
            ],
          ),
        ),
      ),
    );
  }
}
