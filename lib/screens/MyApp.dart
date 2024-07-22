import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';

import 'BmiPage.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: AnimatedSplashScreen(
          duration: 1500,
          splash: const Image(image: AssetImage('assets/images/logo1.png')),
          nextScreen:  BmiPage(),
          splashTransition: SplashTransition.slideTransition,
          splashIconSize: 300,
          backgroundColor: Colors.red[700]!
      ),
    );
  }
}