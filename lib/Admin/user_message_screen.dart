import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class UserMessageScreen extends StatefulWidget {

  @override
  _UserMessageScreenState createState() => _UserMessageScreenState();
}
class _UserMessageScreenState extends State<UserMessageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
       title: Text('Show Messages'.tr),
        centerTitle: true,
        backgroundColor: Color(0xFFF2C51D),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: StreamBuilder(

          stream: FirebaseFirestore.instance.collection('Messages').snapshots(),
          builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
            return ListView.builder(
                itemCount: snapshot.data?.docs.length,

                itemBuilder: (context,index){
              QueryDocumentSnapshot?x=snapshot.data?.docs[index];
               if(snapshot.hasData){
                 return Padding(
                   padding: const EdgeInsets.all(8.0),
                   child: InkWell(
                     child: Card(
                       shape: OutlineInputBorder(
                         borderSide: BorderSide.none,
                         borderRadius: BorderRadius.circular(15)
                       ),
                       child: Container(

                         child: Column(
                           children: [
                             Padding(
                               padding: const EdgeInsets.all(8.0),
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   Text('Name:'.tr+'\t\t\t',style: TextStyle(color: Color(0xFFF2C51D)),),
                                   Center(child: Text('${x?['userName']}')),

                                 ],
                               ),
                             ),
                             Padding(
                               padding:const EdgeInsets.all(8.0),
                               child:Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children:[
                                   Text('Email:'.tr+'\t\t\t',style: TextStyle(color: Color(0xFFF2C51D)),),
                                   Center(child: Text('${x?['email']}')),
                                 ],
                               ),
                             ),
                                 ListTile(
                                 title:Text('Message:'.tr+'\t\t\t',style: TextStyle(color: Color(0xFFF2C51D)),),
                                 subtitle:Text('${x?['message']}') ,
                                ),
                           ],
                         ),
                       ),
                     ),
                   ),
                 );
               }else{
                 return Center(child: CircularProgressIndicator());
               }
            });
          },
        ),
      ),
    );
  }
}
