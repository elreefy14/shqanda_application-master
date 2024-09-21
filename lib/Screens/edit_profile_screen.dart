import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class EditProfileScreen extends StatefulWidget {
  final String userName;
  final String userEmail;
  final String userNumber;
  final String userId;
  final String userAddress;
  const EditProfileScreen({Key? key, required this.userName, required this.userEmail, required this.userNumber, required this.userId, required this.userAddress}) : super(key: key);
  @override
  _EditProfileScreenState createState() => _EditProfileScreenState();
}
class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController? name;
  TextEditingController? email;
  TextEditingController? phone;
  TextEditingController? address;
  Widget _buildContainer(){
    name=TextEditingController(text: widget.userName);
    return Container();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Edit Profile'.tr),
        backgroundColor: Color(0xFFF2C51D),
      ),
      body:Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                cursorColor: Color(0xFFF2C51D),
                controller: TextEditingController(text: widget.userName),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    helperStyle: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                cursorColor: Color(0xFFF2C51D),
                controller: TextEditingController(text: widget.userEmail),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),

                    ),

                    helperStyle: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                cursorColor: Color(0xFFF2C51D),
                controller: TextEditingController(text: widget.userNumber),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),

                    ),

                    helperStyle: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextFormField(
                cursorColor: Color(0xFFF2C51D),
                controller: TextEditingController(text: widget.userAddress),
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),

                    ),

                    helperStyle: TextStyle(color: Colors.black,fontSize: 16,fontWeight: FontWeight.bold)
                ),
              ),
            ),
            Container(
              width: 200,
              margin: EdgeInsets.only(top: 30),
              child: RaisedButton(
                color: Color(0xFFF2C51D),
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none
                ),
                onPressed: (){
                  FirebaseFirestore.instance.collection("User").doc(widget.userId).update({
                    "UserName":TextEditingController(text: widget.userName).text,
                    "UserId": widget.userId,
                    "UserEmail":TextEditingController(text: widget.userEmail).text,
                    "UserAddress": TextEditingController(text: widget.userAddress).text,
                    "AgentCode": " ",
                    "UserNumber": TextEditingController(text: widget.userNumber),
                    "Discount": 0.5,
                  });
                  Fluttertoast.showToast(msg: 'User updated successfully',gravity: ToastGravity.BOTTOM);
                  // Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen(
                  //   userNumber: widget.userNumber,
                  //   userId: widget.userId,
                  //   userEmail: widget.userEmail,
                  //   userName: widget.userName,
                  //   userAddress: widget.userAddress,
                  // )));
                },
                child: Text('Save Profile'.tr,style: TextStyle(color: Colors.white,fontSize: 18),),
              ),
            )
          ],
        ),
      ) ,
    );
  }
}
