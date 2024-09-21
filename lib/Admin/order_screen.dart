import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
class OrderScreen extends StatefulWidget {
  final String id;
  const OrderScreen({Key? key, required this.id}) : super(key: key);
  @override
  _OrderScreenState createState() => _OrderScreenState();
}
class _OrderScreenState extends State<OrderScreen> {
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
  FirebaseAuth auth=FirebaseAuth.instance;
  String orderId=DateTime.now().millisecondsSinceEpoch.toString();
  Future getUsers() async {

    var data = (await FirebaseFirestore.instance.collection('Orders').doc(widget.id).get()).data();
    return data;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        centerTitle: true,
        title: Text('Order Screen'),
        backgroundColor: Color(0xFFF2C51D),
      ),
      body: FutureBuilder(
        future:getUsers(),
        builder: ( BuildContext context,AsyncSnapshot snapshot){
          return ListView.builder(
              itemCount: snapshot.data['product'].length,
              itemBuilder: (context,i){
            return Card(
              child: Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text('User Name:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                        Text('${snapshot.data['product'][i]['userName']}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(

                      children: [
                        Text('User Address:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                        Text('${snapshot.data['product'][i]['UserAddress']}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(

                      children: [
                        Text('Phone Number:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                        Text('${snapshot.data['product'][i]['UsherNumber']}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(

                      children: [
                        Text('User Email:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                        Text('${snapshot.data['product'][i]['userEmail']}'),
                      ],
                    ),
                  ),
                  Image.network('${snapshot.data['product'][i]['productImage']}'),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(

                      children: [
                        Text('product name:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18),),
                        myString=='en' ? Text('${snapshot.data['product'][i]['ProductName']}'):Text('${snapshot.data['product'][i]['ProductName_arabic']}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(

                      children: [
                        Text('Product Price:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                        Text('${snapshot.data['product'][i]['productPrice'].toStringAsFixed(2) } EGP'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text('Quantity:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                        Text('${snapshot.data['product'][i]['productQuantity']}'),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Row(
                      children: [
                        Text('Total Price:'.tr+'\t',style: TextStyle(color: Color(0xFFF2C51D),fontWeight: FontWeight.bold,fontSize: 18)),
                        Text('${(snapshot.data['product'][i]['productQuantity'] *snapshot.data['product'][i]['productPrice']).toStringAsFixed(2)} EGP'),
                      ],
                    ),
                  )

                ],
              ),
            );
          });
        },
      ),
    );
  }
}
