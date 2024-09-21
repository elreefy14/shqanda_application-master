import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Widgets/product_bottom_sheet.dart';
class ShowCategoryProducts extends StatefulWidget {
  final String id;
  const ShowCategoryProducts({Key? key, required this.id}) : super(key: key);
  @override
  _ShowCategoryProductsState createState() => _ShowCategoryProductsState();
}
class _ShowCategoryProductsState extends State<ShowCategoryProducts> {
   SharedPreferences?  prefs;
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
   void initState() {
     // TODO: implement initState
     super.initState();
     setState(() {
       _loadCounter();
     });
   }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:StreamBuilder (
        stream:FirebaseFirestore.instance.collection('items').where('subCategory_id',isEqualTo: widget.id).snapshots(),
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
                      showModalBottomSheet(
                        context:context,
                        isScrollControlled:true,
                        builder:(context) =>Stack(
                          children:[
                            Container(
                              margin:EdgeInsets.only(top:100),
                              // height: 600,
                              padding:EdgeInsets.only(
                                  bottom:MediaQuery.of(context).viewInsets.bottom),
                              child:SingleChildScrollView(child:ProductBottomSheet(
                                id: x?['product_id'],
                                image: x?['thumbnailUrl'],
                                description_arabic:x?['description_arabic'],
                                longDescription:x?['longDescription'],
                                amount: x?['amount'],
                                title: x?['title'],
                                title_arabic: x?['title_arabic'],
                                shippingDuration:x?['shippingDuration'],
                                status:x?['status'],
                                price:x?['price'],
                                publishedDate: x?['publishedDate'],
                                subCategory_id:x?['subCategory_id'],
                                orderNum:x?['orderNum'],

                              )),
                            ),
                          ],
                        ),
                      );
                    },
                    child:Card(
                      child: Container(
                        child: Column(
                          children: [
                            Image.network(x?['thumbnailUrl'],width: double.infinity,height: 100,),
                            Expanded(child: myString=='en'? Text('${x?['title']}'):Text('${x?['title_arabic']}')),
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
    );
  }
}
