import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/section_screen.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Screens/product_screen.dart';
import 'package:shqanda_application/Screens/user_profile_screen.dart';

class HomePage extends StatefulWidget {
  final bool isAdminView;

  const HomePage({Key? key, this.isAdminView= false}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String? myString;
  String _selectedLang = 'en';
  String selectedType = 'جليقية';
  final List<String> types = ['قمارش', 'رندة', 'اتفح', 'لوشيرة', 'جليقية'];


  Future<bool> _onWillPop() async {
    return (await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit App'.tr),
        content: Text('?Are you sure you want to exit'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'.tr),
          ),
          TextButton(
            onPressed: () => exit(0),
            child: Text('Yes'.tr),
          ),
        ],
      ),
    )) ?? false;
  }

  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
    });
  }

  _signOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Login()));
  }

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }





  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: widget.isAdminView ? () async {
        Navigator.pop(context);
        return false;
      } : _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('Home Page'.tr),
          backgroundColor: Color(0xFFF2C51D),
          leading: widget.isAdminView
              ? IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          )
              : null,
          actions: widget.isAdminView
              ? []  // Empty list for admin view
              : [  // Normal user actions
            IconButton(
              icon: Icon(Icons.person),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UserProfileScreen()),
                );
              },
            ),
            IconButton(
              icon: Image.asset('assets/sign_out.png', width: 24, height: 24),
              onPressed: _signOut,
            ),
          ],
        ),
        body: Column(
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: types.map((type) {
                  return GestureDetector(
                    onTap: () => setState(() => selectedType = type),
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
            Expanded(
              flex: 3,
              child: Container(
                margin: EdgeInsets.only(top: 30),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('Categories')
                      .where('type', isEqualTo: selectedType)
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
                                  category_id: categoryId,
                                  type: selectedType,
                                ),
                              ),
                            );
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
                                      fit: BoxFit.fill,
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
      ),
    );
  }
}