import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:QRtendance/model/classes_model.dart';
import 'package:QRtendance/ui/widgets/card/analysis_card.dart';
import 'package:QRtendance/utils/theme.dart';

class SummaryTab extends StatefulWidget {
  SummaryTab({this.userId});
  final String userId;
  @override
  _SummaryTabState createState() => _SummaryTabState();
}

class _SummaryTabState extends State<SummaryTab> {
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
            _body(),
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
        title: Text(
          'Summary',
          style: cardTitleBigInv,
        ),
      ),
    );
  }

  StreamBuilder _body() {
    return StreamBuilder(
      stream: Firestore.instance
          .collection('groupClass')
          .where('userId', isEqualTo: widget.userId)
          .orderBy('semester', descending: false)
          .orderBy('codeCourse', descending: false)
          .orderBy('groupClass', descending: false)
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
            height: 300.0,
            child: Swiper(
              scrollDirection: Axis.horizontal,
              itemCount: snapshot.data.documents.length,
              viewportFraction: 0.8,
              scale: 0.9,
              loop: false,
              itemBuilder: (context, index) => AnalysisCard(
                  context,
                  Classes.fromMap(snapshot.data.documents[index], index),
                  widget.userId),
            ),
          ),
        );
      },
    );
  }
}
