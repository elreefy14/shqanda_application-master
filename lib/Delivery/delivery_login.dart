import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shqanda_application/Admin/cart_page.dart';
import 'package:shqanda_application/Delivery/delivery_access.dart';

class DeliveryLogin extends StatefulWidget {
  // final String myString;
  //
  // const DeliveryLogin({ required this.myString});
  @override
  _DeliveryLoginState createState() => _DeliveryLoginState();
}
class _DeliveryLoginState extends State<DeliveryLogin> {
  final TextEditingController _adminIDTextEditing=TextEditingController();
  final TextEditingController _passwordTextEditing=TextEditingController();
  final GlobalKey<FormState>_formKey=GlobalKey<FormState>();
  loginDelivery(){
    FirebaseFirestore.instance.collection('delivery').get().then((snapshot){
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
          Route route=MaterialPageRoute(builder: (c)=>CartPage());
          Navigator.pushReplacement(context, route);
        }
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor: Color(0xFFF2C51D),
        title: Text(''),
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding:const EdgeInsets.all(20.0),
          child: Card(
            shape: OutlineInputBorder(borderRadius:BorderRadius.circular(10),borderSide: BorderSide.none),
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
                            ?loginDelivery()
                            :Fluttertoast.showToast(msg: 'please write email and password'.tr);
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
      ) ,
    );
  }
}
