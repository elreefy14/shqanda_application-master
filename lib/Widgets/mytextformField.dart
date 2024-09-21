import 'package:flutter/material.dart';
class MyTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  MyTextFormField({
    required this.controller,
    required this.name,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child:TextFormField(
        controller:controller,
        decoration:InputDecoration(
          border:OutlineInputBorder(borderRadius:BorderRadius.circular(15),),
          hintText: name,
        ),
      ),
    );
  }
}
