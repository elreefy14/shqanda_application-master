import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/upload_item_screen.dart';
import 'package:shqanda_application/Widgets/sub_category_bottom_sheet.dart';

class ShowSubCategories extends StatefulWidget {
  final String id;
  const ShowSubCategories({Key? key, required this.id}) : super(key: key);

  @override
  _ShowSubCategoriesState createState() => _ShowSubCategoriesState();
}

class _ShowSubCategoriesState extends State<ShowSubCategories> {
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
        title: Text('Sub Categories'),
        backgroundColor: Color(0xFFF2C51D),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 30),
        child: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('subCategories').where('category_id' ,isEqualTo: widget.id).snapshots(),
          builder: (
              BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
                itemCount: snapshot.data?.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 10),
                itemBuilder:(context,i){
                  QueryDocumentSnapshot? x=snapshot.data?.docs[i];
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
                                child:SingleChildScrollView(child:SubCategoryBottomSheet(
                                  category_id: widget.id,
                                  id: x?['subCategory-id'],
                                  title_arabic: x?['title_arabic'],
                                  title: x?['title'],
                                  image: x?['thumbnailUrl'],
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
                              Image.network(x?['thumbnailUrl'],width: double.infinity,fit: BoxFit.cover,height: 100,),
                              Expanded(child:myString=='en' ?Text('${x?['title']}'):Text('${x?['title_arabic']}')),
                              Expanded(child: Container(
                                width: double.infinity,
                                child: RaisedButton(
                                 color: Color(0xFFF2C51D),
                                  onPressed: (){
                                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadItemScreen(
                                      subCategory_id:x?['subCategory-id'] ,
                                      categoryId: widget.id,
                                    )));
                                  },
                                  child: Text('Add product'.tr,style: TextStyle(color: Colors.white),),
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
