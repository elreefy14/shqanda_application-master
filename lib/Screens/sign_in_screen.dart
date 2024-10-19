import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'package:shqanda_application/Screens/sign_up_screen.dart';
import 'package:shqanda_application/Widgets/mytextformField.dart';

import '../Admin/admin_login_screen.dart';

class Login extends StatefulWidget {
  @override
  _LoginState createState() => _LoginState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
String? myString;
final TextEditingController phone = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
late bool obserText;
FirebaseAuth _auth = FirebaseAuth.instance;

class _LoginState extends State<Login> {
  @override
  void initState() {
    super.initState();
    obserText = false;
    _loadCounter();
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
    });
  }

  Future<void> addUserToFirestore2(User user) async {
    final usersCollection = FirebaseFirestore.instance.collection('users');
    await usersCollection.doc(user.uid).set({
      'uid': user.uid,
      'email': user.email,
      'displayName': user.displayName ?? 'Unknown',
      'phoneNumber': user.phoneNumber ?? 'Not provided',
    });
  }

  Future<UserCredential> signInWithGoogle() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserSignedIn',true);
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>["email"]).signIn();
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
    await addUserToFirestore2(userCredential.user!); // Add user to Firestore


    return userCredential;
  }


  void submit(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isUserSignedIn',true);
    setState(() {
      isLoading = true;
    });

    try {
      print('\n\n\n\n');
      String phoneNumber = phone.text; // Get the phone number from the input field

      // Add phone number to Firestore
      await addUserToFirestore(phoneNumber);

      // Show success toast message in Arabic
      Fluttertoast.showToast(
        msg: "تم حفظ رقم الهاتف بنجاح", // "Phone number saved successfully" in Arabic
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate to home page or any other page as needed
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));

    } on PlatformException catch (error) {
      var message = "يرجى التحقق من اتصالك بالإنترنت."; // "Please check your internet connection." in Arabic
      if (error.message != null) {
        message = error.message!;
      }

      // Show failure toast message
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } catch (error) {
      // Show generic failure toast message
      Fluttertoast.showToast(
        msg: "حدث خطأ غير متوقع.", // "An unexpected error occurred." in Arabic
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      setState(() {
        isLoading = false; // Ensure loading state is reset
      });
    }
  }

// Function to save user phone number to Firestore
  Future<void> addUserToFirestore(String phoneNumber) async {
    final userCollection = FirebaseFirestore.instance.collection('users');
    await userCollection.add({
      'phoneNumber': phoneNumber,
      // You can add more fields if needed
    });
  }

  Widget _buildAllPart() {
    return Expanded(
      child: Container(
        margin: EdgeInsets.only(top: 50),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text('Login', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
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
                child: RaisedButton(
                  child: Text('Login', style: TextStyle(color: Colors.white)),
                  color: Color(0xFFF2C51D),
                  shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  onPressed: () async {
                    submit(context);
                  },
                ),
              ),
              SizedBox(height: 10),
              Text("OR With", style: TextStyle(color: Color(0xFFF2C51D), fontSize: 16, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              GoogleAuthButton(
                onPressed: () async {
                  await signInWithGoogle();
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage()));
                },
                darkMode: false,
                style: AuthButtonStyle(iconType: AuthIconType.outlined),
              ),
              SizedBox(height: 60),
              InkWell(
                onTap: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (context) => AdminLoginScreen()));
                },
                child: Center(
                  child: Text(
                    'سجل الدخول كعامل في النحاه', // Arabic for "Login as a worker in Sqanda"
                    style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Noto Sans Arabic ExtraCondensed',
                      fontSize: 12,
                      decoration: TextDecoration.underline, // Add underline to text
                      decorationThickness: 2.0, // Adjust the thickness of the underline
                      decorationColor: Colors.blueAccent, // Optional: customize the underline color
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
  Widget build(BuildContext context) {
    return Scaffold(
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
