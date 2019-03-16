import 'package:flutter/material.dart';
import 'package:QRtendance/ui/screens/splash_screen.dart';
import 'package:QRtendance/utils/firebase_provider.dart';
import 'package:QRtendance/utils/auth_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'QRtendance',
        theme: ThemeData(
          primarySwatch: Colors.amber,
        ),
        home: SplashScreen(),
      ),
    );
  }
}
