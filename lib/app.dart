import 'package:flutter/material.dart';
import 'package:note/screen/home_screen.dart';
import 'package:note/screen/navigation/navigation_bar.dart';
import 'package:note/screen/second_screen.dart';
import 'package:note/screen/splash_screen.dart';
import 'package:note/screen/third_screen.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notes App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
        ),
      initialRoute: '/splash',
      routes: {
        '/' : (context) => MainNavigation(),
        '/spalsh': (context) => const SplashScreen(),
        '/second': (context) => SecondScreen(),
        '/third': (context) => ThirdScreen(),
      },
    );
  }
}