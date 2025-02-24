import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shqanda_application/Screens/start_screen.dart';

class SplashScreen extends StatefulWidget {

  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(Duration(seconds: 5),
            ()=>Navigator.pushReplacement(context,
            MaterialPageRoute(builder:
                (context) =>
                    StartScreen()
            )
        )
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(child: Image.asset('assets/logo.png',fit: BoxFit.cover,height: 200,)),
            // Padding(
            //   padding: const EdgeInsets.all(10.0),
            //   child: CircularProgressIndicator(color: Colors.red,),
            // )
          ],
        ) ,
      ),
    );
  }
}
