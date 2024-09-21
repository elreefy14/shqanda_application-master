import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/section_screen.dart';
import 'package:shqanda_application/Widgets/main_drawer.dart';
class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
    return Directionality(
      textDirection: myString=='en'?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Home Page'.tr),
          backgroundColor: Colors.deepOrange,
        ),
        drawer: MainDrawer(),
        body: Container(
          margin: EdgeInsets.only(top: 30),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
            builder: (
              BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              return GridView.builder(
                  itemCount: snapshot.data?.docs.length,
                 // itemCount: 2,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 1,crossAxisSpacing: 6,mainAxisSpacing: 10),
                  itemBuilder:(context,i){
                    QueryDocumentSnapshot? x=snapshot.data?.docs[i];
                    if(snapshot.hasData){
                      return InkWell(
                        onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>SectionScreen(
                          category_id: x?['category_id'],
                      )));
                        },
                        child: Card(
                          color: Colors.white.withOpacity(.9),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.only(bottomLeft: Radius.circular(15),bottomRight:  Radius.circular(15)),
                            borderSide: BorderSide.none
                          ),
                          child: Container(
                            child: Column(
                              children: [
                                Image.network(x?['thumbnailUrl'],fit: BoxFit.cover,height: 300,),
                                Expanded(child: myString=='en'? Text('${x?['name']}',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),):Text('${x?['name']}',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),))
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
      ),
    );
  }
}
