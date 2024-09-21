import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
class MakePage extends StatelessWidget {
  final String title;
  final String description;
  final bool reverse=false;
  final String image;
  final VoidCallback function;
  const MakePage({Key? key, required this.title, required this.description, required this.image, required this.function}) ;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child:Column(
          children: [
            Text(title,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 18),),
            Padding(
              padding: const EdgeInsets.only(left: 50,right: 50),
              child: Text(description,style: TextStyle(color: Color(0xFF9E9E9E),fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),),
            ),
            Image.asset(image,height: 400,fit: BoxFit.cover,),

          ],
        ),
      ),
    );
  }
}

