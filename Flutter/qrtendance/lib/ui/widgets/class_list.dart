import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrtendance/utils/app_bar.dart';
import 'package:qrtendance/model/classes_model.dart';

class ClassList extends StatefulWidget {
  @override
  ClassListState createState() {
    return new ClassListState();
  }
}

class ClassListState extends State<ClassList> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    // Classes classes = Classes();
    // classes.id = "1";
    // classes.codeProgram = "EE200";
    // classes.sessions = "Jun18/19";
    // classes.semester = "6";
    // classes.codeCourse = "ELE552";
    // classes.numberStudents = "30";
    // classes.classDate = "1/9/2019";
    // classes.day = "Mon";
    Widget _buildListItem1(BuildContext context, Classes classes) {
      return Container(
        height: screenSize.height / 5,
        width: screenSize.width / 1.5,
        child: Card(
          color: Colors.amber,
          child: Text(classes.semester),
        ),
      );

      // ListTile(
      //   title: Row(
      //     children: <Widget>[
      //       Hero(
      //         tag: document['codeCourse'],
      //         child: Container(
      //           // constraints: BoxConstraints.expand(width: 350.0, height: 210.0),
      //           margin: new EdgeInsets.all(20.0),
      //           // padding: const EdgeInsets.all(10.0),
      //           child: Material(
      //             color: Colors.amber,
      //             elevation: 8.0,
      //             borderRadius: BorderRadius.all(Radius.circular(8.0)),
      //             child: InkWell(
      //               onTap: () => print(
      //                   'Tapppp ${document['semester']}!!!!!!!!!!!!!!!!!!!'),
      //               child: Container(
      //                   margin: const EdgeInsets.all(16.0),
      //                   child: Row(
      //                     children: <Widget>[
      //                       Column(
      //                           mainAxisSize: MainAxisSize.max,
      //                           children: <Widget>[
      //                             Row(
      //                               children: <Widget>[
      //                                 Text(
      //                                   document['semester'].toUpperCase(),
      //                                   style: bigTextStyle,
      //                                 ),
      //                                 SizedBox(height: 2.0),
      //                               ],
      //                             ),
      //                           ]),
      //                     ],
      //                   )
      //                   //     children: <Widget>[
      //                   //       // Expanded(
      //                   //       //   child: Column(
      //                   //       //     mainAxisSize: MainAxisSize.max,
      //                   //       //     children: <Widget>[
      //                   //       //       Row(
      //                   //       //         children: <Widget>[
      //                   //       //           Text(document['codeCourse'].toUpperCase(),
      //                   //       //           style: TextStyle(fontSize: 10.0),),
      //                   //       //           SizedBox(height: 2.0),
      //                   //       //         ],
      //                   //       //       ),
      //                   //       //       // SizedBox(height: 16.0),
      //                   //       //       Container(
      //                   //       //         height: 0.5,
      //                   //       //         color: Colors.red,
      //                   //       //       ),
      //                   //       //       // SizedBox(height: 16.0),
      //                   //       //     ],
      //                   //       //   ),
      //                   //       // ),
      //                   //       // Text(document['groupClass'])
      //                   //     ],
      //                   //   ),
      //                   ),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ],
      //   ),
      // );
    }

    Widget _buildListItem2(BuildContext context, DocumentSnapshot document) {
      return Container(
        height: screenSize.height / 4,
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Card(
          color: Colors.amber,
          child: Text(document['groupClass']),
        ),
      );
    }

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Classes'),
        body: Column(
          children: <Widget>[
            Container(
              height: screenSize.height / 4,
              child: StreamBuilder(
                stream: Firestore.instance.collection('admin').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text('Loading data... Please wait...');
                  return ListView.builder(
                    scrollDirection: Axis.horizontal,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) => _buildListItem1(context, Classes.fromMap(snapshot.data.documents[index], index)),
                  );
                },
              ),
            ),
            Text(
              'Recently',
              style: TextStyle(
                fontSize: 50.0,
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: Firestore.instance.collection('admin').snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Text('Loading data... Please wait...');
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: snapshot.data.documents.length,
                    itemBuilder: (context, index) => _buildListItem2(
                        context, snapshot.data.documents[index]),
                  );
                },
              ),
            ),
          ],
        )
        // SingleChildScrollView(
        //   scrollDirection: Axis.vertical,
        //   child: Column(
        //     children: <Widget>[
        //       ListView(
        //         scrollDirection: Axis.vertical,
        //         shrinkWrap: true,
        //         children: <Widget>[
        //           Hero(tag: classes.id, child: ClassCardWidget(classes: classes)),
        //         ],
        //       ),
        //     ],
        //   ),
        // ),
        );
  }
}

class AirportDetailWidget extends StatelessWidget {
  final String codeCourse, codeProgram, day;

  AirportDetailWidget({this.codeCourse, this.codeProgram, this.day});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        buildDetailColumn("terminal", codeCourse),
        Spacer(),
        buildDetailColumn("game", codeProgram),
        Spacer(),
        buildDetailColumn("boarding", day),
      ],
    );
  }

  Widget buildDetailColumn(String label, String value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          Text(label.toUpperCase()),
          Text(value),
        ],
      );
}
