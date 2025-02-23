import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../Widgets/delete_product_button.dart';

class ProductDisplayScreen extends StatefulWidget {
  final String sectionName;
  final String categoryId;
  final String? subCategory_id;

  const ProductDisplayScreen({
    Key? key,
    required this.sectionName,
    required this.categoryId,
    this.subCategory_id,
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

      String whatsappUrl =
          "whatsapp://send?phone=+201093581482&text=${Uri.encodeFull(message)}";
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      print('Error creating order: $e');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating order. Please try again.')));
    }
  }

  Widget _buildContentItem(Map<String, dynamic> product) {
    String contentType = product['contentType'] ?? 'physical';

    if (contentType == 'video') {
      String videoId = YoutubePlayer.convertUrlToId(product['picture']) ?? '';
      return _buildVideoItem(product, videoId);
    } else if (contentType == 'image') {
      return _buildImageItem(product);
    } else {
      return _buildPhysicalItem(product);
    }
  }

  Widget _buildVideoItem(Map<String, dynamic> product, String videoId) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: YoutubePlayer(
              controller: YoutubePlayerController(
                initialVideoId: videoId,
                flags: YoutubePlayerFlags(
                  autoPlay: false,
                  mute: false,
                ),
              ),
              showVideoProgressIndicator: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  product['description'] ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (product['iFleetLink'] != null) ...[
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => launch(product['iFleetLink']),
                    child: Text('View on iFleet'.tr),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF2C51D),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImageItem(Map<String, dynamic> product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
            child: Image.network(
              product['picture'] ?? '',
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  product['description'] ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                if (product['iFleetLink'] != null) ...[
                  SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => launch(product['iFleetLink']),
                    child: Text('View on iFleet'.tr),
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFFF2C51D),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhysicalItem(Map<String, dynamic> product) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (product['picture'] != null && product['picture'].isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
              child: Image.network(
                product['picture'],
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product['name'] ?? '',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
                SizedBox(height: 4),
                Text(
                  product['description'] ?? '',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                SizedBox(height: 4),
                Text(
                  '${product['price']} ${product['currency'] ?? 'EGP'}',
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
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.sectionName} - Products'.tr),
        backgroundColor: Color(0xFFF2C51D),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: widget.subCategory_id != null && widget.subCategory_id != '0'
            ? FirebaseFirestore.instance
                .collection('Categories')
                .doc(widget.categoryId)
                .collection('sections')
                .doc(widget.subCategory_id)
                .collection('products')
                .snapshots()
            : FirebaseFirestore.instance
                .collection('Categories')
                .doc(widget.categoryId)
                .collection('products')
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
              var product =
                  snapshot.data!.docs[index].data() as Map<String, dynamic>;
              return _buildContentItem(product);
            },
          );
        },
      ),
    );
  }
}
