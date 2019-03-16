import 'package:cloud_firestore/cloud_firestore.dart';

class Classes {
  final int id;
  final String programme;
  final String semester;
  final String part;
  final String codeCourse;
  final int numStudents;
  final String classDate;
  final String classTime;
  final String day;
  final String groupClass;
  final String scanData;
  final DateTime scanTime;

  const Classes(
      {this.id,
      this.programme,
      this.semester,
      this.part,
      this.codeCourse,
      this.numStudents,
      this.classDate,
      this.classTime,
      this.day,
      this.groupClass,
      this.scanData,
      this.scanTime});

  Classes.fromMap(DocumentSnapshot data, int index)
      : this(
          id: index,
          programme: data['programme'],
          semester: data['semester'],
          part: data['part'],
          codeCourse: data['codeCourse'],
          numStudents: data['numStudents'],
          classDate: data['classDate'],
          classTime: data['classTime'],
          day: data['day'],
          groupClass: data['groupClass'],
          scanData: data['scanData'],
          scanTime: data['scanTime'],
        );
}
