// import 'dart:async';

// import 'package:flutter/material.dart';
// // import 'package:qrtendance/ui/widgets/class_card.dart';
// import 'package:qrtendance/model/classes_model.dart';
// import 'package:qrtendance/utils/theme.dart';
// import 'package:after_layout/after_layout.dart';

// class ClassDetail extends StatefulWidget {
//   final Classes classes;

//   ClassDetail({@required this.classes});

//   @override
//   ClassesDetailState createState() {
//     return new ClassesDetailState();
//   }
// }

// class ClassesDetailState extends State<ClassDetail> with AfterLayoutMixin<ClassDetail> {
//   bool showCorner = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: primaryColor,
//       body: Column(
//         children: <Widget>[
//           SizedBox(height: 50.0),
//           Align(
//             alignment: Alignment.topLeft,
//             child: Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: InkWell(
//                 child: Icon(
//                   Icons.chevron_left,
//                   color: Colors.white,
//                 ),
//                 onTap: () {
//                   Navigator.of(context).pop();
//                 },
//               ),
//             ),
//           ),
//           SizedBox(height: 40.0),
//           Hero(
//             tag: widget.classes.id,
//             child: ClassCardWidget(
//               classes: widget.classes,
//               showQR: false,
//             ),
//           ),
//           Spacer(),
//           Hero(
//             tag: "qrcode",
//             child: Stack(
//               children: <Widget>[
//                 getCorners(),
//                 Image.asset(
//                   "assets/images/qrcode.png",
//                   width: 140.0,
//                   color: Colors.white,
//                 ),
//               ],
//             ),
//           ),
//           SizedBox(height: 80.0),
//         ],
//       ),
//     );
//   }

//   Widget getCorners() {
//     return AnimatedPositioned(
//       duration: Duration(milliseconds: 300),
//       left: showCorner ? 0 : 30,
//       top: showCorner ? 0 : 30,
//       width: showCorner ? 140 : 80,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         width: showCorner ? 140 : 80,
//         height: showCorner ? 140 : 80,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: <Widget>[
//             Row(
//               mainAxisSize: showCorner ? MainAxisSize.max : MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 RotatedBox(quarterTurns: 0, child: Image.asset("assets/images/corners.png", width: 25.0,)),
//                 RotatedBox(quarterTurns: 1, child: Image.asset("assets/images/corners.png", width: 25.0,)),
//               ],
//             ),
//             Spacer(),
//             Row(
//               mainAxisSize: showCorner ? MainAxisSize.max : MainAxisSize.min,
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: <Widget>[
//                 RotatedBox(quarterTurns: 3, child: Image.asset("assets/images/corners.png", width: 25.0,)),
//                 RotatedBox(quarterTurns: 2, child: Image.asset("assets/images/corners.png", width: 25.0,)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   @override
//   void afterFirstLayout(BuildContext context) {
//     startTimer();
//   }

//   startTimer() {
//     var duration = Duration(milliseconds: 300);
//     Timer(duration, showCorners);
//   }

//   showCorners() {
//     setState(() {
//       showCorner = true;
//     });
//   }
// }