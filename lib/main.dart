import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Add this import
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shqanda_application/Admin/admin_panel.dart';
import 'package:shqanda_application/Provider/product_provider.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Utils/Langs/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Check SharedPreferences for 'isUserSignedIn'
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool isUserSignedIn = prefs.getBool('isUserSignedIn') ?? false;

  runApp(MyApp(isUserSignedIn: isUserSignedIn));
}

class MyApp extends StatelessWidget {
  final bool isUserSignedIn;

  const MyApp({Key? key, required this.isUserSignedIn}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ProductProvider>(
          create: (context) => ProductProvider(),
        ),
      ],
      child: GetMaterialApp(
        translations: Translation(),
        locale: const Locale('ar'),
        fallbackLocale: const Locale('en'),
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: isUserSignedIn
            ? HomePage()  // Navigate to HomePage if user is signed in
            : checkUserAuth(),  // Directly check for Firebase Auth status
      ),
    );
  }

  Widget checkUserAuth() {
    // Check if a user is currently authenticated
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      return AdminPanel();  // Show AdminPanel if authenticated
    } else {
      return Login();  // Show Login if not authenticated
    }
  }
}
