import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/payment_screen.dart';

class CheckoutScreen extends StatefulWidget {
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
  const CheckoutScreen({Key? key,required this.id,required this.createdAt, required this.name,required this.name_arabic, required this.image, required this.totalPrice, required this.user_id, required this.amount, required this.price, required this.quantity,required this.userName,required this.userAddress,required this.userPhoneNumber,required this.userEmail}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String ?myString;
  String _selectedLang = 'en';
  bool _isVisible = true;
 // Visibility _visibility=true as Visibility;

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
      getUsers();
    });
  }
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
        title: Text('Checkout'.tr),
        centerTitle: true,
        backgroundColor:Color(0xFFF2C51D),
      ),
      body: Column(
        children: [
         Container(
            margin: EdgeInsets.only(left: 20,right: 20,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text('Current Address'.tr,style: TextStyle(color: Color(0xFF9E9E9E),fontWeight: FontWeight.bold,fontSize: 17),),
                  ],
                ),
                Row(
                  children: [
                    Text('${widget.userAddress}'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    InkWell(
                      onTap: (){
                        showDialog(
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                                elevation: 16,
                                child: Container(
                                  height: 300.0,
                                  width: 360.0,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: TextFormField(

                                          controller: TextEditingController(
                                            text: widget.userAddress,
                                          ),
                                          decoration: InputDecoration(
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.circular(20)
                                            )
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: TextFormField(
                                          controller: TextEditingController(
                                              text: widget.userPhoneNumber
                                          ),
                                          decoration: InputDecoration(
                                              border: OutlineInputBorder(
                                                  borderRadius: BorderRadius.circular(20)
                                              )
                                          ),
                                        ),
                                      ),
                                      RaisedButton(
                                          color: Color(0xFFF2C51D),
                                          shape: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(15)
                                          ),
                                          child: Text('Edit'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 18),),
                                          onPressed: (){
                                          FirebaseFirestore.instance.collection('User').doc(widget.user_id)
                                              .update({
                                            'UserAddress':widget.userAddress,
                                            'UserNumber':widget.userPhoneNumber
                                          });
                                          Fluttertoast.showToast(msg: 'Data updated successfully',gravity: ToastGravity.CENTER);
                                          }
                                      )
                                    ],
                                  ),
                                ),
                              );

                        }, context: context
                          
                        );
                      },
                        child: Icon(Icons.edit_outlined))
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  children: [
                    Text('Current Phone'.tr,style: TextStyle(color: Color(0xFF9E9E9E),fontWeight: FontWeight.bold,fontSize: 17),),
                  ],
                ),
                Row(
                  children: [
                    Text('${widget.userPhoneNumber}'),
                  ],
                ),

              ],
            ),
          ),
          Divider(
            thickness: 1,
          ),
          Expanded(
            flex: 5,
            child: Container(
              margin:EdgeInsets.only(top: 30),
              child: FutureBuilder(
                future: getUsers(),
                  builder: ( context,AsyncSnapshot snapshot){
                    return Column(
                      children:[
                        Expanded(
                          flex: 8,
                          child:Container(
                            child:ListView.builder(itemBuilder:(context,index){
                             // QueryDocumentSnapshot?x=snapshot.data?.docs[];
                              if(snapshot.hasData){
                                return Container(
                                  margin:EdgeInsets.only(left: 20,right: 20),
                                  child:Container(
                                    child:Card(
                                      shape: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(15)
                                      ),
                                      child: Container(
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Expanded(child: Image.network(snapshot.data?['product'][index]['productImage'],width: double.infinity,height: 100,)),
                                              ],
                                              mainAxisAlignment: MainAxisAlignment.start,
                                            ),
                                            Column(
                                              mainAxisAlignment:MainAxisAlignment.start,
                                              children:[
                                                // myString=='en'?
                                                // Text(snapshot.data?['product'][index]['productName'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),): Text(snapshot.data?['product'][index]['productName_arabic'],style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),),
                                                // Padding(
                                                //   padding: const EdgeInsets.all(8.0),
                                                //   child: Text(snapshot.data?['product'][index]['productAmount']),
                                                // ),
                                                 myString=='en'?
                                                  Text('${snapshot.data?['product'][index]['ProductName']}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),): Text('${snapshot.data?['product'][index]['ProductName_arabic']}',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child:Text('${snapshot.data?['product'][index]['productPrice']}'+'\t'+'EGP'),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text('Quantity:'.tr),
                                                      Text(' ${snapshot.data?['product'][index]['productQuantity']}'.tr),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ),
                                                ),
                                                Padding(
                                                  padding: const EdgeInsets.all(8.0),
                                                  child: Row(
                                                    children: [
                                                      Text('price:'.tr,textAlign: TextAlign.center,),
                                                      Text('${snapshot.data?['product'][index]['productPrice']*snapshot.data?['product'][index]['productQuantity']}',textAlign: TextAlign.center,),
                                                    ],
                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                  ),
                                                ),
                                                widget.createdAt.subtract(Duration(minutes: 10))==true?
                                                Visibility(
                                                  visible: false,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: InkWell(
                                                      onTap: ()async{
                                                        final itemRef=  FirebaseFirestore.instance.collection('Orders');
                                                        itemRef.doc(snapshot.data?['product'][index]['userId']).delete();
                                                        Fluttertoast.showToast(msg: 'Order has been deleted from order list',gravity: ToastGravity.CENTER);
                                                        SharedPreferences prefs= await SharedPreferences.getInstance();
                                                        prefs.setInt('number',snapshot.data?['product'][index]?['productPrice']*snapshot.data?['product'][index]['productQuantity'] );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:MainAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                              Icons.delete_forever, color:Color(0xFFF2C51D)),
                                                          Text('delete from cart'.tr,style: TextStyle(color: Color(0xFF9E9E9E)),),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                ):   Visibility(
                                                  visible: true,
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: InkWell(
                                                      onTap: ()async{
                                                        final itemRef=  FirebaseFirestore.instance.collection('Orders');
                                                        itemRef.doc(snapshot.data?['product'][index]['userId']).delete();
                                                        Fluttertoast.showToast(msg: 'Order has been deleted from order list',gravity: ToastGravity.CENTER);
                                                        SharedPreferences prefs= await SharedPreferences.getInstance();
                                                        prefs.setInt('number',snapshot.data?['product'][index]?['productPrice']*snapshot.data?['product'][index]['productQuantity'] );
                                                      },
                                                      child: Row(
                                                        mainAxisAlignment:MainAxisAlignment.start,
                                                        children: [
                                                          Icon(
                                                              Icons.delete_forever, color:Color(0xFFF2C51D)),
                                                          Text('delete from cart'.tr,style: TextStyle(color: Color(0xFF9E9E9E)),),

                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }else{
                                return Center(child: CircularProgressIndicator(),);
                              }
                            },
                              itemCount:snapshot.data?['product'].length ,
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
                                 // QueryDocumentSnapshot?s=snapshot.data?.docs[i];
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
                                                    Text('${(snapshot.data?['product'][number]['productPrice']*snapshot.data?['product'][number]['productQuantity'])} ',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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
                        // Container(
                        //     width:double.infinity,
                        //     height:80,
                        //     child: RaisedButton(
                        //       color: Color(0xFFF2C51D),
                        //       onPressed:()async{
                        //         String productsInfo = "";
                        //         int count = 1;
                        //         SharedPreferences prefs = await SharedPreferences.getInstance();
                        //         var email= prefs.getString('UserEmail');
                        //         var id=prefs.getString('UserId');
                        //         var address= prefs.getString('UserAddress');
                        //         var phoneNumber= prefs.getString('UserNumber');
                        //         var userName= prefs.getString('UserName');
                        //         var createAt=DateTime.now();
                        //         FirebaseFirestore.instance.collection('Orders').doc(id).set({
                        //           'product':FieldValue.arrayUnion([{
                        //             'ProductName':widget.name,
                        //             'orderId':orderId,
                        //             'productImage':widget.image,
                        //             'productQuantity':widget.quantity,
                        //             'productPrice':widget.price,
                        //             'totalPrice':'${widget.price*widget.quantity}',
                        //             'userEmail':email,
                        //             'userId':id,
                        //             'ProductName_arabic':widget.name_arabic,
                        //             'UserAddress':address,
                        //             'UsherNumber':phoneNumber,
                        //             'userName':userName,
                        //             'createdAt':createAt
                        //
                        //           }
                        //           ])
                        //         },SetOptions(merge: true));
                        //         Fluttertoast.showToast(msg: widget.name+'has been orderd',gravity: ToastGravity.BOTTOM);
                        //         prefs.setString('orderId', orderId);
                        //         // DateTime time=prefs.setString('createdAt', '${createAt}') as DateTime;
                        //         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>OrderDetails(
                        //           id: orderId,
                        //           user_id:'${id}',
                        //           name_arabic: widget.name_arabic,
                        //           userAddress:'${address}',
                        //           userEmail:'${email}',
                        //           userPhoneNumber:'${phoneNumber}',
                        //           userName:'${userName}',
                        //           totalPrice:widget.quantity*widget.price,
                        //           // product_id: widget.product_id,
                        //           price:widget.price,
                        //           // totalPrice: total? ,
                        //           quantity:widget.quantity,
                        //           name:widget.name,
                        //           amount:widget.amount,
                        //           image:widget.image,
                        //           createdAt:createAt
                        //           ,
                        //         )));
                        //       },
                        //       child: Text('Next'.tr,style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),))

                        // child: Text('Start order'.tr,style: TextStyle(color:Colors.white,fontSize: 18,fontWeight: FontWeight.bold),),))
                      ],
                    );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
