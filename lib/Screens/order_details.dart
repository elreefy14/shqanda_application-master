import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  final String name;
  final String name_arabic;
  final String image;
  final int totalPrice;
  final String user_id;
  final String amount;
  final DateTime createdAt;
  final int price;
  final int quantity;
  final String userEmail;
  final String userName;
  final String userPhoneNumber;
  final String userAddress;
  final String id;
  const OrderDetails({Key? key,required this.id,required this.createdAt, required this.name,required this.name_arabic, required this.image, required this.totalPrice, required this.user_id, required this.amount, required this.price, required this.quantity,required this.userName,required this.userAddress,required this.userPhoneNumber,required this.userEmail}) : super(key: key);
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  String ?myString;
  String _selectedLang = 'en';
  bool _isVisible = true;

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
      print("shared:$myString");
    });
  }
  //final Future<bool> Alreadyordered=widget.createdAt.subtract(Duration(minutes: 10)) as Future<bool>;
  @override
  void initState(){
    // TODO: implement initState
    super.initState();
    setState(() {
      _loadCounter();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        backgroundColor:Color(0xFFF2C51D),
        title: Text('Order Details'.tr),
        centerTitle: true,
      ),
   body: ListView(
     scrollDirection: Axis.vertical,
     children: [
       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(
           children: [
             Text('User Name'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
             Text('${widget.userName}'),
           ],
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(

           children: [
             Text('User Address'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
             Text('${widget.userAddress}'),
           ],
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(

           children: [
             Text('Phone Number'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
             Text('${widget.userPhoneNumber}'),
           ],
         ),
       ),
       Padding(
         padding: const EdgeInsets.all(10.0),
         child: Column(

           children: [
             Text('User Email'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
             Text('${widget.userEmail}'),
           ],
         ),
       ),
        Divider(
          thickness: 1,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20,right: 20,top: 10),
          child: Text('Order'.tr,style: TextStyle(color: Color(0xFF9E9E9E),fontSize: 18,fontWeight: FontWeight.bold),),
        ),
        Card(
          elevation: 5,
          shape: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network('${widget.image}')),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(

                  children: [
                    Text('product name:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18),),
                    myString=='en' ? Text('${widget.name}'):Text('${widget.name_arabic}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children:[
                    Text('Product Price:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                    Text('${widget.price.toStringAsFixed(2) } EGP'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children:[
                    Text('Quantity:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                    Text('${widget.quantity}'),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child:Row(
                  children:[
                    Text('Total Price:'.tr+'\t',style:TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                    Text('${(widget.quantity *widget.price).toStringAsFixed(2)} EGP'),
                  ],
                ),
              ),
                 widget.createdAt.subtract(Duration(minutes: 10))==true?
                  Visibility(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                        height: 50,
                        width: 150,
                        child: RaisedButton(
                          onPressed: ()async{
                            // final itemRef= await FirebaseFirestore.instance.collection('Orders');
                            // itemRef.doc(widget.id).delete();
                          },
                          color: Color(0xFFF2C51D),
                          child: Text('Cancel',style:TextStyle(color: Colors.white),),
                        ),
                      ),

                    ),
                  )
                :  Padding(
                   padding: const EdgeInsets.all(10.0),
                   child: Container(
                     height: 50,
                     width: 150,
                     child: RaisedButton(
                       onPressed: ()async{
                         final itemRef= await FirebaseFirestore.instance.collection('Orders');
                         itemRef.doc(widget.user_id).update({
                           'product':FieldValue.arrayRemove([{'orderId':widget.id}])
                         });
                       },
                       color: Color(0xFFF2C51D),
                       child: Text('Cancel',style:TextStyle(color: Colors.white),),
                     ),
                   ),

                 )


            ],
          ),
        )
     ],
     )
    );
  }
}