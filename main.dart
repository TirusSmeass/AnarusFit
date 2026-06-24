import 'package:flutter/material.dart';
import 'splash_screen.dart';

void main() {
  runApp(const AnarusFitApp());
}

class AnarusFitApp extends StatelessWidget {
  const AnarusFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AnarusFit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.green,
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}