import 'package:flutter/material.dart';
import 'package:qrtendance/utils/auth.dart';
import 'package:qrtendance/utils/auth_provider.dart';
import 'package:qrtendance/root.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  
  @override
  Widget build(BuildContext context) {
    return AuthProvider(
      auth: Auth(),
      child: MaterialApp(
        title: 'Flutter login demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: RootPage(),
      ),
    );
  }
}
