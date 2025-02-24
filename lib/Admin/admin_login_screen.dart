import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/admin_panel.dart';

class AdminLoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Directly navigate to admin panel
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPanel()),
      );
    });

    // Return a loading screen while navigation happens
    return Scaffold(
      body: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
