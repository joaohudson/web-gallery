import 'package:flutter/material.dart';
import 'package:webgallery/constants/color_schemes.dart';
import 'package:webgallery/pages/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Web Gallery',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: defaultDark,
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

