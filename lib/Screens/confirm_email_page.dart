import 'package:flutter/material.dart';

class ConfirmEmail extends StatefulWidget {
  static String id = 'confirm-email';
  final String message;

  const ConfirmEmail({required this.message});
  @override
  _ConfirmEmailState createState() => _ConfirmEmailState();
}

class _ConfirmEmailState extends State<ConfirmEmail> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
