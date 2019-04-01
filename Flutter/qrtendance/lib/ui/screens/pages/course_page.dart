import 'package:QRtendance/ui/screens/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/adding/add_group.dart';
import 'package:QRtendance/ui/widgets/card/group_card.dart';
import 'package:QRtendance/utils/theme.dart';

class CoursePage extends StatelessWidget {
  CoursePage({this.userId, this.classes});
  final String userId;
  final Classes classes;
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Stack(
      children: <Widget>[
        Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 150.0),
                child: StreamBuilder(
                  stream: Firestore.instance
                      .collection('groupClass')
                      .where('userId', isEqualTo: userId)
                      .where('semester', isEqualTo: classes.semester)
                      .where('codeCourse', isEqualTo: classes.codeCourse)
                      .orderBy('groupClass', descending: false)
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return new Container(
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return new GroupCard(
                        document: snapshot.data.documents, userId: userId);
                  },
                ),
              ),
              Hero(
                tag: 'semesterWidget',
                child: Container(
                  height: screenSize.height / 5,
                  width: screenSize.width,
                  decoration: ShapeDecoration(
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.only(
                      bottomRight: Radius.elliptical(300.0, 100.0),
                      bottomLeft: Radius.elliptical(300.0, 100.0),
                    )),
                    image: DecorationImage(
                      image: AssetImage('assets/images/background.png'),
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Hero(
            tag: 'addGroup',
            child: FloatingActionButton(
                onPressed: () => Navigator.of(context).push(
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
                                child:
                                    AddGroup(userId: userId, classes: classes),
                              );
                            },
                          );
                        },
                        transitionDuration: Duration(milliseconds: 600),
                      ),
                    ),
                elevation: 5.0,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                )),
          ),
        ),
        Hero(
          tag: 'codeCourse${classes.codeCourse}',
          child: Material(
            elevation: 0,
            // shadowColor: color,
            color: Colors.transparent,
            child: GridTile(
              child: Container(
                height: screenSize.height / 6,
                width: screenSize.width,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        classes.codeCourse,
                        style: cardTitleBig,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 28),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(
                builder: (BuildContext context) => new HomePage()), (Route<dynamic> route) => false),
                icon: Icon(Icons.home),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
