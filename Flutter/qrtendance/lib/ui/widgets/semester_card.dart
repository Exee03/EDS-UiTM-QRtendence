import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/ui/widgets/semester_widget.dart';

class SemesterCard extends StatelessWidget {
  SemesterCard(this.context, this.classes, this.userId);
  final BuildContext context;
  final Classes classes;
  final String userId;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
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
                      child: SemesterWidget(
                        context,
                        classes,
                        userId,
                      ),
                    );
                  },
                );
              },
              transitionDuration: Duration(milliseconds: 600),
            ),
          ),
      child: Hero(
        tag: 'semesterCard${classes.id}',
        child: Container(
          margin: EdgeInsets.all(10.0),
          width: screenSize.width / 2.5,
          child: Card(
            elevation: 5.0,
            color: Colors.lime,
            child: Text(classes.semester),
          ),
        ),
      ),
    );
  }
}
