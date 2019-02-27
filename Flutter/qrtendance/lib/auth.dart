// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:rxdart/rxdart.dart';

// class AuthService {
//   final GoogleSignIn _googleSignIn = GoogleSignIn();
//   final FacebookLogin _facebookLogin = FacebookLogin();
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final Firestore _db = Firestore.instance;

//   Observable<FirebaseUser> user; // firebase user
//   Observable<Map<String, dynamic>> profile; // custom user data in Firestore
//   PublishSubject loading = PublishSubject();

//   // constructor
//   AuthService() {
//     user = Observable(_auth.onAuthStateChanged);

//     profile = user.switchMap((FirebaseUser u) {
//       if (u != null) {
//         return _db
//             .collection('users')
//             .document(u.uid)
//             .snapshots()
//             .map((snap) => snap.data);
//       } else {
//         return Observable.just({});
//       }
//     });
//   }

//   Future<FirebaseUser> googleSignIn() async {
//     loading.add(true);
//     GoogleSignInAccount googleUser = await _googleSignIn.signIn();
//     GoogleSignInAuthentication googleAuth = await googleUser.authentication;
//     AuthCredential credential = GoogleAuthProvider.getCredential(
//       accessToken: googleAuth.accessToken,
//       idToken: googleAuth.idToken,
//     );
//     FirebaseUser user = await _auth.signInWithCredential(credential);
//     updateUserData(user);
//     print("signed in " + user.displayName);

//     loading.add(false);
//     return user;
//   }

//   Future<FirebaseUser> facebookLogin() async {
//     loading.add(true);
//     final result = await _facebookLogin.logInWithReadPermissions(['email']);
//     FirebaseUser user =
//         await _auth.signInWithFacebook(accessToken: result.accessToken.token);
//     updateUserData(user);
//     print("signed in " + user.displayName);

//     loading.add(false);
//     return user;
//   }

//   void updateUserData(FirebaseUser user) async {
//     DocumentReference ref = _db.collection('users').document(user.uid);
//     if (user.providerData[1].providerId == "facebook.com") {
//       var bigImgUrl = "https://graph.facebook.com/" +
//           user.providerData[1].uid +
//           "/picture?height=500";
//       ref.setData({'photoURL': bigImgUrl});
//     } else if (user.providerData[1].providerId == "google.com") {
//       ref.setData({'photoURL': user.photoUrl});
//     }
//     return ref.setData({
//       'uid': user.uid,
//       'provider': user.providerData[1].providerId,
//       'email': user.email,
//       'displayName': user.displayName,
//       'lastSeen': DateTime.now()
//     }, merge: true);
//   }

//   void signOut() {
//     _auth.signOut();
//   }
// }

// final AuthService authService = AuthService();
