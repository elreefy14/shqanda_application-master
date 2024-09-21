import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Models/checkout_product_card.dart';
import 'package:shqanda_application/Screens/checkout_screen.dart';
import 'package:shqanda_application/Screens/order_details.dart';
import 'package:shqanda_application/Widgets/checkout_single_product.dart';
class CartScreen extends StatefulWidget {
 final String name;
 final String image;
 final String product_id;
 final String user_id;
 final String amount;
 final String name_arabic;
 final int price;
 final int quantity;
  const CartScreen({Key? key, required this.name, required this.image,required this.name_arabic, required this.product_id, required this.user_id, required this.amount, required this.price, required this.quantity}) : super(key: key);
  @override
  _CartScreenState createState() => _CartScreenState();
}
class _CartScreenState extends State<CartScreen> {
  List<CheckoutProductCardModel> checkOutModelList = [];
  late int number;
    CheckoutProductCardModel? checkOutModel;
  String orderId=DateTime.now().millisecondsSinceEpoch.toString();
  void deleteCheckoutProduct(int index) {
    checkOutModelList.removeAt(index);
  }
  // Future<void> deleteProductInfoById()async{
  //   final itemRef= await FirebaseFirestore.instance.collection('items');
  //   itemRef.doc(widget.id).delete();
  // }
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  User? id;
  String ?myString;
  int? x;
  String _selectedLang = 'en';
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {

      myString = prefs.getString('value');
      print("shared:$myString");
      x=prefs.getInt('number');
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _loadCounter();
    });
  }  double? total;
  late  List<CheckoutProductCardModel> myList;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text('Cart'.tr),
        centerTitle: true,
        backgroundColor:Color(0xFFF2C51D),
      ),
      body:Container(
        margin:EdgeInsets.only(top: 30),
        child:StreamBuilder(
          stream:FirebaseFirestore.instance.collection('carts').where('UserId',isEqualTo: widget.user_id).snapshots(),
          builder:(
              BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot){
            return Column(
              children:[
                Expanded(
                  flex: 8,
                  child:Container(
                    child:ListView.builder(itemBuilder:(context,i){
                      QueryDocumentSnapshot?x=snapshot.data?.docs[i];
                      if(snapshot.hasData){
                        return Stack(
                          children: [
                            Container(
                              margin:EdgeInsets.only(left: 20,right: 20),
                              child:Card(
                                color:Colors.white.withOpacity(.9),
                                shape:OutlineInputBorder(
                                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight:  Radius.circular(15)),
                                    borderSide: BorderSide.none
                                ),
                                child:Container(
                                  child:Column(
                                    children:[
                                      Row(
                                        children: [
                                           Expanded(child: Image.network(x?['productImage'],width: double.infinity,height: 100,)),
                                           Expanded(
                                            child:Column(
                                              mainAxisAlignment:MainAxisAlignment.start,
                                              children:[
                                                myString=='en'?
                                                Text(x?['productName'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),): Text(x?['productName_arabic'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text('Amount:'.tr),
                                                      Text(x?['productAmount']),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Text('${x?['productPrice']}'+'\t'+'EGP'),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text('Quantity:'.tr),
                                                      Text('${x?['productQuantity']}'.tr),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text('price:'.tr,textAlign: TextAlign.center,),

                                                      Text(' ${x?['productPrice']*x?['productQuantity']}',textAlign: TextAlign.center,),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: InkWell(
                                                    onTap: ()async{
                                                        final itemRef=  FirebaseFirestore.instance.collection('carts');
                                                        itemRef.doc(x?['cart_id']).delete();
                                                        SharedPreferences prefs= await SharedPreferences.getInstance();
                                                        prefs.setInt('number',x?['productPrice']*x?['productQuantity'] );
                                                    },
                                                    child: Row(
                                                      mainAxisAlignment:MainAxisAlignment.start,
                                                      children: [
                                                        Icon(Icons.delete_forever, color:Color(0xFFF2C51D)),
                                                Text('delete from cart'.tr,style: TextStyle(color: Color(0xFF9E9E9E)),),

                                                      ],
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),

                                    ],
                                  ),
                                ),
                              ),
                            ),

                          ],
                        );
                      }else{
                        return Center(child: CircularProgressIndicator(),);
                      }
                    },
                      itemCount:snapshot.data?.docs.length ,
                    ),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                   // margin: EdgeInsets.only(top: 20),
                   child: ListView.builder(
                     itemCount:1,
                       itemBuilder: (context,i){
                         QueryDocumentSnapshot?s=snapshot.data?.docs[i];
                         var number=i;
                         return  Container(
                       margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                       child:  Card(
                       child:  Container(
                         height: 100,
                           child: Padding(
                             padding: const EdgeInsets.all(8.0),
                             child: Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Row(
                                   children: [
                                     Text('${(snapshot.data?.docs[number]['productPrice']*snapshot.data?.docs[number]['productQuantity'])} ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                     Text('Amount for orders'.tr,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                   ],
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 ),
                                 // Row(
                                 //
                                 //   children: [
                                 //     Text('${(snapshot.data?.docs[number]['productPrice']*snapshot.data?.docs[number]['productQuantity'])} ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                 //     Text('Amount for orders'.tr,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
                                 //   ],
                                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 // ),
                               ],
                             ),
                           )),
                       ),
                     );
                   }),
                  ),
                ),
                // Text('${snapshot.data?.docs.length}'),
                Container(
                  width:double.infinity,
                    height:80,
                    child: RaisedButton(
                      color: Color(0xFFF2C51D),
                      onPressed:()async{
                      String productsInfo = "";
                      int count = 1;
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      var email= prefs.getString('UserEmail');
                      var id=prefs.getString('UserId');
                      var address= prefs.getString('UserAddress');
                      var phoneNumber= prefs.getString('UserNumber');
                      var userName= prefs.getString('UserName');
                      var createAt=DateTime.now();
                      FirebaseFirestore.instance.collection('Orders').doc(id).set({
                        'product':FieldValue.arrayUnion([{
                         'ProductName':widget.name,
                          'orderId':orderId,
                         'productImage':widget.image,
                          'productQuantity':widget.quantity,
                          'productPrice':widget.price,
                          'totalPrice':'${widget.price*widget.quantity}',
                          'userEmail':email,
                          'userId':id,
                          'ProductName_arabic':widget.name_arabic,
                          'UserAddress':address,
                          'UsherNumber':phoneNumber,
                          'userName':userName,
                          'createdAt':createAt
                        }
                        ])
                      },SetOptions(merge: true));
                       Fluttertoast.showToast(msg: widget.name+'has been orderd',gravity: ToastGravity.BOTTOM);
                      prefs.setString('orderId', orderId);
                     // DateTime time=prefs.setString('createdAt', '${createAt}') as DateTime;
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CheckoutScreen(
                        id: orderId,
                         user_id:'${id}',
                         name_arabic: widget.name_arabic,
                         userAddress:'${address}',
                         userEmail:'${email}',
                         userPhoneNumber:'${phoneNumber}',
                         userName:'${userName}',
                         totalPrice:widget.quantity*widget.price,
                        // product_id: widget.product_id,
                        price:widget.price,
                        // totalPrice: total? ,
                         quantity:widget.quantity,
                         name:widget.name,
                         amount:widget.amount,
                         image:widget.image,
                        createdAt:createAt
                        ,
                       )));
                    },
                      child: Text('Next'.tr,style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),))

                // child: Text('Start order'.tr,style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),))
              ],
            );
          } ,
        ),
      ),
    );
  }
}
