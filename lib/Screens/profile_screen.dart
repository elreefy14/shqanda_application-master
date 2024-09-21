import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shqanda_application/Screens/edit_profile_screen.dart';

class MyProfile extends StatefulWidget {

final String userName;
final String userEmail;
final String userNumber;
final String userId;
final String userAddress;

  const MyProfile({Key? key, required this.userName, required this.userEmail, required this.userNumber, required this.userId, required this.userAddress}) : super(key: key);
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  TextEditingController? name;
     Widget _buildContainer(){
       name=TextEditingController(text: widget.userName);
       return Container();
     }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Color(0xFFF2C51D),
        title: Text('Profile'.tr),
      ),
      body:Container(
        margin: EdgeInsets.only(top: 30),
        child: Column(
          children: [
            CircleAvatar(
              radius: 80,
              child: Image.asset('assets/userImage.png',height: 200,width: 200,fit: BoxFit.fitHeight,),
              backgroundColor: Colors.grey,
            ),
         Padding(
           padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
           child: Row(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
             Text('UserName'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
               SizedBox(width: 20,),
               Text('${widget.userName}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),)

             ],
           ),
         ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Email'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
                  SizedBox(width: 20,),
                  Text('${widget.userEmail}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),)

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Phone Number'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
                  SizedBox(width: 20,),
                  Text('${widget.userNumber}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),)

                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20,left: 30,right: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Address'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.bold),),
                  SizedBox(width: 20,),
                  Text('${widget.userAddress}',style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),


                ],
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
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen(
                    userNumber: widget.userNumber,
                    userId: widget.userId,
                    userEmail: widget.userEmail,
                    userName: widget.userName,
                    userAddress: widget.userAddress,
                  )));
                },
                child: Text('Edit Profile'.tr,style: TextStyle(color: Colors.white,fontSize: 18),),
              ),
            )
          ],
        ),
      ) ,
    );
  }
}
