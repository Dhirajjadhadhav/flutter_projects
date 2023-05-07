import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:we_chat/api/apis.dart';
import 'package:we_chat/main.dart';
import './auth/login_screen.dart';
import 'package:we_chat/screens/home_screen.dart';

//splash screen
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 2000), () {
      //exit full-screen
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
      SystemChrome.setSystemUIOverlayStyle(
          SystemUiOverlayStyle(statusBarColor: Colors.transparent));

      if (APIs.auth.currentUser != null) {
        log("\nuser:${APIs.auth.currentUser}");

        //Navigate to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeScreen()));
      } else {
        //Navigate to log login screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => LoginScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    mq = MediaQuery.of(context).size;
    return Scaffold(
      //app bar
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Welcome to We chat"),
      ),
      //body
      body: Stack(
        children: [
          //app logo
          Positioned(
              top: mq.height * 0.15,
              width: mq.width * 0.5,
              right: mq.width * 0.25,
              child: Image.asset('images/icon.png')),
          //google login button
          Positioned(
              bottom: mq.height * 0.15,
              width: mq.width,
              child: Text(
                "MADE IN INDIA WITH ❤️",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 16, color: Colors.black87, letterSpacing: 0.5),
              )),
        ],
      ),
    );
  }
}
