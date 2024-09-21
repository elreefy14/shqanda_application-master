import 'package:flutter/material.dart';

class PasswordTextFormField extends StatefulWidget {
  final bool obserText;
  final TextEditingController controller;
  final String name;
  final FocusNode textFieldFocusNode;
  final Function onTap;
  PasswordTextFormField({
    required  this.textFieldFocusNode,
    required this.controller,
    required this.onTap,
    required this.name,
    required this.obserText,
  });

  @override
  State<PasswordTextFormField> createState() => _PasswordTextFormFieldState();
}

class _PasswordTextFormFieldState extends State<PasswordTextFormField> {
  bool _obscureText = true;
  // Toggles the password show status
  void _togglePasswordStatus() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        focusNode: widget.textFieldFocusNode,
        controller: widget.controller,
        obscureText: widget.obserText,
        decoration: InputDecoration(
          border: OutlineInputBorder(      borderRadius:BorderRadius.circular(15),
          ),
          hintText: widget.name,
          suffixIcon: GestureDetector(
            onTap: widget.onTap(),
            child: Icon(
              widget.obserText == true ? Icons.visibility_off : Icons.visibility,
              color: Colors.black,
            ),
          ),
          hintStyle: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}
