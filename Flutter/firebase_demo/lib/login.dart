import 'package:firebase_demo_3/main.dart';
import 'package:flutter/material.dart';
import 'auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  Animation<double> _iconAnimation;
  AnimationController _iconAnimationController;

  Map<String, dynamic> _profile;
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = new AnimationController(
        vsync: this, duration: new Duration(milliseconds: 500));
    _iconAnimation = new CurvedAnimation(
      parent: _iconAnimationController,
      curve: Curves.easeOut,
    );
    _iconAnimation.addListener(() => this.setState(() {}));
    _iconAnimationController.forward();

    authService.profile.listen((state) => setState(() => _profile = state));
    authService.loading.listen((state) => setState(() => _loading = state));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Colors.white,
        body: new Stack(
          fit: StackFit.expand,
          children: <Widget>[
            new Image(
              image: new AssetImage("assets/image/background.png"),
              fit: BoxFit.cover,
              colorBlendMode: BlendMode.darken,
              color: Colors.black26,
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
                    new FlutterLogo(
                      size: _iconAnimation.value * 140.0,
                    ),
                    new Container(
                      padding: const EdgeInsets.all(40.0),
                      child: new Form(
                        autovalidate: true,
                        child: new Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[LoginButton()],
                        ),
                      ),
                    ),
                    Container(
                        padding: EdgeInsets.all(20),
                        child: Text(_profile.toString())),
                    Text(_loading.toString())
                  ],
                ))
          ],
        ));
  }
}

class LoginButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return MyApp();
        } else {
          return Column(
            children: <Widget>[
              MaterialButton(
                onPressed: () => authService.googleSignIn(),
                color: Colors.white,
                textColor: Colors.black,
                child: Text('Login with Google'),
              ),
              MaterialButton(
                onPressed: () => authService.facebookLogin(),
                color: Colors.white,
                textColor: Colors.black,
                child: Text('Login with Facebook'),
              )
            ],
          );
        }
      },
    );
  }
}
