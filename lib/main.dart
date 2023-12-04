import 'package:flutter/material.dart';
import 'package:sisaku/pages/home_page.dart';
import 'package:sisaku/colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(selectedDate: DateTime.now()),
      theme: ThemeData(
        primaryColor: primary,
        primarySwatch: Colors.cyan,
      ),
    );
  }
}
