import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/analysis_page.dart';
import 'package:QRtendance/ui/widgets/chart/group_chart.dart';
import 'package:QRtendance/utils/theme.dart';

class AnalysisCard extends StatelessWidget {
  AnalysisCard(this.context, this.classes, this.userId);
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
                      child: AnalysisPage(userId: userId, classes: classes),
                    );
                  },
                );
              },
              transitionDuration: Duration(milliseconds: 600),
            ),
          ),
      child: Hero(
        tag: 'analysisCard${classes.groupClass}${classes.codeCourse}',
        child: Card(
          color: Colors.white70,
          child: ListTile(
            title: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text(
                  classes.groupClass,
                  style: cardTitle,
                ),
                Text(
                  classes.codeCourse,
                  style: cardSubtitle,
                ),
                Stack(
                  children: <Widget>[
                    Container(
                      height: 200,
                      child: GroupChartWidget(classes, userId),
                    ),
                    GestureDetector(
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
                                      child: AnalysisPage(
                                          userId: userId, classes: classes),
                                    );
                                  },
                                );
                              },
                              transitionDuration: Duration(milliseconds: 600),
                            ),
                          ),
                      child: Card(
                        elevation: 0,
                        color: Colors.transparent,
                        child: SizedBox(
                          height: 200,
                          width: MediaQuery.of(context).size.width,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
