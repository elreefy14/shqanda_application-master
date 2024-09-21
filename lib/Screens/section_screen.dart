import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/product_screen.dart';

class SectionScreen extends StatefulWidget {
  final String category_id;

  const SectionScreen({Key? key, required this.category_id}) : super(key: key);
  @override
  _SectionScreenState createState() => _SectionScreenState();
}
class _SectionScreenState extends State<SectionScreen> {
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
        title:  Text(''),
        backgroundColor: Color(0xFFF2C51D),
      ),
      body: Column(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance.collection('Categories').doc('${widget.category_id}').collection('sections').snapshots(),
                builder: (
                    BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return GridView.builder(
                      itemCount: snapshot.data?.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 6,mainAxisSpacing: 10),
                      itemBuilder:(context,i){
                        QueryDocumentSnapshot? x=snapshot.data?.docs[i];
                        if(snapshot.hasData){
                          return InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductScreen(
                                subCategory_id: x?['subCategory-id'],
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
                                  children:[
                                    Image.network(x?['picture'],width: double.infinity,fit: BoxFit.cover),
                                    Expanded(child: myString=='en'? Text('${x?['name']}',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),):Text('${x?['name']}',style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),)),
                                    Expanded(child: Container(
                                      width: double.infinity,
                                      // child: RaisedButton(
                                      //   color: Colors.deepOrange,
                                      //   // onPressed: (){
                                      //   //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>UploadItemScreen(
                                      //   //     subCategory_id:x?['subCategory-id'] ,
                                      //   //     categoryId: widget.id,
                                      //   //   )));
                                      //   // },
                                      //   child: Text('Add product',style: TextStyle(color: Colors.white),),
                                      // ),
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
          ),
          Expanded(
            flex: 2,
            child: Container(
                margin: EdgeInsets.only(left: MediaQuery.of(context).size.width*.75),
                child: Image.asset('assets/group2.jpg',height: 400,)),
          ),
        ],
      ),
    );
  }
}
