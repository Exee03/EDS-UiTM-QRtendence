// import 'package:flutter/material.dart';
// import 'package:qrtendance/utils/theme.dart';

// class AirportDetailWidget extends StatelessWidget {
//   final String codeCourse, codeProgram, day;

//   AirportDetailWidget({this.codeCourse, this.codeProgram, this.day});

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         buildDetailColumn("terminal", codeCourse),
//         Spacer(),
//         buildDetailColumn("game", codeProgram),
//         Spacer(),
//         buildDetailColumn("boarding", day),
//       ],
//     );
//   }

//   Widget buildDetailColumn(String label, String value) => Column(
//     crossAxisAlignment: CrossAxisAlignment.start,
//     mainAxisSize: MainAxisSize.max,
//     children: <Widget>[
//       Text(label.toUpperCase(), style: smallTextStyle),
//       Text(value, style: smallBoldTextStyle),
//     ],
//   );
// }