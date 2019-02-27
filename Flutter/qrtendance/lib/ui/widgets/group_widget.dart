import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/ui/widgets/add_group.dart';
import 'package:qrtendance/ui/widgets/class_widget.dart';
import 'package:qrtendance/utils/hero_dialog_route.dart';

class GroupWidget extends StatelessWidget {
  GroupWidget({this.userId, this.classes, this.color});
  final String userId;
  final Classes classes;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'codeCourse${classes.codeCourse}',
      child: Scaffold(
        backgroundColor: color,
        body: StreamBuilder(
          stream: Firestore.instance
              .collection('groupClass')
              .where('userId', isEqualTo: userId)
              .where('semester', isEqualTo: classes.semester)
              .where('codeCourse', isEqualTo: classes.codeCourse)
              .orderBy('groupClass', descending: false)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (!snapshot.hasData) {
              return new Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return new GroupClassList(
                document: snapshot.data.documents,
                userId: userId,
                semester: classes.semester,
                color: color);
          },
        ),
        floatingActionButton: Hero(
          tag: 'addGroup',
          child: FloatingActionButton(
              onPressed: () => Navigator.push(
                  context,
                  HeroDialogRoute(
                      builder: (BuildContext context) => AddGroup(
                            userId: userId,
                            classes: classes,
                          ))),
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

class GroupClassList extends StatelessWidget {
  GroupClassList({this.document, this.userId,this.semester, this.color});
  final String userId;
  final String semester;
  final List<DocumentSnapshot> document;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return new ListView.builder(
      itemCount: document.length,
      itemBuilder: (BuildContext context, int index) {
        String groupClass = document[index].data['groupClass'];
        String numStudents = document[index].data['numStudents'];
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
                          child: ClassWidget(
                            userId: userId,
                            semester: semester,
                            classes: Classes.fromMap(
                              document[index],
                              index,
                            ),
                            color: color,
                          ),
                        );
                      },
                    );
                  },
                  transitionDuration: Duration(milliseconds: 600),
                ),
              ),
          child: Hero(
            tag: 'groupClass${document[index].data['groupClass']}',
            child: Card(
              color: color,
              child: new ListTile(
                title: new Text(groupClass),
                subtitle: new Text(
                  numStudents, //just for testing, will fill with image later
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
