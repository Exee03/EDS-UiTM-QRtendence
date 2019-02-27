import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';

class ClassesCard2 extends StatelessWidget {
  ClassesCard2(this.context, this.classes);
  final Classes classes;
  final BuildContext context;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: Hero(
        tag: classes.id,
        child: Container(
          child: Text(classes.groupClass),
        ),
      ),
    );
  }
}