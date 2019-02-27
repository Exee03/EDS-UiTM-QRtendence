import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

abstract class BaseAuth {
  Future<String> signInWithGoogle();
  Future<String> signInWithFacebook();
  Future<String> currentUser();
  Future<void> signOut();
  Future getDoc(String col);
}

class Auth implements BaseAuth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FacebookLogin _facebookLogin = FacebookLogin();
  final Firestore _db = Firestore.instance;

  Future<String> signInWithGoogle() async {
    GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    FirebaseUser user = await _firebaseAuth.signInWithGoogle(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    updateUserData(user);
    return user.uid;
  }

  Future<String> signInWithFacebook() async {
    final result = await _facebookLogin.logInWithReadPermissions(['email']);
    switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        print(result.accessToken.token);
        break;
      case FacebookLoginStatus.cancelledByUser:
        print('Cancel by user');
        break;
      case FacebookLoginStatus.error:
        print('Error status :');
        print(result.errorMessage);
        break;
    }
    FirebaseUser user = await _firebaseAuth.signInWithFacebook(
      accessToken: result.accessToken.token,
    );
    updateUserData(user);
    return user.uid;
  }

  Future<String> currentUser() async {
    FirebaseUser user = await _firebaseAuth.currentUser();
    return user.uid;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  void updateUserData(FirebaseUser user) async {
    DocumentReference ref = _db.collection('users').document(user.uid);
    if (user.providerData[1].providerId == "facebook.com") {
      var bigImgUrl = "https://graph.facebook.com/" +
          user.providerData[1].uid +
          "/picture?height=500";
      ref.setData({'photoURL': bigImgUrl});
    } else if (user.providerData[1].providerId == "google.com") {
      ref.setData({'photoURL': user.photoUrl});
    }
    return ref.setData({
      'uid': user.uid,
      'provider': user.providerData[1].providerId,
      'email': user.email,
      'displayName': user.displayName,
      'lastSeen': DateTime.now()
    }, merge: true);
  }

  Future getDoc(String col) async {
    QuerySnapshot qn = await _db.collection(col).getDocuments();
    return qn.documents;
  }
}
