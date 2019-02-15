import 'package:flutter/material.dart';
import 'package:qrtendance/utils/auth.dart';
import 'package:qrtendance/utils/auth_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage({this.onSignedIn});
  final VoidCallback onSignedIn;

  @override
  _LoginPageState createState() => new _LoginPageState();
}

enum SignInMethod {
  non,
  withGoogle,
  withFacebook,
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  SignInMethod _signInMethod = SignInMethod.non;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 2000));
    _iconAnimation =
        Tween(begin: 0.0, end: 100.0).animate(_iconAnimationController)
          ..addListener(() {
            setState(() {});
          });
    _iconAnimationController.forward();
  }

  void validateAndSubmit() async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      if (_signInMethod == SignInMethod.withGoogle) {
        String userId = await auth.signInWithGoogle();
        print(userId);
        // Dialogs dialogs = new Dialogs();
        // dialogs.information(context, 'Google', userId);
        widget.onSignedIn();
      } else if (_signInMethod == SignInMethod.withFacebook) {
        String userId = await auth.signInWithFacebook();
        print(userId);
        // Dialogs dialogs = new Dialogs();
        // dialogs.information(context, 'Facebook', userId);
        widget.onSignedIn();
      } else {
        print("Please select");
      }
    } catch (e) {
      print("Error=====> $e");
    }
  }

  void loginGoogle() {
    setState(() {
      _signInMethod = SignInMethod.withGoogle;
    });
    validateAndSubmit();
  }

  void loginFacebook() {
    setState(() {
      _signInMethod = SignInMethod.withFacebook;
    });
    validateAndSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final logo = Container(
      height: _iconAnimation.value * 2.0,
      width: _iconAnimation.value * 2.0,
      child: Image.asset('assets/logo/logo.png'),
    );

    final loginButton = new Container(
      padding: const EdgeInsets.all(70.0),
      child: new Form(
        autovalidate: true,
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: loginGoogle,
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login with Google'),
            ),
            RaisedButton(
              shape: new RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              onPressed: loginFacebook,
              color: Colors.white,
              textColor: Colors.black,
              child: Text('Login with Facebook'),
            )
          ],
        ),
      ),
    );

    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/images/background.png"),
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.white70,
            ),
            new Theme(
                data: new ThemeData(
                    brightness: Brightness.dark,
                    inputDecorationTheme: new InputDecorationTheme(
                      labelStyle:
                          new TextStyle(color: Colors.purple, fontSize: 25.0),
                    )),
                isMaterialAppTheme: true,
                child: new Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    logo,
                    loginButton,
                  ],
                ))
          ],
        ));
  }
}

// class Dialogs {
//   information(BuildContext context, String title, String description) {
//     return showDialog(
//         context: context,
//         barrierDismissible: true,
//         builder: (BuildContext context) {
//           return AlertDialog(
//             title: Text(title),
//             content: SingleChildScrollView(
//               child: ListBody(
//                 children: <Widget>[Text(description)],
//               ),
//             ),
//             actions: <Widget>[
//               FlatButton(
//                 onPressed: () => Navigator.pop(context),
//                 child: Text('Ok'),
//               )
//             ],
//           );
//         });
//   }
// }
