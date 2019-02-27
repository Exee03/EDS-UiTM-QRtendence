import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';


class ClassesCard extends StatelessWidget {
  ClassesCard(this.context, this.classes);
  final BuildContext context;
  final Classes classes;
  
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(this.context).size;
    return Container(
      height: screenSize.height / 5,
      padding: EdgeInsets.symmetric(vertical: 10.0),
      child: Card(
        color: Colors.amber,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 20.0,
            ),
            Expanded(
              child: Text(
                classes.groupClass,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 30.0),
              ),
            ),
            Container(
              height: 0.5,
              color: Colors.black,
            ),
            SizedBox(
              height: 10.0,
            ),
            Row(
              children: <Widget>[
                SizedBox(
                  width: 20.0,
                ),
                Expanded(
                    child: Text(
                  classes.classDate,
                  textAlign: TextAlign.center,
                )),
                SizedBox(
                  width: 50.0,
                ),
                Text(classes.numStudents),
                SizedBox(
                  width: 50.0,
                ),
              ],
            ),
            SizedBox(
              height: 10.0,
            )
          ],
        ),
      ),
    );
  }
}