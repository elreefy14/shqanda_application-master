import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/admin_panel.dart';
import 'package:shqanda_application/Delivery/delivery_login.dart';
import 'package:shqanda_application/Screens/home_screen.dart';
import 'upload_item_screen.dart';
class AdminLoginScreen extends StatefulWidget {
  // final String myString;
  // const AdminLoginScreen({ required this.myString}) ;
  @override
  _AdminLoginScreenState createState() => _AdminLoginScreenState();
}
class _AdminLoginScreenState extends State<AdminLoginScreen> {
  String ?myString;
  String _selectedLang = 'en';
  _loadCounter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  setState(() {
  myString = prefs.getString('value');
  print("shared:$myString");
  });
  }
  @override
  void initState() {
  // TODO: implement initState
  super.initState();
  setState(() {
  _loadCounter();
  });
  }
  final TextEditingController _adminIDTextEditing=TextEditingController();
  final TextEditingController _passwordTextEditing=TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  // Login admin using Firebase Authentication
  void loginAdmin() async {
    String email = _adminIDTextEditing.text;
    String password = _passwordTextEditing.text;

    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if user exists in Firestore 'admins' collection
      DocumentSnapshot adminSnapshot = await _firestore
          .collection('admins')
          .doc(userCredential.user!.uid)
          .get();

      if (adminSnapshot.exists) {
        // Navigate to admin panel
        Route route = MaterialPageRoute(builder: (c) => AdminPanel());
        Navigator.pushReplacement(context, route);
      } else {
        // Show error if not an admin
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('You are not an admin')),
        );
      }
    } on FirebaseAuthException catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.message}')),
      );
    }
  }

  // Function to add an admin
  Future<void> addAdmin() async {
    String email = 'admin@admin.com';
    String password = '123456';

    try {
      // Create the admin user in Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Store admin details in Firestore 'admins' collection
      await _firestore.collection('admins').doc(userCredential.user!.uid).set({
        'id': userCredential.user!.uid,
        'email': email,
        'password': password,
        'name': 'Admin User',
      });

      print('Admin user created successfully!');
    } on FirebaseAuthException catch (e) {
      print('Failed to create admin: ${e.message}');
    }
  }

  @override
  Widget build(BuildContext context) {
    double _screenWidth=MediaQuery.of(context).size.width;
    double _screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
appBar: AppBar(
  backgroundColor:Color(0xFFF2C51D),
  title: Text(''),
    ),
      body:SingleChildScrollView(
        child: Directionality(
          textDirection: myString=='en'?TextDirection.ltr:TextDirection.rtl,
          child: Column(
            children: [
              Stack(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 50,right: 20,left: 170),
                    width: 200,
                    height: 50,
                    child:Center(child: Text('Admin'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),)),
                    decoration:BoxDecoration(
                        color:Color(0xFFF2C51D),
                        borderRadius:BorderRadius.circular(15)
                    ),
                  ),
                  Container(
                    margin:EdgeInsets.only(top:50,right:170,left: 20),
                    width:200,
                    height:50,
                    child:InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder:(context)=>DeliveryLogin()));
                      },
                      child: Center(
                          child:Text('Delivery Boy'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),)),
                    ),
                    decoration:BoxDecoration(
                        color:Color(0xFF9E9E9E),
                        borderRadius: BorderRadius.circular(15)
                    ),
                  )
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
                  child: Container(
                    padding: const EdgeInsets.all(20.0),
                    height: MediaQuery.of(context).size.height*.5,
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _adminIDTextEditing,
                              decoration: InputDecoration(
                                  suffixIcon: Icon(Icons.email),

                                  border: OutlineInputBorder(
                                    borderRadius:BorderRadius.circular(15),
                                  ),
                                  hintText:'id'.tr
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _passwordTextEditing,
                              decoration:InputDecoration(
                                  suffixIcon: Icon(Icons.lock),
                                  border: OutlineInputBorder(
                                    borderRadius:BorderRadius.circular(15),
                                  ),
                                  hintText: 'Password'.tr
                              ),
                            ),
                          ),

                          RaisedButton(
                            shape: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(16),
                                borderSide: BorderSide.none
                            ),
                            onPressed: (){
                              _adminIDTextEditing.text.isNotEmpty&&_passwordTextEditing.text.isNotEmpty
                                  ?loginAdmin()
                                  :Fluttertoast.showToast(msg: 'please write email and password'.tr);
                              //     :showDialog(
                              //     context:context,
                              //     builder: (c){
                              //       return Text('please write email and password'.tr);
                              //     }
                              // );
                            },
                            color: Color(0xFFF2C51D),
                            child: Text('Login'.tr,style: TextStyle(color: Colors.white),),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ) ,
    );
  }
}
