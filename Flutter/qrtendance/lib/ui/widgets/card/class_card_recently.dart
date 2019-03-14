import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/group_page.dart';
import 'package:QRtendance/utils/theme.dart';
import 'package:random_color/random_color.dart';

class ClassCardRecently extends StatelessWidget {
  ClassCardRecently(this.context, this.classes, this.userId);
  final BuildContext context;
  final Classes classes;
  final String userId;

  @override
  Widget build(BuildContext context) {
    RandomColor _randomColor = RandomColor(classes.id.toInt() + 10);
    Color _color =
        _randomColor.randomColor(colorBrightness: ColorBrightness.random);
    Color colors = _color;
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
                      child: GroupPage(
                        userId: userId,
                        classes: classes,
                        color: colors,
                      ),
                    );
                  },
                );
              },
              transitionDuration: Duration(milliseconds: 600),
            ),
          ),
      child: Hero(
        tag: 'groupClass${classes.groupClass}',
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical:8.0),
          child: Card(
            elevation: 10,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15.0),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.1, 0.9],
                    colors: [
                      Colors.white70,
                      colors,
                    ],
                  ),
                ),
                child: new ListTile(
                  title: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: new Text(
                              classes.groupClass,
                              style: cardTitle,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 0.5,
                        color: Colors.white,
                      )
                    ],
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 10.0, left: 20),
                    child: Column(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              classes.codeCourse,
                              style: cardSubtitle,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                classes.semester,
                                style: cardSubtitle,
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              new Text(
                                'Total of Students : ',
                                style: cardSubtitle,
                              ),
                              new Text(
                                classes.numStudents.toString(),
                                style: cardSubtitle,
                              ),
                            ],
                          ),
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
  }
}
