import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'package:sisaku/pages/home_page.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:sisaku/pages/setting_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: 'assets/img/logo.png',
      nextScreen: HomePage(selectedDate: DateTime.now()),
      splashTransition: SplashTransition.scaleTransition,
      pageTransitionType: PageTransitionType.bottomToTop,
      backgroundColor: (SchedulerBinding.instance.window.platformBrightness ==
              Brightness.dark)
          ? background
          : Colors.white,
    );
  }
}
