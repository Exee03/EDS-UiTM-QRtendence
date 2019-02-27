import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/ui/widgets/add_course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qrtendance/ui/widgets/group_widget.dart';
import 'package:qrtendance/utils/hero_dialog_route.dart';
import 'package:random_color/random_color.dart';

class SemesterWidget extends StatelessWidget {
  SemesterWidget(this.context, this.classes, this.userId);
  final BuildContext context;
  final String userId;
  final Classes classes;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'semesterCard${classes.id}',
      child: Scaffold(
        backgroundColor: Colors.lime,
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('codeCourse')
              .where('userId', isEqualTo: userId)
              .where('semester', isEqualTo: classes.semester)
              // .orderBy('codeCourse', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData)
              return new Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            return new CodeCourseList(
                document: snapshot.data.documents, userId: userId);
          },
        ),
        floatingActionButton: Hero(
          tag: 'addCourse',
          child: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                    context,
                    HeroDialogRoute(
                        builder: (BuildContext context) =>
                            AddCourse(userId: userId, classes: classes)));
              },
              elevation: 5.0,
              backgroundColor: Colors.blue,
              child: Icon(
                Icons.add,
                color: Colors.white,
              )),
        ),
      ),
    );
  }
}

class CodeCourseList extends StatelessWidget {
  CodeCourseList({this.document, this.userId});
  final String userId;
  final List<DocumentSnapshot> document;
  @override
  Widget build(BuildContext context) {
    return new GridView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int index) {
        RandomColor _randomColor = RandomColor(index);
        Color _color =
            _randomColor.randomColor(colorBrightness: ColorBrightness.light);
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
                          child: GroupWidget(
                            userId: userId,
                            classes: Classes.fromMap(
                              document[index],
                              index,
                            ),
                            color: _color,
                          ),
                        );
                      },
                    );
                  },
                  transitionDuration: Duration(milliseconds: 600),
                ),
              ),
          child: Hero(
            tag: 'codeCourse${document[index].data['codeCourse']}',
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Card(
                color: _color,
                child: new GridTile(
                  header: new Text(
                    codeCourse,
                    style: TextStyle(color: Colors.white),
                  ),
                  child: Container(
                    alignment: Alignment.center,
                    child: new Text(
                      programme,
                      style: TextStyle(color: Colors.white),
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
    );
  }
}
