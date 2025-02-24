import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Widgets/product_bottom_sheet.dart';
import 'package:shqanda_application/Services/firebase_service.dart';
import '../auth_service.dart';

class ShowCategoryProducts extends StatefulWidget {
  final String id;
  const ShowCategoryProducts({Key? key, required this.id}) : super(key: key);
  @override
  _ShowCategoryProductsState createState() => _ShowCategoryProductsState();
}

class _ShowCategoryProductsState extends State<ShowCategoryProducts> {
  String? myString;
  String? currentUserId;
  String _selectedLang = 'en';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = await AuthService.getCurrentUserId();
    setState(() {
      myString = prefs.getString('value');
      currentUserId = userId;
    });
  }

  Future<void> _deleteProduct(String productId) async {
    try {
      await FirebaseService.deleteProduct(productId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('تم حذف المحتوى بنجاح')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('items')
            .where('subCategory_id', isEqualTo: widget.id)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return Center(child: Text('لا يوجد محتوى'));
          }

          return GridView.builder(
            itemCount: snapshot.data?.docs.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 6,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, i) {
              QueryDocumentSnapshot x = snapshot.data!.docs[i];
              // Check if current user is the uploader
              bool isUploader =
                  currentUserId != null && x['uploadedBy'] == currentUserId;

              return InkWell(
                onTap: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Stack(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 100),
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                          ),
                          child: SingleChildScrollView(
                            child: ProductBottomSheet(
                              id: x['product_id'],
                              image: x['thumbnailUrl'],
                              description_arabic: x['description_arabic'],
                              longDescription: x['longDescription'],
                              amount: x['amount'],
                              title: x['title'],
                              title_arabic: x['title_arabic'],
                              shippingDuration: x['shippingDuration'],
                              status: x['status'],
                              price: x['price'],
                              publishedDate: x['publishedDate'],
                              subCategory_id: x['subCategory_id'],
                              orderNum: x['orderNum'],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Image.network(
                        x['thumbnailUrl'],
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                myString == 'en'
                                    ? x['title']
                                    : x['title_arabic'] ?? x['title'],
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (x['price'] != null) Text('${x['price']} EGP'),
                              // Only show delete button if user is the uploader
                              if (isUploader)
                                Padding(
                                  padding: const EdgeInsets.only(top: 8.0),
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('تأكيد الحذف'),
                                          content: Text(
                                              'هل أنت متأكد من حذف هذا المحتوى؟'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: Text('إلغاء'),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _deleteProduct(x['product_id']);
                                              },
                                              child: Text('حذف'),
                                              style: TextButton.styleFrom(
                                                primary: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.delete),
                                    label: Text('حذف'),
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.red,
                                      minimumSize: Size(double.infinity, 36),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
