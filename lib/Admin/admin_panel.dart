import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import Firebase Auth
import 'package:shqanda_application/Admin/Category_screen.dart';
import 'package:shqanda_application/Admin/cart_page.dart';
import 'package:shqanda_application/Admin/order_screen.dart';
import 'package:shqanda_application/Admin/user_message_screen.dart';
import 'package:shqanda_application/Screens/login_screen.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'add_category_screen.dart';
import 'upload_item_screen.dart';
// Replace with your login screen import

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    // Clear shared preferences if needed
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This clears all the shared preferences
    // Redirect to login or splash screen after sign-out
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login())); // Replace with your login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        centerTitle: true,
        title: Text('Admin Panel'.tr),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddCategoryScreen()));
                  },
                  child: Text('Add Category'.tr),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen()));
                  },
                  child: Text('Show category'.tr),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                // RaisedButton(
                //   onPressed: () async {
                //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => CartPage()));
                //   },
                //   child: Text('Show Orders'.tr),
                //   shape: OutlineInputBorder(
                //     borderSide: BorderSide.none,
                //     borderRadius: BorderRadius.circular(14),
                //   ),
                // ),
                // RaisedButton(
                //   onPressed: () async {
                //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => UserMessageScreen()));
                //   },
                //   child: Text('Show Messages'.tr),
                //   shape: OutlineInputBorder(
                //     borderSide: BorderSide.none,
                //     borderRadius: BorderRadius.circular(14),
                //   ),
                // ),
                // Sign Out Button
                RaisedButton(
                  onPressed: _signOut,
                  child: Text('Sign Out'.tr), // Assuming you have localization set up
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
