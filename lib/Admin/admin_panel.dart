import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shqanda_application/Admin/Category_screen.dart';
import 'package:shqanda_application/Admin/cart_page.dart';
import 'package:shqanda_application/Admin/order_screen.dart';
import 'package:shqanda_application/Admin/user_message_screen.dart';
import 'package:shqanda_application/Screens/login_screen.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'add_category_screen.dart';
import 'upload_item_screen.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
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
                RaisedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage(isAdminView: true))
                    );
                  },
                  child: Text('View User Interface'.tr),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),                RaisedButton(
                  onPressed: _signOut,
                  child: Text('Sign Out'.tr),
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