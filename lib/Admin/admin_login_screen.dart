
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/admin_panel.dart';

class AdminLoginScreen extends StatefulWidget {
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}

class _AdminLoginScreenState extends State<AdminLoginScreen> {
  final TextEditingController _adminIDTextEditing = TextEditingController();
  final TextEditingController _passwordTextEditing = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String? myString;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    _loadCounter();
  }

  Future<void> _checkAuthState() async {
    final prefs = await SharedPreferences.getInstance();
    final isSignedIn = prefs.getBool('isUserSignedIn') ?? false;
    final userType = prefs.getString('userType');

    if (isSignedIn && userType == 'admin') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => AdminPanel()),
      );
    }
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
    });
  }

  Future<void> loginAdmin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      String email = _adminIDTextEditing.text.trim();
      String password = _passwordTextEditing.text;

      if (email.isEmpty || password.isEmpty) {
        throw FirebaseAuthException(
          code: 'empty-fields',
          message: 'الرجاء إدخال البريد الإلكتروني وكلمة المرور',
        );
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      DocumentSnapshot adminSnapshot = await _firestore
          .collection('admins')
          .doc(userCredential.user!.uid)
          .get();

      if (adminSnapshot.exists) {
        // Save admin authentication state
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isUserSignedIn', true);
        await prefs.setString('userType', 'admin');
        await prefs.setString('userId', userCredential.user!.uid);
        await prefs.setString('adminEmail', email);

        // Update admin details in Firestore
        await _firestore.collection('admins').doc(userCredential.user!.uid).update({
          'lastLogin': FieldValue.serverTimestamp(),
         // 'lastLoginDevice': '${Platform.operatingSystem} ${Platform.operatingSystemVersion}',
        });

        Fluttertoast.showToast(
          msg: "تم تسجيل الدخول بنجاح كمسؤول",
          backgroundColor: Colors.green,
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (c) => AdminPanel()),
        );
      } else {
        await _auth.signOut();
        throw FirebaseAuthException(
          code: 'not-admin',
          message: 'أنت لست مسؤولاً',
        );
      }
    } on FirebaseAuthException catch (e) {
      String errorMessage = _getLocalizedErrorMessage(e.code);
      Fluttertoast.showToast(
        msg: errorMessage,
        backgroundColor: Colors.red,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "حدث خطأ غير معروف.",
        backgroundColor: Colors.red,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  String _getLocalizedErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'invalid-email':
        return "البريد الإلكتروني غير صحيح.";
      case 'user-disabled':
        return "تم تعطيل هذا الحساب.";
      case 'user-not-found':
        return "هذا البريد الإلكتروني غير مسجل.";
      case 'wrong-password':
        return "كلمة المرور غير صحيحة.";
      case 'not-admin':
        return "أنت لست مسؤولاً";
      case 'empty-fields':
        return "الرجاء إدخال البريد الإلكتروني وكلمة المرور";
      default:
        return "حدث خطأ غير معروف.";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        title: Text(''),
      ),
      body: SingleChildScrollView(
        child: Directionality(
          textDirection: myString == 'en' ? TextDirection.ltr : TextDirection.rtl,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 50),
                width: 200,
                height: 50,
                child: Center(
                  child: Text(
                    'عامل في النحاة'.tr,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Sans Arabic ExtraCondensed',
                      fontSize: 18,
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                  color: Color(0xFFF2C51D),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    height: MediaQuery.of(context).size.height * .5,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TextFormField(
                            controller: _adminIDTextEditing,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.email),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'id'.tr,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال البريد الإلكتروني';
                              }
                              if (!value.contains('@')) {
                                return 'الرجاء إدخال بريد إلكتروني صحيح';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordTextEditing,
                            obscureText: true,
                            decoration: InputDecoration(
                              suffixIcon: Icon(Icons.lock),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              hintText: 'Password'.tr,
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'الرجاء إدخال كلمة المرور';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF2C51D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              onPressed: isLoading ? null : loginAdmin,
                              child: isLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                'Login'.tr,
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _adminIDTextEditing.dispose();
    _passwordTextEditing.dispose();
    super.dispose();
  }
}