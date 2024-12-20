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
  String? myString;
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
    super.initState();
    _loadCounter();
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
          stream: FirebaseFirestore.instance.collection('Categories').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return GridView.builder(
                itemCount: snapshot.data?.docs.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, crossAxisSpacing: 6, mainAxisSpacing: 10),
                itemBuilder: (context, i) {
                  QueryDocumentSnapshot? x = snapshot.data?.docs[i];
                  if (snapshot.hasData) {
                    return InkWell(
                      onTap: () {
                      //  if (x?['type'] == 'goliqa') {
                        if (true) {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Stack(
                              children: [
                                Container(
                                  margin: EdgeInsets.only(top: 100),
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context).viewInsets.bottom),
                                  child: SingleChildScrollView(
                                      child: UpdateCategory(
                                        id: x?['category_id'],
                                        image: x?['thumbnailUrl'],
                                        title: x?['title']??x?['name'],
                                        title_arabic: x?['title_arabic']??x?['name'],
                                      )),
                                ),
                              ],
                            ),
                          );
                        } else {
                          // Show snackbar indicating no subcategories in Arabic
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'لا توجد فئات فرعية لهذا العنصر'.tr, // Arabic for "This item has no subcategories"
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                            ),
                          );
                        }
                      },
                      child: Card(
                        child: Container(
                          child: Column(
                            children: [
                              ClipRRect(
                                  child: Image.network(
                                    x?['thumbnailUrl'],
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    height: 90,
                                  )),
                              Expanded(
                                  child: myString == 'en'
                                      ? Text('${x?['title']}')
                                      : Text('${x?['title_arabic']}')),
                              Expanded(
                                child: Container(
                                  width: double.infinity,
                                  child: RaisedButton(
                                    color: Color(0xFFF2C51D),
                                    onPressed: () {
                                      if (x?['isSubCat'] == true) {
                                        // Subcategory - Add Products
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UploadItemScreen(
                                              categoryId: x?['category_id'], // renamed to 'categoryId'
                                              subCategory_id: null, // renamed to 'subCategory_id'
                                            ),
                                          ),
                                        );
                                      } else {
                                        // Main Category - Add SubCategory
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => CategorySections(
                                              category_id: x?['category_id'],
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text(
                                      x?['isSubCat'] == true
                                          ? 'Add Products'.tr
                                          : 'Add SubCategory'.tr,
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                });
          },
        ),
      ),
    );
  }
}
