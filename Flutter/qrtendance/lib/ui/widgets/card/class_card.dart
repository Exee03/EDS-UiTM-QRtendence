import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/attendance_page.dart';
import 'package:QRtendance/utils/theme.dart';

class ClassCardNew extends StatelessWidget {
  ClassCardNew({this.document, this.userId, this.color});
  final List<DocumentSnapshot> document;
  final String userId;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: document.length,
      itemBuilder: (context, index) {
        DocumentSnapshot ds = document[index];
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
                          child: AttendancePage(
                              userId: userId,
                              classes: Classes.fromMap(ds, index),
                              color: color),
                        );
                      },
                    );
                  },
                  transitionDuration: Duration(milliseconds: 600),
                ),
              ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Hero(
              tag: 'classWidget${ds['day']}${ds['classTime']}',
              child: Card(
                elevation: 0,
                color: Colors.white30,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Container(
                    color: Colors.transparent,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            height: 30.0,
                            width: 30.0,
                            child: FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(Icons.schedule),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            width: 0.5,
                            height: 30,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Material(
                            color: Colors.transparent,
                            child: Container(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    ds['day'],
                                    style: cardSubtitle,
                                  ),
                                  Text(
                                    ds['classTime'],
                                    style: cardSubtitle,
                                  )
                                ],
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
