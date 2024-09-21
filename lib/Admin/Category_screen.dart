import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/category_secctions.dart';
import 'upload_item_screen.dart';
import 'package:shqanda_application/Widgets/bottom_sheet.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
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
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        title: Text('Categories'.tr),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: StreamBuilder(
          stream:FirebaseFirestore.instance.collection('categories').snapshots(),
          builder: (
              BuildContext context,AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
                itemCount: snapshot.data?.docs.length,
                gridDelegate:SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 10),
                itemBuilder:(context,i){
                  QueryDocumentSnapshot?x=snapshot.data?.docs[i];
                  if(snapshot.hasData){
                    return InkWell(
                       onTap:(){
                         showModalBottomSheet(
                           context:context,
                           isScrollControlled:true,
                           builder:(context) =>Stack(
                             children:[
                               Container(
                                 margin:EdgeInsets.only(top:100),
                                 // height: 600,
                                 padding:EdgeInsets.only(
                                     bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child:SingleChildScrollView(child:UpdateCategory(
                                    id: x?['category_id'],
                                    image: x?['thumbnailUrl'],
                                    title: x?['title'],
                                    title_arabic: x?['title_arabic'],
                                  )),
                               ),

                             ],
                           ),
                         );
                       },
                      child: Card(
                        child: Container(
                          child: Column(
                            children: [
                              ClipRRect(
                                // borderRadius: BorderRadius.circular(20),
                                  child: Image.network(x?['thumbnailUrl'],width: double.infinity,fit: BoxFit.cover,height: 90,)),
                              Expanded(child: myString=='en'?
                              Text('${x?['title']}'):Text('${x?['title_arabic']}')),
                              Expanded(child: Container(

                                width: double.infinity,
                                child: RaisedButton(
                                  color: Color(0xFFF2C51D),
                                  // shape: OutlineInputBorder(
                                  //   borderRadius: BorderRadius.circular(20),
                                  //   borderSide: BorderSide.none
                                  // ),
                                  onPressed: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (context)=>CategorySections(
                                      category_id:x?['category_id'] ,
                                    )));

                                  },
                                  child: Text('Add SubCategory'.tr,style: TextStyle(color: Colors.white),),
                                ),
                              ))
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
