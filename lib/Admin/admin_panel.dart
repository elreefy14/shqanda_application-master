import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shqanda_application/Admin/Category_screen.dart';
import 'package:shqanda_application/Admin/my_uploads_screen.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'add_category_screen.dart';

class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}

class _AdminPanelState extends State<AdminPanel> {
  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        centerTitle: true,
        title: Text('لوحة التحكم'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                // My Uploads Button
                ElevatedButton.icon(
                  icon: Icon(Icons.upload_file),
                  label: Text('منتجاتي'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyUploadsScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF2C51D),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.add_box),
                  label: Text('إضافة قسم'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddCategoryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF2C51D),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.category),
                  label: Text('عرض الأقسام'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CategoryScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF2C51D),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  icon: Icon(Icons.preview),
                  label: Text('عرض واجهة المستخدم'),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => HomePage(isAdminView: true)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF2C51D),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
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
