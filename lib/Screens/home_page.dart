import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/section_screen.dart';
import 'package:shqanda_application/Widgets/main_drawer.dart';

class HomePage extends StatefulWidget {

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
        centerTitle: true,
        title: Text('Home Page'.tr),
        backgroundColor: Color(0xFFF2C51D),
      ),
      drawer: MainDrawer(),
      body: Column(
        children: [

     Expanded(
       child: Stack(
         children: [
           Container(
             margin: EdgeInsets.only(top: 50,right: 20,left: 170),
             width: 200,
             height: 50,
             child:InkWell(
                 onTap: ()async{
                 //   SharedPreferences prefs=await SharedPreferences.getInstance();
                 // var id= prefs.getString('category_id',);
                       Navigator.push(context,MaterialPageRoute(builder:(context)=>SectionScreen(category_id:'1636446021236'
                           )));
                 },
                 child: Center(child: Text('luchra'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),))),
             decoration:BoxDecoration(
                 color:Color(0xFF9E9E9E),
                 borderRadius:BorderRadius.circular(15)
             ),
           ),
           Container(
             margin:EdgeInsets.only(top:50,right:170,left: 20),
             width:200,
             height:50,
             child:InkWell(
               onTap: (){
                 //    Navigator.push(context,MaterialPageRoute(builder:(context)=>AdminLoginScreen()));
               },
               child: Center(
                   child:Text('Shqanda'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),)),
             ),
             decoration:BoxDecoration(
                 color:Color(0xFFF2C51D),
                 borderRadius: BorderRadius.circular(15)
             ),
           ),
         ],
       ),
     ),
          Expanded(
            flex: 3,
            child: Container(
            margin: EdgeInsets.only(top: 30),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
                builder: (
                    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return GridView.builder(
                    //itemCount: 2,
                      itemCount: snapshot.data?.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 10),
                      itemBuilder:(context,i){
                        QueryDocumentSnapshot? x=snapshot.data?.docs[i];
                        if(snapshot.hasData){
                          return InkWell(
                            onTap: ()async{
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SectionScreen(
                                category_id: x?['category_id'],

                              )));
                              SharedPreferences prefs=await SharedPreferences.getInstance();
                              prefs.setString('category_id', x?['category_id']);
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
                                    //https://firebasestorage.googleapis.com/v0/b/idyllic-folio-238500.appspot.com/o/lunch%20scene.0-01-01-01-01-01-01-01-01-01.jpg?alt=media&token=396ad5ec-26e8-40d8-a437-53968fcc8967
                                    Expanded(child: Image.network(x?['thumbnailUrl'],fit: BoxFit.cover,height: 300,)),
                                    Expanded(child: myString=='en'? Text('${x?['name']}',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',),):Text('${x?['name']}',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',),))
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
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*.75),
                child: Image.asset('assets/group1.jpg',height: 400,)),
          ),

        ],
      ),
    );
  }
}
