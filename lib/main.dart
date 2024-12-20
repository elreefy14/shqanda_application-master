import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shqanda_application/Admin/admin_panel.dart';
import 'package:shqanda_application/Provider/product_provider.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Utils/Langs/translations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Initialize auth state
  final authState = await AuthService.initializeAuthState();

  runApp(MyApp(initialAuthState: authState));
}

class AuthService {
  static Future<AuthState> initializeAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final User? firebaseUser = FirebaseAuth.instance.currentUser;

    if (firebaseUser == null) {
      return AuthState.notAuthenticated;
    }

    // Check user type from SharedPreferences
    final String? userType = prefs.getString('userType');

    if (userType == 'admin') {
      // Verify admin status in Firestore
      final adminDoc = await FirebaseFirestore.instance
          .collection('admins')
          .doc(firebaseUser.uid)
          .get();

      if (adminDoc.exists) {
        return AuthState.authenticatedAdmin;
      }
    } else if (userType == 'user') {
      return AuthState.authenticatedUser;
    }

    // If no valid auth state is found, clear preferences and return not authenticated
    await prefs.clear();
    return AuthState.notAuthenticated;
  }
}

enum AuthState {
  notAuthenticated,
  authenticatedUser,
  authenticatedAdmin
}

class MyApp extends StatelessWidget {
  final AuthState initialAuthState;

  const MyApp({Key? key, required this.initialAuthState}) : super(key: key);

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
        home: _getInitialScreen(initialAuthState),
      ),
    );
  }

  Widget _getInitialScreen(AuthState authState) {
    switch (authState) {
      case AuthState.authenticatedAdmin:
        return AdminPanel();
      case AuthState.authenticatedUser:
        return HomePage();
      case AuthState.notAuthenticated:
      default:
        return Login();
    }
  }
}