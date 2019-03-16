import 'package:QRtendance/root.dart';
import 'package:QRtendance/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:QRtendance/utils/firebase_provider.dart';
import 'package:QRtendance/utils/auth_provider.dart';

class LoginPage extends StatefulWidget {
  LoginPage(this.onSignedIn, this.userId);
  final VoidCallback onSignedIn;
  String userId;

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
  bool _visible = false;
  var _opacity = 0.0;

  SignInMethod _signInMethod = SignInMethod.non;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _iconAnimationController = new AnimationController(
      vsync: this,
      duration: new Duration(milliseconds: 1000),
    );
    _iconAnimation =
        Tween(begin: 0.0, end: 100.0).animate(_iconAnimationController)
          ..addListener(() {
            setState(() {
              _visible = !_visible;
            });
          });
    _iconAnimationController.forward();
    setState(() {
      _opacity = _opacity == 0.0 ? 1.0 : 0.0;
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value, style: smallTextStyle,)));
  }

  void validateAndSubmit() async {
    try {
      final BaseAuth auth = AuthProvider.of(context).auth;
      if (_signInMethod == SignInMethod.withGoogle) {
        widget.userId = await auth.signInWithGoogle();
        showInSnackBar('Welcome');
        print('LoginPage = ${widget.userId}');
        widget.onSignedIn();
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new RootPage()));
      } else if (_signInMethod == SignInMethod.withFacebook) {
        widget.userId = await auth.signInWithFacebook();
        showInSnackBar('Welcome');
        print('LoginPage = ${widget.userId}');
        widget.onSignedIn();
        Navigator.pushReplacement(
            context,
            new MaterialPageRoute(
                builder: (BuildContext context) => new RootPage()));
      } else {
        showInSnackBar("Please Select");
        print("Please select");
      }
    } catch (e) {
      showInSnackBar(e);
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
      child: new Hero(
        tag: 'logo',
        child: CircleAvatar(
          backgroundColor: Colors.white,
          radius: 50.0,
          backgroundImage: AssetImage('assets/logo/logo.png'),
        ),
      ),
    );

    final loginButton = new Container(
      padding: const EdgeInsets.all(70.0),
      child: new Form(
        autovalidate: true,
        child: new Column(
          children: <Widget>[
            AnimatedOpacity(
              // If the Widget should be visible, animate to 1.0 (fully visible).
              // If the Widget should be hidden, animate to 0.0 (invisible).
              opacity: _opacity,
              duration: Duration(milliseconds: 500),
              // The green box needs to be the child of the AnimatedOpacity
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  RaisedButton(
                    elevation: 2.0,
                    splashColor: Colors.green,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: loginGoogle,
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/logo/google.png',
                          height: 40.0,
                          width: 28.0,
                        ),
                        Text('Login via Google',style: smallTextStyle),
                      ],
                    ),
                  ),
                  RaisedButton(
                    elevation: 2.0,
                    splashColor: Colors.blue,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0)),
                    onPressed: loginFacebook,
                    color: Colors.white,
                    textColor: Colors.black,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Image.asset(
                          'assets/logo/facebook.png',
                          height: 40.0,
                          width: 40.0,
                        ),
                        Text('Login via Facebook',style: smallTextStyle,),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );

    return new Scaffold(
        key: _scaffoldKey,
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
