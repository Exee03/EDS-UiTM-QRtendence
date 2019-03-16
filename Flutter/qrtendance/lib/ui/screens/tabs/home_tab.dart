import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/screens/pages/adding/add_semester.dart';
import 'package:QRtendance/ui/widgets/card/class_card_recently.dart';
import 'package:QRtendance/ui/widgets/card/semester_card.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:QRtendance/utils/dialog_page_route.dart';
import 'package:QRtendance/utils/theme.dart';

class HomeTab extends StatefulWidget {
  HomeTab({this.userId});
  final String userId;

  @override
  _HomeTabState createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  @override
  void initState() {
    super.initState();
    print(widget.userId);
    checkData();
  }

  checkData() async {
    await Firestore.instance
        .collection('semester')
        .where('userId', isEqualTo: widget.userId)
        .getDocuments()
        .then((onValue) {
      if (onValue.documents.isEmpty) {
        Navigator.push(
            context,
            HeroDialogRoute(
                builder: (BuildContext context) =>
                    AddSemester(userId: widget.userId)));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Hero(
          tag: 'semesterWidget',
          child: Padding(
            padding: const EdgeInsets.only(bottom: 230.0),
            child: Container(
              // height: screenSize.height - 20,
              decoration: ShapeDecoration(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.only(
                  bottomRight: Radius.elliptical(300.0, 100.0),
                  bottomLeft: Radius.elliptical(300.0, 100.0),
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
            _subtitle1(),
            _horizontalList(),
            _subtitle2(),
            _verticalList()
          ],
        ),
      ],
    );
  }

  SliverAppBar _header() {
    return SliverAppBar(
      expandedHeight: 200.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: Hero(
          tag: 'appTitle',
          child: Material(
            color: Colors.transparent,
            child: Text(
              "QRtendance",
              style: appTitle,
            ),
          ),
        ),
      ),
    );
  }

  SliverToBoxAdapter _subtitle1() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: Row(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Text(
                'Semester',
                style: appHeader1,
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
                  ),
                ),
              ),
            ),
          ],
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
            height: 180.0,
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

  SliverToBoxAdapter _subtitle2() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Text(
          'Recently',
          style: appHeader2,
        ),
      ),
    );
  }

  StreamBuilder _verticalList() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection("groupClass")
          .where('userId', isEqualTo: widget.userId)
          .snapshots(),
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
                return Hero(
                  tag: 'classesCard$index',
                  child: Container(
                    child: ClassCardRecently(
                      context,
                      Classes.fromMap(ds, index),
                      widget.userId,
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
