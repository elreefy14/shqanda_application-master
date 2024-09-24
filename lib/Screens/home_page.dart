import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/section_screen.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? myString;
  String _selectedLang = 'en';
  bool useCategories2 = false; // Track whether to use 'Categories2'
  bool isLuchraSelected = false; // Track which container is selected

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
      print("shared:$myString");
    });
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
      ),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                // Luchra Container
                Container(
                  margin: EdgeInsets.only(top: 50, right: 20, left: 170),
                  width: 200,
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        useCategories2 = true;
                        isLuchraSelected = true; // Mark luchra as selected
                      });
                    },
                    child: Center(
                      child: Text(
                        'luchra'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Noto Sans Arabic ExtraCondensed',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: isLuchraSelected ? Color(0xFFF2C51D) : Color(0xFF9E9E9E), // Toggle color based on selection
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                // Shqanda Container
                Container(
                  margin: EdgeInsets.only(top: 50, right: 170, left: 20),
                  width: 200,
                  height: 50,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        useCategories2 = false;
                        isLuchraSelected = false; // Mark Shqanda as selected
                      });
                    },
                    child: Center(
                      child: Text(
                        'Shqanda'.tr,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Noto Sans Arabic ExtraCondensed',
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: isLuchraSelected ? Color(0xFF9E9E9E) : Color(0xFFF2C51D), // Toggle color based on selection
                    borderRadius: BorderRadius.circular(15),
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
                stream: FirebaseFirestore.instance
                    .collection(useCategories2 ? 'Categories' : 'Categories')
                    .where('type', isEqualTo: useCategories2 ? 'luchra' : 'goliqa')
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SectionScreen(
                                category_id: x?['category_id'],
                                type:  x?['category_id'],
                              ),
                            ),
                          );
                        },
                        child: Card(
                          color: Colors.white.withOpacity(.9),
                          shape: OutlineInputBorder(
                            borderRadius: BorderRadius.only(
                              bottomLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                            ),
                            borderSide: BorderSide.none,
                          ),
                          child: Container(
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
                                SizedBox(height: 20),
                                myString == 'en'
                                    ? Text(
                                  '${x?['name'] ?? 'Unknown Name'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Noto Sans Arabic ExtraCondensed',
                                  ),
                                )
                                    : Text(
                                  '${x?['name'] ?? 'Unknown Name'}',
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Noto Sans Arabic ExtraCondensed',
                                  ),
                                ),
                                SizedBox(height: 20),
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
          Expanded(
            flex: 3,
            child: Container(
              margin: EdgeInsets.only(left: MediaQuery.of(context).size.width * .75),
              child: Image.asset(
                'assets/group1.jpg',
                height: 400,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
