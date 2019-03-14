import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/adding/add_course.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QRtendance/ui/widgets/card/course_card.dart';
import 'package:QRtendance/utils/theme.dart';

class SemesterPage extends StatelessWidget {
  SemesterPage(this.context, this.classes, this.userId);
  final BuildContext context;
  final String userId;
  final Classes classes;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Hero(
        tag: 'addCourse',
        child: FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(
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
                          child: AddCourse(userId: userId, classes: classes),
                        );
                      },
                    );
                  },
                  transitionDuration: Duration(milliseconds: 600),
                ),
              );
            },
            elevation: 5.0,
            child: Icon(
              Icons.add,
              color: Colors.white,
            )),
      ),
      body: Stack(
        children: <Widget>[
          Hero(
            tag: 'semesterWidget',
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                decoration: ShapeDecoration(
                  shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.only(
                          bottomRight: Radius.elliptical(600.0, 50.0),
                          bottomLeft: Radius.elliptical(600, 50.0)
                          // bottomLeft: Radius.circular(50.0)
                          )),
                  image: DecorationImage(
                    image: AssetImage('assets/images/background.png'),
                    fit: BoxFit.fitHeight,
                  ),
                ),
              ),
            ),
          ),
          CustomScrollView(
            slivers: <Widget>[
              _header(),
              _body(),
            ],
          ),
        ],
      ),
    );
  }

  SliverAppBar _header() {
    return SliverAppBar(
      backgroundColor: Colors.transparent,
      expandedHeight: 130.0,
      forceElevated: true,
      flexibleSpace: FlexibleSpaceBar(
          background: Hero(
        tag: 'semesterTitle${classes.semester}',
        child: Material(
          color: Colors.white70,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 30.0),
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Text(
                classes.semester,
                style: cardTitleBig,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      )

          // Hero(
          //   tag: 'semesterTitle${classes.semester}',
          //   child: Card(
          //     color: Colors.transparent,
          //     margin: EdgeInsets.only(left: 20.0),
          //     child: Text(
          //       '${classes.semester}',
          //       textAlign: TextAlign.end,
          //       style: TextStyle(color: Colors.white),
          //     ),
          //   ),
          // ),

          // background: ClipRRect(
          //   borderRadius: BorderRadius.only(
          //       // bottomLeft: Radius.circular(25.0),
          //       // bottomRight: Radius.circular(100.0),
          //       ),
          //   child: Hero(
          //     tag: 'semesterWidget',
          //     child: Container(
          //       height: 500.0,
          //       child: Image.asset(
          //         'assets/images/background.png',
          //         fit: BoxFit.cover,
          //       ),
          //     ),
          //   ),
          // ),
          ),
    );
  }

  StreamBuilder _body() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('codeCourse')
          .where('userId', isEqualTo: userId)
          .where('semester', isEqualTo: classes.semester)
          // .orderBy('codeCourse', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return new SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        return new CourseCard(
            document: snapshot.data.documents, userId: userId);
      },
    );
  }
}
