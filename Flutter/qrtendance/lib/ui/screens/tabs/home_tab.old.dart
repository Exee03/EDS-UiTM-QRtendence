// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:qrtendance/utils/auth_provider.dart';
// import 'package:qrtendance/utils/firebase_provider.dart';

// class HomeTab extends StatefulWidget {
//   @override
//   _HomeTabState createState() => _HomeTabState();
// }

// class _HomeTabState extends State<HomeTab> {
//   String doc = 'name';
//   String col = "test";
//   Future loadData() async {
//     try {
//       final BaseAuth auth = AuthProvider.of(context).auth;
//       return auth.getDoc(col);
//     } catch (e) {
//       print(e);
//     }
//   }

//   // Future loadStream() async {
//   //   try {
//   //     final BaseAuth auth = AuthProvider.of(context).auth;
//   //     return auth.stream(col);
//   //   } catch (e) {
//   //     print(e);
//   //   }
//   // }

//   @override
//   Widget build(BuildContext context) {
//     return CustomScrollView(
//       scrollDirection: Axis.vertical,
//       slivers: <Widget>[
//         SliverAppBar(
//           pinned: true,
//           expandedHeight: 200.0,
//           flexibleSpace: FlexibleSpaceBar(
//             title: Text("QRtendence"),
//             background: Image.asset(
//               'assets/images/background.png',
//               fit: BoxFit.cover,
//             ),
//           ),
//         ),
//         StreamBuilder(
//           stream: Firestore.instance.collection("test").snapshots(),
//           builder: (BuildContext context, AsyncSnapshot snapshot) {
//             if (snapshot.hasData) {
//               return SliverPadding(
//                 padding: const EdgeInsets.all(20.0),
//                 sliver: SliverList(
//                   delegate: SliverChildBuilderDelegate(
//                     (BuildContext context, int index) {
//                       DocumentSnapshot ds = snapshot.data.documents[index];
//                       return InkWell(
//                         onTap: () => Navigator.of(context).push(
//                             PageRouteBuilder<Null>(
//                                 pageBuilder: (BuildContext context,
//                                     Animation<double> animation,
//                                     Animation<double> secondaryAnimation) {
//                                   return AnimatedBuilder(
//                                       animation: animation,
//                                       builder:
//                                           (BuildContext context, Widget child) {
//                                         return Opacity(
//                                           opacity: animation.value,
//                                           child: null,
//                                         );
//                                       });
//                                 },
//                                 transitionDuration:
//                                     Duration(milliseconds: 600))),

//                         // Navigator.push(context, MaterialPageRoute(
//                         //   fullscreenDialog: true,
//                         //         builder: (BuildContext context) {
//                         //       return Page1(index, ds);
//                         //     })),
//                         child: Hero(
//                           tag: index,
//                           child: Container(
//                             color: Colors.amber,
//                             margin: const EdgeInsets.all(16.0),
//                             child: Row(
//                               children: <Widget>[
//                                 Expanded(
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.max,
//                                     children: <Widget>[
//                                       Text(
//                                         ds["name"],
//                                         style: TextStyle(fontSize: 30.0),
//                                       ),
//                                       Text('index ${index.toString()}'),
//                                       Row(
//                                         children: <Widget>[
//                                           Text(
//                                             ds["value"],
//                                             style: TextStyle(fontSize: 15.0),
//                                           ),
//                                           SizedBox(height: 2.0),
//                                         ],
//                                       ),
//                                       SizedBox(height: 16.0),
//                                       Container(
//                                         height: 0.5,
//                                         color: Colors.black,
//                                       ),
//                                     ],
//                                   ),
//                                 ),
//                                 SizedBox(width: 10.0),
//                                 Hero(
//                                   tag: "qrcode${index.toString()}",
//                                   child: Image.asset(
//                                     "assets/images/qrcode.png",
//                                     width: 80.0,
//                                     color: Colors.black,
//                                   ),
//                                 )
//                               ],
//                             ),
//                           ),
//                         ),
//                       );
//                     },
//                     childCount: snapshot.data.documents.length,
//                   ),
//                 ),
//               );
//             } else {
//               return SliverFillRemaining(
//                 child: Center(
//                   child: CircularProgressIndicator(),
//                 ),
//               );
//             }
//           },
//         ),
//       ],
//     );
//   }
// }

// // FutureBuilder(
// //                       future: loadData(),
// //                       builder: (_, snapshot) {
// //                         if (snapshot.connectionState ==
// //                             ConnectionState.waiting) {
// //                           return Scaffold(
// //                             body: Container(
// //                               alignment: Alignment.center,
// //                               child: CircularProgressIndicator(),
// //                             ),
// //                           );
// //                         } else {
// //                           return ListView.builder(
// //                             itemCount: snapshot.data.length,
// //                             itemBuilder: (_, index) {
// //                               return ListTile(
// //                                 title: Hero(
// //                                   tag: index,
// //                                   child: InkWell(
// //                                     onTap: () => print(
// //                                         'tab ${snapshot.data.toString()}'),
// //                                     child: Container(
// //                                       color: Colors.purple,
// //                                       margin: const EdgeInsets.all(16.0),
// //                                       child: Row(
// //                                         children: <Widget>[
// //                                           Expanded(
// //                                             child: Column(
// //                                               mainAxisSize: MainAxisSize.max,
// //                                               children: <Widget>[
// //                                                 Row(
// //                                                   children: <Widget>[
// //                                                     Text(snapshot
// //                                                         .data[index].data[doc]),
// //                                                     SizedBox(height: 2.0),
// //                                                   ],
// //                                                 ),
// //                                                 SizedBox(height: 16.0),
// //                                                 Container(
// //                                                   height: 0.5,
// //                                                   color: Colors.black,
// //                                                 ),
// //                                               ],
// //                                             ),
// //                                           ),
// //                                           SizedBox(width: 10.0),
// //                                           Hero(
// //                                             tag: "qrcode",
// //                                             child: Image.asset(
// //                                               "assets/images/qrcode.png",
// //                                               width: 80.0,
// //                                               color: Colors.black,
// //                                             ),
// //                                           )
// //                                         ],
// //                                       ),
// //                                     ),
// //                                   ),
// //                                 ),
// //                               );
// //                             },
// //                           );
// //                         }
// //                       })
