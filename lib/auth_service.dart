import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';

import 'Screens/home_page.dart';

class AuthService {
  //Determine if the user is authenticated and redirect accordingly
  handleAuthState() {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
          // user is authorozed hence redirect to home screen
          return HomePage();
          } else
          // user not authorized hence redirect to login page
          return Login();
        });
  }
}