import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrtendance/model/classes_model.dart';
import 'package:qrtendance/ui/widgets/add_semester.dart';
import 'package:qrtendance/ui/widgets/classes_card.dart';
import 'package:qrtendance/ui/widgets/classes_widget.dart';
import 'package:qrtendance/ui/widgets/semester_card.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:qrtendance/utils/hero_dialog_route.dart';

class HomeTab extends StatefulWidget {
  HomeTab({this.userId});
  final String userId;

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: <Widget>[
        _header(),
        _subtitle1(),
        _horizontalList(),
        _subtitle2(),
        _verticalList()
      ],
    );
  }

  SliverAppBar _header() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 200.0,
      flexibleSpace: FlexibleSpaceBar(
        title: Text("QRtendence"),
        background: Image.asset(
          'assets/images/background.png',
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  StreamBuilder _horizontalList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('semester')
          .where('userId', isEqualTo: widget.userId)
          // .orderBy('semester', descending: false)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return SliverFillRemaining(
            child: Center(
              child: Container(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        return SliverToBoxAdapter(
          child: Container(
            height: 200.0,
            child: Swiper(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.documents.length,
              viewportFraction: 0.6,
              scale: 0.4,
              loop: false,
              itemBuilder: (context, index) => SemesterCard(
                  context,
                  Classes.fromMap(snapshot.data.documents[index], index),
                  widget.userId),
            ),
          ),
        );
      },
    );
  }

  SliverToBoxAdapter _subtitle1() {
    return SliverToBoxAdapter(
      child: Row(
        children: <Widget>[
          Text(
            'Semester',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
          Expanded(
            child: Hero(
              tag: 'addSemester',
              child: Container(
                alignment: Alignment.centerRight,
                child: IconButton(
                  color: Colors.purple,
                  icon: Icon(Icons.add),
                  onPressed: () => Navigator.push(
                      context,
                      HeroDialogRoute(
                          builder: (BuildContext context) =>
                              AddSemester(userId: widget.userId))),
                  // Navigator.of(context).push(
                  //       PageRouteBuilder<Null>(
                  //         pageBuilder: (
                  //           BuildContext context,
                  //           Animation<double> animation,
                  //           Animation<double> secondaryAnimation,
                  //         ) {
                  //           return AnimatedBuilder(
                  //             animation: animation,
                  //             builder: (
                  //               BuildContext context,
                  //               Widget child,
                  //             ) {
                  //               return Opacity(
                  //                 opacity: animation.value,
                  //                 child: AddSemester(userId: widget.userId),
                  //               );
                  //             },
                  //           );
                  //         },
                  //         transitionDuration: Duration(milliseconds: 600),
                  //       ),
                  //     ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SliverToBoxAdapter _subtitle2() {
    return SliverToBoxAdapter(
      child: Text(
        'Recently',
        style: TextStyle(
          fontSize: 30.0,
        ),
      ),
    );
  }

  StreamBuilder _verticalList() {
    return StreamBuilder(
      stream: Firestore.instance.collection("admin").snapshots(),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return SliverFillRemaining(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.all(20.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                DocumentSnapshot ds = snapshot.data.documents[index];
                return InkWell(
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
                                  child: ClassesWidget(
                                    context,
                                    Classes.fromMap(ds, index),
                                  ),
                                );
                              },
                            );
                          },
                          transitionDuration: Duration(milliseconds: 600),
                        ),
                      ),
                  child: Hero(
                    tag: 'classesCard$index',
                    child: Container(
                      child: ClassesCard(
                        context,
                        Classes.fromMap(ds, index),
                      ),
                    ),
                  ),
                );
              },
              childCount: snapshot.data.documents.length,
            ),
          ),
        );
      },
    );
  }
}
