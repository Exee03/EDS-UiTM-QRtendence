import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qrtendance/utils/auth_provider.dart';
import 'package:qrtendance/utils/firebase_provider.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab(this.onSignedOut, {this.userId});
  final VoidCallback onSignedOut;
  final String userId;

  @override
  ProfileTabState createState() {
    return new ProfileTabState();
  }
}

class ProfileTabState extends State<ProfileTab> {
  Future<void> _signOut(BuildContext context) async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      await auth.signOut();
      widget.onSignedOut();
      print('SignOut!!!');
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: Firestore.instance
              .collection('users')
              .where('uid', isEqualTo: widget.userId)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: Container(
                  child: CircularProgressIndicator(),
                ),
              );
            }
            return ListView(
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(28.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Colors.blue,
                      Colors.lightBlueAccent,
                    ]),
                  ),
                  child: Column(
                    children: <Widget>[
                      Hero(
                        tag: 'hero',
                        child: Padding(
                          padding: EdgeInsets.all(16.0),
                          child: CircleAvatar(
                            radius: 72.0,
                            backgroundColor: Colors.transparent,
                            backgroundImage:
                                AssetImage('assets/images/avatar.jpg'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Welcome Alucard',
                          style: TextStyle(fontSize: 28.0, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Lorem ipsum dolor asdasdasdasdasdasdasdasdasjhsadfm,bas,dbkjfkjsadkbkjsdbvksbdvkjbskdvbksdabvkbjasdkjvbskljabdvklabjsdkvjbsakdvbkbsadvkjbsjkdvbkjsdbvklsbdvkasbvksjabvkjbskdvbklsdbvklbskldasdasdasdasdasdsadfasdfsvxcvxzcvxzcvxcvxzcvxcvvbsit amet, consectetur adipiscing elit. Donec hendrerit condimentum mauris id tempor. Praesent eu commodo lacus. Praesent eget mi sed libero eleifend tempor. Sed at fringilla ipsum. Duis malesuada feugiat urna vitae convallis. Aliquam eu libero arcu.',
                          style: TextStyle(fontSize: 20.0, color: Colors.white),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () => _signOut(context),
                          color: Colors.red,
                          textColor: Colors.black,
                          child: Text('SignOut'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
    );
  }
}
