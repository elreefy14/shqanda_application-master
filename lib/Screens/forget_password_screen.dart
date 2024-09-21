import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shqanda_application/Screens/confirm_email_page.dart';
class ForgetPasswordScreen extends StatefulWidget {
  static String id = 'forgot-password';
  final String message =
      "An email has just been sent to you, Click the link provided to complete password reset";
  @override
  _ForgetPasswordScreenState createState() => _ForgetPasswordScreenState();
}
class _ForgetPasswordScreenState extends State<ForgetPasswordScreen> {
  final _auth = FirebaseAuth.instance;
  final _formKey = GlobalKey<FormState>();
   late String _email;
  _passwordReset()async {
    try {
      _formKey.currentState!.save();
      final user = await _auth.sendPasswordResetEmail(email: _email);
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return ConfirmEmail(message: widget.message,);
        }),
      );
    } catch (e) {
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
