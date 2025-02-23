import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart'; // For Google Sign-In
import 'package:cloud_firestore/cloud_firestore.dart'; // For storing user data
import 'package:shqanda_application/Admin/admin_login_screen.dart';
import 'package:shqanda_application/Screens/home_screen.dart';
import 'package:shqanda_application/Screens/sign_up_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
String emailPattern =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
RegExp regExp = new RegExp(emailPattern);
final TextEditingController emailController = TextEditingController();
final TextEditingController userNameController = TextEditingController();
final TextEditingController passwordController = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
bool obserText = true;

class _LoginScreenState extends State<LoginScreen> {
  // Firebase authentication instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void submit(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      // Email/Username sign-in
      UserCredential result;
      if (regExp.hasMatch(emailController.text)) {
        // Email sign-in
        result = await _auth.signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text);
      } else {
        // Username sign-in (assuming username is unique and stored in Firestore)
        final QuerySnapshot userSnapshot = await _firestore
            .collection('users')
            .where('username', isEqualTo: emailController.text)
            .get();
        if (userSnapshot.docs.isNotEmpty) {
          String userEmail = userSnapshot.docs.first['email'];
          result = await _auth.signInWithEmailAndPassword(
              email: userEmail, password: passwordController.text);
        } else {
          throw FirebaseAuthException(
              code: 'user-not-found', message: 'Username not found');
        }
      }

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomeScreen()));
    } on FirebaseAuthException catch (error) {
      var message = "An error occurred, please try again.";
      if (error.message != null) {
        message = error.message!;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.toString()),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Error: Wrong Username or Password"),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Theme.of(context).primaryColor,
      ));
      setState(() {
        isLoading = false;
      });
    }
  }

  void validation() async {
    if (emailController.text.isEmpty && passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Both fields are empty"),
        ),
      );
    } else if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Username or Email is empty"),
        ),
      );
    } else if (passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password is empty"),
        ),
      );
    } else if (passwordController.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Password is too short"),
        ),
      );
    } else {
      submit(context);
    }
  }

  Future<void> googleSignIn() async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
            accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

        UserCredential result = await _auth.signInWithCredential(credential);
        User? user = result.user;

        if (user != null) {
          // Check if user exists in Firestore, if not, add them
          final DocumentSnapshot docSnapshot =
          await _firestore.collection('users').doc(user.uid).get();
          if (!docSnapshot.exists) {
            _firestore.collection('users').doc(user.uid).set({
              'uid': user.uid,
              'email': user.email,
              'username': user.displayName,
              'createdAt': Timestamp.now(),
            });
          }

          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => HomeScreen()));
        }
      }
    } catch (error) {
      print("Google Sign-In error: $error");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Google Sign-In Failed"),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // appBar: AppBar(
      //   backgroundColor: Colors.deepOrange,
      //   centerTitle: true,
      //   title: Text('Log In'),
      // ),
      body: SingleChildScrollView(
        child: Card(
          shape: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height * .6,
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                          suffixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Username or Email'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obserText,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(obserText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                obserText = !obserText;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          hintText: 'Password'),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () {},
                          child: Text(
                            'Forgot Password?',
                            style: TextStyle(color: Colors.deepOrange),
                          )),
                      InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignUp()));
                          },
                          child: Text(
                            'Create account',
                            style: TextStyle(color: Colors.deepOrange),
                          )),
                    ],
                  ),
                  SizedBox(height: 20),
                  RaisedButton(
                      color: Colors.deepOrange,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none),
                      child: Text(
                        //make text in arabic
                        'تسجيل الدخول',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        validation();
                      }),
                  SizedBox(height: 20),
                  RaisedButton(
                      color: Colors.blueAccent,
                      shape: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none),
                      child: Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () {
                        googleSignIn();
                      }),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
