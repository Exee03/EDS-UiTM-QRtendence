import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/utils/auth_provider.dart';
import 'package:QRtendance/utils/firebase_provider.dart';
import 'package:QRtendance/utils/theme.dart';

class ProfileTab extends StatefulWidget {
  ProfileTab({
    this.onSignedOut,
    this.userId,
  });
  final VoidCallback onSignedOut;
  final String userId;

  @override
  ProfileTabState createState() {
    return new ProfileTabState();
  }
}

class ProfileTabState extends State<ProfileTab> {
  String photoURL;
  String name;
  String email;

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

  loadData() async {
    DocumentSnapshot doc = await Firestore.instance
        .collection('users')
        .document(widget.userId)
        .get();
    setState(() {
      photoURL = doc.data['photoURL'];
      name = doc.data['displayName'];
      email = doc.data['email'];
    });
  }

  @override
  Widget build(BuildContext context) {
    loadData();
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

  _avatar() {
    if (photoURL == null) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return CircleAvatar(
        radius: 50.0,
        backgroundColor: Colors.white30,
        backgroundImage: NetworkImage(photoURL));
  }

  _profileName() {
    if (name == null) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.only(left: 8.0, right: 8.0, top: 50),
      child: Text(
        name,
        style: bigTextStyle,
      ),
    );
  }

  _profileEmail() {
    if (email == null) {
      return Center(
        child: Container(
          child: CircularProgressIndicator(),
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        email,
        style: mediumTextStyle,
      ),
    );
  }

  SliverAppBar _header() {
    return SliverAppBar(
      expandedHeight: 200.0,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        title: _avatar(),
      ),
    );
  }

  SliverToBoxAdapter _body() {
    return SliverToBoxAdapter(
      child: Container(
        height: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _profileName(),
            _profileEmail(),
            Padding(
              padding:
                  const EdgeInsets.only(right: 50.0, left: 50.0, top: 50.0),
              child: RaisedButton(
                elevation: 2.0,
                splashColor: Colors.red,
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                onPressed: () => _signOut(context),
                color: Colors.white,
                textColor: Colors.black,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.exit_to_app),
                    Text('Sign Out'),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
