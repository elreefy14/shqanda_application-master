import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/order_details.dart';

class OrdersScreen extends StatefulWidget {
  // final String name;
  // final String image;
  // final String product_id;
  // final String user_id;
  // final String amount;
  // final int price;
  // final int quantity;
  // final String userEmail;
  // final String userName;
  // final String userPhoneNumber;
  // final String userAddress;
  // const OrdersScreen({Key? key, required this.name, required this.image, required this.product_id, required this.user_id, required this.amount, required this.price, required this.quantity,required this.userName,required this.userAddress,required this.userPhoneNumber,required this.userEmail}) : super(key: key);
  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}
class _OrdersScreenState extends State<OrdersScreen> {
  // getUser()async{
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   id= prefs.getString('UserId');
  // }
  Future getUsers() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
   var id= prefs.getString('UserId');
    var data = (await FirebaseFirestore.instance.collection('Orders').doc(id).get()).data();
    return data;
  }
  @override
  Widget build(BuildContext context) {
     return Scaffold(
       appBar:AppBar(
         backgroundColor:Color(0xFFF2C51D),
         centerTitle:true,
         title:Text('My Orders'.tr),
       ),
         body: Container(
           margin: EdgeInsets.only(top: 30),
           child: FutureBuilder(
             future:   getUsers(),
             builder: (context,AsyncSnapshot snapshot){
               return ListView.builder(
                   itemCount: snapshot.data?['product'].length,
                   itemBuilder: (context,index){
                     return Padding(
                       padding: const EdgeInsets.all(8.0),
                       child: InkWell(
                         onTap: (){
                           Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderDetails(
                            image:snapshot.data?['product'][index]['productImage'] ,
                             user_id: snapshot.data?['product'][index]['userId'],
                            name_arabic: snapshot.data?['product'][index]['ProductName_arabic'] ,
                            price: snapshot.data?['product'][index]['productPrice'],
                             quantity: snapshot.data?['product'][index]['productQuantity'],
                             name:snapshot.data?['product'][index]['ProductName'] ,
                             userEmail: snapshot.data?['product'][index]['userEmail'],
                             totalPrice: snapshot.data?['product'][index]['productPrice'] *snapshot.data?['product'][index]['productQuantity'],
                             userName:snapshot.data?['product'][index]['userName'] ,
                             userPhoneNumber:snapshot.data?['product'][index]['UsherNumber']  ,
                             userAddress: snapshot.data?['product'][index]['UserAddress'] ,
                             amount: '',
                             id: snapshot.data?['product'][index]['orderId'],
                             createdAt:snapshot.data?['product'][index]['createdAt'] ,
                           )));
                         },
                         child: Card(
                           shape: OutlineInputBorder(
                             borderSide: BorderSide.none,
                             borderRadius: BorderRadius.circular(15)

                           ),
                           child: Column(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                   children:[
                                     Text('product name:'.tr+'\t\t\t',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                     Text('${snapshot.data?['product'][index]['ProductName']}'),
                                   ],
                                 ),
                               ),
                               Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                   children: [
                                  //   Text('Total price:'.tr+'\t\t\t',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                    // Text('${(snapshot.data['product'][index]['productPrice']) *(snapshot.data['product'][index]['productQuantity'])} '),
                                   ],
                                 ),
                               ),
                             ],
                           ),
                         ),
                       ),
                     );
                   });
             },
           ),
         )

    );
  }
}
