import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/section_screen.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Screens/product_screen.dart'; // Assuming you have this screen

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? myString;
  String _selectedLang = 'en';
  String selectedType = 'جليقية'; // Default to 'جليقية'
  final List<String> types = ['قمارش', 'رندة', 'اتفح', 'لوشيرة', 'جليقية']; // The five types

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
      print("shared:$myString");
    });
  }

  _signOut() async {
    // nav to Login screen
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all shared preferences
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home Page'.tr),
        backgroundColor: Color(0xFFF2C51D),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _signOut, // Calls the sign out method when tapped
          ),
        ],
      ),
      body: Column(
        children: [
          // Row of cards to select the type
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: types.map((type) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedType = type; // Update the selected type ProductScreen
                    });
                  },
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    color: selectedType == type ? Colors.amber : Colors.white,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      child: Text(
                        type,
                        style: TextStyle(
                          fontSize: 18,
                          color: selectedType == type ? Colors.white : Colors.black,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Display categories based on selected type
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(top: 30),
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('Categories')
                    .where('type', isEqualTo: selectedType) // Fetch data based on selected type
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return GridView.builder(
                    itemCount: snapshot.data?.docs.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, i) {
                      QueryDocumentSnapshot? x = snapshot.data?.docs[i];

                      String categoryId = x?['category_id'] ?? '2';
                      String thumbnailUrl = x?['thumbnailUrl'] ?? 'https://via.placeholder.com/150';

                      return InkWell(
                        onTap: () async {
                          SharedPreferences prefs = await SharedPreferences.getInstance();
                          prefs.setString('category_id', categoryId);

                       //   // Navigate to SectionScreen if 'جليقية', else to ProductScreen
                          //                     if (type == 'جليقية')
                          //                       {
                          //                         Navigator.push(
                          //                           context,
                          //                           MaterialPageRoute(
                          //                             builder: (context) => SectionScreen(
                          //                               category_id: '1',
                          //                               type: type,
                          //                             ),
                          //                           ),
                          //                         );
                          //                       }
                          //                     else
                          //                       {
                          //                         Navigator.push(
                          //                           context,
                          //                           MaterialPageRoute(
                          //                             builder: (context) => ProductScreen(
                          //                               subCategory_id: '1',
                          //                               category_id: '1',
                          //                               type: type,
                          //                             ),
                          //                           ),
                          //                         );
                          //                       }
                          if (selectedType == 'جليقية') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SectionScreen(
                                  category_id: categoryId,
                                  type: selectedType,
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductScreen(
                                  subCategory_id: categoryId,
                                  category_id: categoryId,
                                  type: selectedType,
                                ),
                              ),
                            );
                          }
                        },
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          color: Colors.white.withOpacity(.9),
                          child: Container(
                            padding: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Expanded(
                                  child: CachedNetworkImage(
                                    imageUrl: thumbnailUrl,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: 300,
                                    placeholder: (context, url) =>
                                        Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
                                  ),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  '${x?['name'] ?? 'Unknown Name'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
