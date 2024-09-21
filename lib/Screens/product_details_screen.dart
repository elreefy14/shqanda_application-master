import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Provider/product_provider.dart';
import 'package:shqanda_application/Screens/cart_screen.dart';
import 'package:shqanda_application/Screens/checkout_screen.dart';
class ProductDetailsScreen extends StatefulWidget {
  final String product_id;
  final String product_description;
  final String description_arabic;
  final String amount;
  final String shipping_duration;
  final String title;
  final String title_arabic;
  final String image;
  final int orderNumber;
  final int price;
  const ProductDetailsScreen({Key? key, required this.product_id,required this.image,required this.title,required this.amount,required this.orderNumber,required this.price,required this.product_description,required this.shipping_duration,required this.title_arabic, required this.description_arabic}) : super(key: key);
  @override
  _ProductDetailsScreenState createState() => _ProductDetailsScreenState();
}
class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
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
  void initState(){
    // TODO: implement initState
    super.initState();
    setState(() {
      _loadCounter();
    });
  }
  String productId=DateTime.now().millisecondsSinceEpoch.toString();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  ProductProvider? productProvider;
  int count = 1;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myString=='en'?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFFF2C51D),
          title: Text('Details'.tr),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Column(
            children:[
              Container(
                margin: EdgeInsets.all(16),
                width: double.infinity,
                child: Card(
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(15)
                  ),
                    child:Image.network(widget.image)),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    myString=='en'?
                    Text('${widget.title}' +'\t'+'-'):  Text('${widget.title_arabic}' +'\t'+'-'),
                    SizedBox(width: 10,),
                    Text('${widget.amount}'.tr)
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text('${widget.price}'+'EGP',style: TextStyle(color: Color(0xFFF2C51D),fontSize: 16),),
                  ],
                ),
              ),
              ListTile(
                title: Text('Description'.tr,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),

                subtitle: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:myString=='en' ?Text('${widget.product_description}'):Text('${widget.description_arabic}'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child:Row(
                  children:[
                    Text('Quantity'.tr,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Row(
                  children:[
                    Container(
                      height:40,
                      width:130,
                      decoration:BoxDecoration(
                      border:Border.all(color: Color(0xFFF2C51D)),
                        borderRadius:BorderRadius.circular(15)
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            child:Icon(
                              Icons.remove,
                              color: Color(0xFFF2C51D),
                            ),
                            onTap: () {
                              setState(() {
                                if (count > 1) {
                                  count--;
                                }
                              });
                            },
                          ),
                          Text(
                            count.toString(),
                            style: TextStyle(fontSize: 18, color: Color(0xFFF2C51D)),
                          ),
                          GestureDetector(
                            child: Icon(
                              Icons.add,
                              color: Color(0xFFF2C51D),
                            ),
                            onTap: () {
                              setState(() {
                                count++;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   children: [
                    //     Icon(Icons.star,color: Colors.yellow,),
                    //     Icon(Icons.star,color: Colors.yellow,),
                    //     Icon(Icons.star,color: Colors.yellow,),
                    //     Icon(Icons.star,color: Colors.yellow,),
                    //     Icon(Icons.star,color: Colors.yellow,),
                    //   ],
                    // ),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //   children: [
                    //     Icon(Icons.share),
                    //     Icon(Icons.favorite_border,color: Colors.red,)
                    //   ],
                    // )
                  ],
                ),
              ),
              Container(
                color: Colors.deepOrange,
                margin: EdgeInsets.only(left: 20,right: 20,top: 6),
                height: 50,
                child: RaisedButton(
                  color:Color(0xFFF2C51D),
                  onPressed: ()async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  var id= prefs.get('UserId');
                  final itemRef=FirebaseFirestore.instance.collection('carts');
                  itemRef.doc(productId).set({
                      'cart_id':productId,
                      'productName':widget.title,
                       'productName_arabic':widget.title_arabic,
                      'productImage':widget.image,
                      'productAmount':widget.amount,
                      'productPrice':widget.price,
                      'ProductId':widget.product_id,
                      'productQuantity':count,
                      'UserId':'${id}',
                  }).then((value) {
                   Fluttertoast.showToast(msg: 'Item added to cart');
                  });
                  prefs.setString('ProductId', widget.product_id);
                  prefs.setString('productAmount', widget.amount);
                  prefs.setString('ProductName', widget.title);
                  prefs.setString('productImage', widget.image);
                  prefs.setInt('productQuantity',count);
                  prefs.setInt('productPrice', widget.price);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder:(ctx)=>CartScreen(
                        name_arabic: widget.title_arabic,
                        name:widget.title,
                        image:widget.image,
                        amount:widget.amount,
                        quantity:count,
                        price:widget.price,
                        product_id:widget.product_id,
                        user_id:'${id}',
                      ),
                    ),
                  );
                },

                  child:Row(
                  mainAxisAlignment:MainAxisAlignment.center,
                  children:[
                    Icon(Icons.add_shopping_cart_outlined,color: Colors.white,),
                    SizedBox(width:15,),
                    Text('ADD TO CART'.tr,style: TextStyle(color: Colors.white,),),
                  ],
                ),
                ),
              )
            ],
          ),
        ),
        // body:StreamBuilder (
        //   // stream:FirebaseFirestore.instance.collection('items').where('subCategory_id',isEqualTo: widget.subCategory_id).snapshots(),
        //   stream:FirebaseFirestore.instance.collection('items').where('product_id',isEqualTo: widget.product_id).snapshots(),
        //   builder: (
        //       BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
        //     return GridView.builder(
        //         itemCount: snapshot.data?.docs.length,
        //         gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 10),
        //         itemBuilder:(context,i){
        //           QueryDocumentSnapshot?x=snapshot.data?.docs[i];
        //           if(snapshot.hasData){
        //             return Card(
        //               shape: OutlineInputBorder(
        //                   borderRadius: BorderRadius.circular(20),
        //                   borderSide: BorderSide.none
        //               ),
        //               child: Container(
        //                 child: Column(
        //                   children: [
        //                     Image.network(x?['thumbnailUrl'],width: double.infinity,height: 100,),
        //                     Expanded(child: Text('${x?['title']}')),
        //                     Expanded(child: Text('${x?['price']}'+'EGP')),
        //                     // Expanded(child: RaisedButton(
        //                     //   onPressed: (){
        //                     //     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadItemScreen(
        //                     //       category_id:x?['category_id'] ,
        //                     //     )));
        //                     //
        //                     //   },
        //                     //   child: Text('Add product'),
        //                     // ))
        //                   ],
        //                 ),
        //               ),
        //             );
        //           }
        //           else{
        //             return Center(child: CircularProgressIndicator());
        //           }
        //         });
        //   },
        // ),
      ),
    );
  }
}
