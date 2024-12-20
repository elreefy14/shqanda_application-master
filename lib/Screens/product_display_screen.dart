import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class ProductDisplayScreen extends StatefulWidget {
  final String sectionName;
  final String categoryId;

  const ProductDisplayScreen({
    Key? key,
    required this.sectionName,
    required this.categoryId
  }) : super(key: key);

  @override
  _ProductDisplayScreenState createState() => _ProductDisplayScreenState();
}

class _ProductDisplayScreenState extends State<ProductDisplayScreen> {
  Future<void> _createOrder(Map<String, dynamic> productData) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('userId');
      String orderId = DateTime.now().millisecondsSinceEpoch.toString();

      String? userPhone = prefs.getString('phoneNumber');
      String? userName = prefs.getString('userName');
      String? userAddress = prefs.getString('userAddress');

      await FirebaseFirestore.instance.collection('orders').doc(orderId).set({
        'orderId': orderId,
        'userId': userId,
        'userName': userName,
        'userPhone': userPhone,
        'userAddress': userAddress,
        'productId': productData['product_id'],
        'productName': productData['name'],
        'productPrice': productData['price'],
        'sectionName': widget.sectionName,
        'orderStatus': 'pending',
        'createdAt': FieldValue.serverTimestamp(),
      });

      String message = '''
        New Order:
        Product: ${productData['name']}
        Price: ${productData['price']}
        Section: ${widget.sectionName}
        Customer: $userName
        Address: $userAddress
        Phone: $userPhone
      ''';

      String whatsappUrl = "whatsapp://send?phone=+201093581482&text=${Uri.encodeFull(message)}";
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      print('Error creating order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating order. Please try again.'))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.sectionName} - Products'.tr),
        backgroundColor: Color(0xFFF2C51D),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('products')
            .doc(widget.sectionName)
            .collection('items')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          return GridView.builder(
            padding: EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 0.75,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
            ),
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var product = snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return Card(
                elevation: 3,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                          image: DecorationImage(
                            image: NetworkImage(product['picture'] ?? ''),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['name'] ?? '',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              product['description'] ?? '',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              '${product['price']} EGP',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFF2C51D),
                              ),
                            ),
                            SizedBox(height: 8),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () => _createOrder(product),
                                child: Text('Buy Now'.tr),
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFFF2C51D),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}