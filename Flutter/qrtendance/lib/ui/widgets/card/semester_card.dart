import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/semester_page.dart';
import 'package:QRtendance/utils/theme.dart';

class SemesterCard extends StatelessWidget {
  SemesterCard(this.context, this.classes, this.userId);
  final BuildContext context;
  final Classes classes;
  final String userId;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
                      child: SemesterPage(context, classes, userId),
                    );
                  },
                );
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          ),
      child: Hero(
        tag: 'semesterTitle${classes.semester}',
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Card(
            elevation: 5.0,
            color: Colors.white70,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Align(
                alignment: Alignment.center,
                child: Text(
                  classes.semester,
                  style: cardTitleBig,
                  textAlign: TextAlign.center,
                )),
          ),
        ),
      ),
    );
  }
}
