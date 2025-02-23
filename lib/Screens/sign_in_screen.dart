import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'package:shqanda_application/Widgets/mytextformField.dart';
import '../Admin/admin_login_screen.dart';
import '../Admin/admin_panel.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController phone = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  bool isLoading = false;
  String? myString;

  @override
  void initState() {
    super.initState();
    _checkAuthState();
    _loadCounter();
  }

  Future<void> _checkAuthState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isSignedIn = prefs.getBool('isUserSignedIn') ?? false;
    String? userType = prefs.getString('userType');

    if (isSignedIn) {
      if (userType == 'admin') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AdminPanel()),
        );
      } else if (userType == 'user') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      }
    }
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
    });
  }

  Future<void> addUserToFirestore2(User user) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');

    // Check if user already exists
    final userDoc = await usersCollection.doc(user.uid).get();
    if (!userDoc.exists) {
      await usersCollection.doc(user.uid).set({
        'uid': user.uid,
        'email': user.email,
        'displayName': user.displayName ?? 'Unknown',
        'phoneNumber': user.phoneNumber ?? 'Not provided',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });
    } else {
      // Update last login time
      await usersCollection.doc(user.uid).update({
        'lastLogin': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> handleUserLogin(String phoneNumber) async {
    try {
      // Create or update user document in Firestore using phone number as document ID
      final userCollection = FirebaseFirestore.instance.collection('users');
      await userCollection.doc(phoneNumber).set({
        'phoneNumber': phoneNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
        'loginType': 'phone',
      }, SetOptions(merge: true));  // Using merge to preserve existing data if doc exists

      // Save authentication state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isUserSignedIn', true);
      await prefs.setString('userType', 'user');
      await prefs.setString('phoneNumber', phoneNumber);

      Fluttertoast.showToast(
        msg: "تم تسجيل الدخول بنجاح",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage()),
      );
    } catch (error) {
      print('Error in user login: $error');
      throw error;
    }
  }

  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: ["email"]).signIn();
      if (googleUser == null) throw 'Google Sign In cancelled';

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      await addUserToFirestore2(userCredential.user!);

      // Save auth state
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isUserSignedIn', true);
      await prefs.setString('userType', 'user');
      await prefs.setString('userId', userCredential.user!.uid);

      return userCredential;
    } catch (e) {
      print('Error in Google Sign In: $e');
      throw e;
    }
  }

  void submit(BuildContext context) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      String phoneNumber = phone.text.trim();
      if (phoneNumber.isEmpty) {
        throw PlatformException(
          code: 'invalid-phone',
          message: 'يرجى إدخال رقم الهاتف',
        );
      }

      await handleUserLogin(phoneNumber);
    } on PlatformException catch (error) {
      Fluttertoast.showToast(
        msg: error.message ?? "حدث خطأ غير متوقع",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (error) {
      Fluttertoast.showToast(
        msg: "حدث خطأ غير متوقع",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Widget _buildAllPart() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/main.png',
                height: 300,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 20),
              //add banner text here sying welcome to the app
              Text(
                'جادك الغيث',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 40.0),
                child: MyTextFormField(
                  name: "رقم الهاتف",
                  controller: phone,
                ),
              ),
              SizedBox(height: 90),
              isLoading
                  ? Center(child: CircularProgressIndicator())
                  : Container(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  child: Text('تسجيل الدخول', style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF2C51D),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () => submit(context),
                ),
              ),
              SizedBox(height: 60),
              // InkWell(
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => AdminLoginScreen()),
              //     );
              //   },
              //   child: Center(
              //     child: Text(
              //       'سجل الدخول كعامل في النحاه',
              //       style: TextStyle(
              //         color: Colors.blue,
              //         fontWeight: FontWeight.bold,
              //         fontFamily: 'Noto Sans Arabic ExtraCondensed',
              //         fontSize: 12,
              //         decoration: TextDecoration.underline,
              //         decorationThickness: 2.0,
              //         decorationColor: Colors.blueAccent,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      body: Stack(
        children: [
          Form(
            key: _formKey,
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[_buildAllPart()],
              ),
            ),
          ),
        ],
      ),
    );
  }
}