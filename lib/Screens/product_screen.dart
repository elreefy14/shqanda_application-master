import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shqanda_application/Screens/product_details_screen.dart';
import 'package:shqanda_application/Screens/sign_up_screen.dart';

class ProductScreen extends StatefulWidget {
  final String subCategory_id;

  const ProductScreen({Key? key, required this.subCategory_id}) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        title: Text('Products'.tr),
        centerTitle: true,
      ),
      body:Container(
        margin: EdgeInsets.only(top: 30),
        child: StreamBuilder (
          stream:FirebaseFirestore.instance.collection('items').where('subCategory_id',isEqualTo: widget.subCategory_id).snapshots(),
          builder: (
              BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
                itemCount: snapshot.data?.docs.length,
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 10),
                itemBuilder:(context,i){
                  QueryDocumentSnapshot?x=snapshot.data?.docs[i];
                  if(snapshot.hasData){
                    return InkWell(
                      onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(
                          product_id: x?['product_id'],
                          description_arabic:x?['description_arabic'] ,
                          image:x?['thumbnailUrl'] ,
                           title:x?['title']  ,
                           title_arabic:x?['title_arabic'] ,
                           product_description:x?['longDescription']  ,
                           amount:x?['amount']  ,
                           price:x?['price']  ,
                           orderNumber:x?['orderNum']  ,
                           shipping_duration:x?['shippingDuration']  ,



                      ))) ;
                      },
                      child: Card(
                        shape: OutlineInputBorder(
                           borderRadius: BorderRadius.circular(20),
                               borderSide: BorderSide.none
                        ),
                        child: Container(
                          child: Column(
                            children: [
                              Image.network(x?['thumbnailUrl'],width: double.infinity,height: 100,),
                              Expanded(child:myString=='en'? Text('${x?['title']}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),textAlign: TextAlign.center,):Text('${x?['title_arabic']}',style: TextStyle(color: Colors.black,fontSize: 15,fontWeight: FontWeight.normal,),textAlign: TextAlign.center,)),
                              Expanded(child: Text('${x?['price']}'+'EGP')),
                              // Expanded(child: RaisedButton(
                              //   onPressed: (){
                              //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadItemScreen(
                              //       category_id:x?['category_id'] ,
                              //     )));
                              //
                              //   },
                              //   child: Text('Add product'),
                              // ))
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  else{
                    return Center(child: CircularProgressIndicator());
                  }
                });
          },
        ),
      ),
    );
  }
}
