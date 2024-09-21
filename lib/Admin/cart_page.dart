import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shqanda_application/Admin/order_screen.dart';

class CartPage extends StatefulWidget {

  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        centerTitle: true,
        title: Text('Show Orders'.tr),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('carts').snapshots(),
        builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
          return ListView.builder(
              itemCount: snapshot.data?.docs.length,
              itemBuilder: (context,index){

            QueryDocumentSnapshot?x=snapshot.data?.docs[index];
            if(snapshot.hasData){
              return InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>OrderScreen(id:x?['UserId'] ,)));

                },
                child: Card(
                  child: Image.network('${x?['productImage']}'),
                ),
              );
            }else{
              return Center(child: CircularProgressIndicator());
            }
            
          });
        },
      ),
    );
  }
}
