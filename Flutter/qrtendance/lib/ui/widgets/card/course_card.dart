import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/course_page.dart';
import 'package:QRtendance/utils/theme.dart';

class CourseCard extends StatelessWidget {
  CourseCard({this.document, this.userId});
  final String userId;
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: new GridView.builder(
        itemCount: document.length,
        itemBuilder: (BuildContext context, int index) {
          String codeCourse = document[index].data['codeCourse'];
          String programme = document[index].data['programme'];
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
                            child: CoursePage(
                              userId: userId,
                              classes: Classes.fromMap(
                                document[index],
                                index,
                              ),
                            ),
                          );
                        },
                      );
                    },
                    transitionDuration: Duration(milliseconds: 600),
                  ),
                ),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: Colors.white30,
                elevation: 0,
                child: Hero(
                  tag: 'codeCourse$codeCourse',
                  child: Material(
                    color: Colors.transparent,
                    child: new GridTile(
                      child: Container(
                        color: Colors.transparent,
                        alignment: Alignment.center,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              new Text(
                                codeCourse,
                                style: cardTitle,
                              ),
                              new Text(
                                programme,
                                style: cardSubtitle,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        gridDelegate:
            new SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
      ),
    );
  }
}
