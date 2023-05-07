import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:we_chat/helper/dialogs.dart';
import 'package:we_chat/main.dart';
import 'package:we_chat/screens/home_screen.dart';

import '../../api/apis.dart';

//to handel click on the google sign in button

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _isAnimate = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        _isAnimate = true;
      });
    });
  }

  //code for google sign
  Future<UserCredential?> _signInWithGoogle() async {
    try {
      await InternetAddress.lookup('google.com');

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    } catch (e) {
      log("\n_signInWithGoogle: $e");
      Dialogs.showSnackbar(context, "SomeThing went wrong(Check Internet)");
      return (null);
    }
  }

  //handles google login button click
  _handleGoogleBtnClick() {
    //for showing progress bar
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async {
      //for hiding progress bar
      Navigator.pop(context);
      if (user != null) {
        log("\nuser:${user.user}");
        log("\nuserAdditionalInfo :${user.additionalUserInfo}");

        if ((await APIs.userExists())) {
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (_) => HomeScreen()));
        } else {
          await APIs.CreateUser().then((value) {
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeScreen()));
          });
        }
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
          AnimatedPositioned(
              top: mq.height * 0.15,
              width: mq.width * 0.5,
              right: _isAnimate ? mq.width * 0.25 : -mq.width * .5,
              duration: Duration(seconds: 1),
              child: Image.asset('images/icon.png')),
          //google login button
          Positioned(
              bottom: mq.height * 0.15,
              width: mq.width * .9,
              left: mq.width * .05,
              height: mq.height * 0.07,
              child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 223, 255, 187),
                      shape: StadiumBorder(),
                      elevation: 1),
                  onPressed: () {
                    _handleGoogleBtnClick();
                  },
                  icon: Image.asset(
                    'images/google.png',
                    height: mq.height * 0.03,
                  ),
                  label: RichText(
                    text: TextSpan(
                        style: TextStyle(color: Colors.black, fontSize: 16),
                        children: [
                          TextSpan(text: "Login With"),
                          TextSpan(
                              text: " Google",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ]),
                  ))),
        ],
      ),
    );
  }
}
