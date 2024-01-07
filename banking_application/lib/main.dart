import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './screens/base_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Live code Bank App",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        fontFamily: "poppins",
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        primarySwatch: Colors.blue,
      ),
      home: BaseScreen(),
    );
  }
}
