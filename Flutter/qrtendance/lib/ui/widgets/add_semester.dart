import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddSemester extends StatefulWidget {
  AddSemester({this.userId});
  final String userId;
  @override
  _AddSemesterState createState() => _AddSemesterState();
}

class _AddSemesterState extends State<AddSemester> {
  int _sesi = 1;
  int _year1 = 2019;
  int _year2 = 2020;

  void _addData() {
    print('Sesi ${_sesi.toString()} ${_year1.toString()}/${_year2.toString()}');
    Firestore.instance.runTransaction((Transaction transaction) async {
      CollectionReference reference = Firestore.instance.collection('semester');
      await reference.add({
        'userId': widget.userId,
        'semester':
            'Sesi ${_sesi.toString()} ${_year1.toString()}/${_year2.toString()}',
      });
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SimpleDialog(
        title: Text('SEMESTER', style: TextStyle(fontSize: 20.0),textAlign: TextAlign.center,),
        children: <Widget>[
          Container(
            height: 350.0,
            child: Column(
              children: <Widget>[
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: Text('Sesi', style: TextStyle(fontSize: 20.0)),
                      ),
                      new NumberPicker.integer(
                        initialValue: _sesi,
                        minValue: 1,
                        maxValue: 2,
                        onChanged: (newValue) =>
                            setState(() => _sesi = newValue),
                      ),
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 45.0),
                        child: Text('Tahun', style: TextStyle(fontSize: 20.0)),
                      ),
                      new NumberPicker.integer(
                        initialValue: _year1,
                        minValue: 2019,
                        maxValue: 2050,
                        onChanged: (newValue) => setState(() {
                              _year1 = newValue;
                              _year2 = _year1 + 1;
                            }),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SizedBox(
              width: 250.0,
              child: FloatingActionButton.extended(
                backgroundColor: Colors.purple,
                icon: Icon(Icons.add),
                onPressed: () => _addData(),
                label: Text('ADD SEMESTER'),
                elevation: 5.0,
              ),
            ),
          ),
        ],
        
      ),
    );

    // Hero(
    //   tag: 'addSemester',
    //   child: Scaffold(
    //     appBar: AppBar(
    //       title: Text(
    //         'Semester',
    //         style: TextStyle(color: Colors.black),
    //       ),
    //       backgroundColor: Colors.white,
    //       iconTheme: IconThemeData(color: Colors.black),
    //     ),
    //     floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    //     floatingActionButton: SizedBox(
    //       width: 250.0,
    //       child: FloatingActionButton.extended(
    //         backgroundColor: Colors.purple,
    //         icon: Icon(Icons.add_box),
    //         onPressed: () => _addData(),
    //         label: Text('ADD SEMESTER'),
    //         elevation: 5.0,
    //       ),
    //     ),
    //     body: Container(
    //       alignment: Alignment.center,
    //       child: Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: <Widget>[
    //           Text('Sesi', style: TextStyle(fontSize: 20.0)),
    //           new NumberPicker.integer(
    //             initialValue: _sesi,
    //             minValue: 1,
    //             maxValue: 2,
    //             onChanged: (newValue) => setState(() => _sesi = newValue),
    //           ),
    //           Text('Tahun', style: TextStyle(fontSize: 20.0)),
    //           new NumberPicker.integer(
    //             itemExtent: 100.0,
    //             initialValue: _year1,
    //             minValue: 2019,
    //             maxValue: 2050,
    //             onChanged: (newValue) => setState(() {
    //                   _year1 = newValue;
    //                   _year2 = _year1 + 1;
    //                 }),
    //           ),
    //           Text('/', style: TextStyle(fontSize: 20.0)),
    //           Container(
    //             // color: Colors.grey,
    //             child: Padding(
    //               padding: const EdgeInsets.only(left: 20.0),
    //               child: new Text(
    //                 _year2.toString(),
    //                 style:
    //                     TextStyle(fontSize: 25.0, color: Colors.blueAccent[200]),
    //               ),
    //             ),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
  }
}
