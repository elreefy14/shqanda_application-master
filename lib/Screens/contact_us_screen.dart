import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ContactUs extends StatefulWidget {

  @override
  _ContactUsState createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> {
  FirebaseAuth _auth=FirebaseAuth.instance;
  TextEditingController _messageController=TextEditingController();
  TextEditingController _nameController=TextEditingController();
  String messageId=DateTime.now().millisecondsSinceEpoch.toString();


  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFF2C51D),
        title: Text("ContactUs".tr),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
                 Padding(
                   padding: const EdgeInsets.all(20.0),
                   child: TextFormField(

                     decoration: InputDecoration(
                       hintText: 'UserName'.tr,
                       border: OutlineInputBorder(
                         borderRadius: BorderRadius.circular(15)
                       )
                     ),
                     controller:_nameController,
                   ),
                 ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15)
                      ),
                      height: 200,
                      child: TextFormField(
                        decoration: InputDecoration(
                            hintText: 'Message'.tr,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15)
                            )
                        ),
                        controller:_messageController,
                      ),
                    ),
                  ),
                  RaisedButton(
                    color: Color(0xFFF2C51D),
                    shape: OutlineInputBorder(
                      borderSide: BorderSide.none,
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text('Send'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                      onPressed: (){
                      FirebaseFirestore.instance.collection('Messages').doc(messageId).set({
                        'messageId':messageId,
                        'userId':_auth.currentUser?.uid,
                        'message':_messageController.text,
                        'email':_auth.currentUser?.email,
                        'userName':_nameController.text
                      });
                      Fluttertoast.showToast(msg: 'Message sent successfully',gravity: ToastGravity.CENTER);
                      _nameController.clear();
                      _messageController.clear();
                      }
                      )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
