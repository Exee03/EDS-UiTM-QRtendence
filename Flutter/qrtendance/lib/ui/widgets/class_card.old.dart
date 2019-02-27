// import 'package:flutter/material.dart';
// import 'package:qrtendance/utils/FadePageRoute.dart';
// import 'package:qrtendance/ui/widgets/airport_detail_widget.dart';
// import 'package:qrtendance/model/classes_model.dart';
// import 'package:qrtendance/ui/screens/class_detail.dart';
// import 'package:qrtendance/utils/theme.dart';

// class ClassCardWidget extends StatelessWidget {
//   final Classes classes;
//   final bool showQR;

//   ClassCardWidget({@required this.classes, this.showQR = true});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 210.0,
//       padding: showQR
//           ? const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0)
//           : const EdgeInsets.all(0.0),
//       child: Material(
//         color: primaryColor,
//         elevation: showQR ? 8.0 : 0.0,
//         borderRadius: BorderRadius.all(Radius.circular(8.0)),
//         child: InkWell(
//           onTap: () {
//             Navigator.of(context)
//                 .push(FadePageRoute(widget: ClassDetail(classes: classes)));
//           },
//           child: Container(
//             margin: const EdgeInsets.all(16.0),
//             child: Row(
//               children: <Widget>[
//                 Expanded(
//                   child: Column(
//                     mainAxisSize: MainAxisSize.max,
//                     children: <Widget>[
//                       Row(
//                         children: <Widget>[
//                           Text(classes.codeCourse.toUpperCase(),
//                               style: bigTextTitleStyle),
//                           SizedBox(height: 2.0),
//                         ],
//                       ),
//                       SizedBox(height: 16.0),
//                       Container(
//                         height: 0.5,
//                         color: Colors.white,
//                       ),
//                       SizedBox(height: 16.0),
//                       AirportDetailWidget(
//                         codeCourse: classes.codeCourse,
//                         codeProgram: classes.programme,
//                         day: classes.day,
//                       ),
//                     ],
//                   ),
//                 ),
//                 SizedBox(width: 10.0),
//                 showQR
//                     ? Hero(
//                         tag: "qrcode",
//                         child: Image.asset(
//                           "assets/images/qrcode.png",
//                           width: 80.0,
//                           color: Colors.white,
//                         ),
//                       )
//                     : Container(),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
