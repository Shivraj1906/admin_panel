// ignore_for_file: prefer_const_constructors

import 'package:admin_panel/common/token.dart';
import 'package:admin_panel/pages/home_page.dart';
import 'package:admin_panel/pages/login_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Admin Panel',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<bool>(
        future: isTokenAvailable(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }

          return snapshot.data == true ? HomePage() : LoginPage();
        },
      ),
    );
  }
}
