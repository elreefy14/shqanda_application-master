import 'package:cloud_firestore/cloud_firestore.dart';
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
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  loginAdmin() {
    FirebaseFirestore.instance.collection('admins').get().then((snapshot){
      snapshot.docs.forEach((result) {
        if(result.data()['id']!=_adminIDTextEditing.text){
       //   Scaffold.of(context).showSnackBar(SnackBar(content:Text('your id is not correct')));
        }
        else  if(result.data()["password"]!=_passwordTextEditing.text){
       //   Scaffold.of(context).showSnackBar(SnackBar(content:Text('your password is not correct')));
        }
        else{
         // Scaffold.of(context).showSnackBar(SnackBar(content:Text('welcome admin'+result.data()['name'])));
         //  setState(() {
         //    _adminIDTextEditing.text='';
         //    _passwordTextEditing.text='';
         //  });
          Route route=MaterialPageRoute(builder: (c)=>AdminPanel());
          Navigator.pushReplacement(context, route);
        }
      });
    });

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