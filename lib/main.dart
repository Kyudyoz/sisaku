import 'package:flutter/material.dart';
import 'package:sisaku/pages/home_page.dart';
// import 'package:sisaku/colors.dart';
import 'pages/setting_page.dart';
// import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(selectedDate: DateTime.now()),
      theme: ThemeData(
        primaryColor: primary,
        primarySwatch: MaterialColor(primary.value, {
          50: Color.fromARGB(255, 255, 255, 255),
          100: Color.fromARGB(255, 255, 255, 255),
          200: Color.fromARGB(255, 255, 255, 255),
          300: Color.fromARGB(255, 255, 255, 255),
          400: Color.fromARGB(255, 255, 255, 255),
          500: primary,
          600: Color.fromARGB(255, 255, 255, 255),
          700: Color.fromARGB(255, 255, 255, 255),
          800: Color.fromARGB(255, 255, 255, 255),
          900: Color.fromARGB(255, 255, 255, 255),
        }),
      ),
    );
  }
}
