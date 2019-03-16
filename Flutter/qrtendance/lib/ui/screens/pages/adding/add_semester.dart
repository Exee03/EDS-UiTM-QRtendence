import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:QRtendance/utils/theme.dart';

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
        title: Text('SEMESTER', style: cardTitleBig ,textAlign: TextAlign.center,),
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
                        child: Text('Sesi', style: bigTextStyle),
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
                        child: Text('Tahun', style: bigTextStyle),
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
                icon: Icon(Icons.add,color: Colors.white,),
                onPressed: () => _addData(),
                label: Text('ADD SEMESTER',style: mediumTextStyleInv,),
                elevation: 5.0,
              ),
            ),
          ),
        ],
        
      ),
    );
  }
}
