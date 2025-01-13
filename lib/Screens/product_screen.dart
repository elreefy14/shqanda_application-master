import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
// physical_products_screen.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:url_launcher/url_launcher.dart';

class PhysicalProductsScreen extends StatelessWidget {
  final String categoryId;
  final String subCategoryId;

  const PhysicalProductsScreen({
    Key? key,
    required this.categoryId,
    required this.subCategoryId,
  }) : super(key: key);


  Future<void> _launchWhatsApp(Map<String, dynamic> productData) async {
    final message = '''
New Order:
Product: ${productData['name']}
Price: ${(productData['price'] ?? 0).toStringAsFixed(0)} EGP
Description: ${productData['description']}'''.trim();

    final whatsappUrl = "whatsapp://send?phone=+201093581482&text=${Uri.encodeComponent(message)}";

    try {
      if (await canLaunch(whatsappUrl)) {
        await launch(whatsappUrl);
      } else {
        print('Could not launch WhatsApp');
      }
    } catch (e) {
      print('Error launching WhatsApp: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
return Scaffold(
  appBar: AppBar(
    backgroundColor: const Color(0xFFF2C51D),
    title: Text('Physical Products'.tr),
    centerTitle: true,
  ),
  body: StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('Categories')
        .doc(categoryId)
        .collection('sections')
        .doc(subCategoryId)
        .collection('products')
        .where('contentType', isEqualTo: 'physical')
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Error: ${snapshot.error}'));
      }

      if (!snapshot.hasData) {
        return const Center(child: CircularProgressIndicator());
      }

      final products = snapshot.data!.docs;

      return GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index].data() as Map<String, dynamic>;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      image: DecorationImage(
                        image: NetworkImage(product['picture'] ?? ''),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  flex: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['name'] ?? '',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          product['description'] ?? '',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${(product['price'] ?? 0).toStringAsFixed(0)} EGP',
                          style: const TextStyle(
                            color: Color(0xFFF2C51D),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 8),
                    Expanded(
                    child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                await _launchWhatsApp(product);
                              },
                              icon: const Icon(Icons.shopping_cart, size: 16),
                              label: Text('Order Now'.tr),
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFF2C51D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
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
);  }
}
class ProductScreen extends StatefulWidget {
  final String subCategory_id;
  final String category_id;
  final String type;

  const ProductScreen({
    Key? key,
    required this.subCategory_id,
    required this.category_id,
    required this.type,
  }) : super(key: key);

  @override
  _ProductScreenState createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  Map<String, YoutubePlayerController> _controllers = {};
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _iFleetLinkController = TextEditingController();

  @override
  void dispose() {
    _controllers.values.forEach((controller) => controller.dispose());
    _nameController.dispose();
    _descriptionController.dispose();
    _iFleetLinkController.dispose();
    super.dispose();
  }

  bool _isYoutubeLink(String? url) {
    if (url == null) return false;
    return url.contains('youtube.com') || url.contains('youtu.be');
  }

  String? _extractYoutubeVideoId(String url) {
    return YoutubePlayer.convertUrlToId(url);
  }

  YoutubePlayerController _createController(String videoId) {
    return YoutubePlayerController(
      initialVideoId: videoId,
      flags: const YoutubePlayerFlags(
        autoPlay: false,
        mute: false,
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchWhatsApp(Map<String, dynamic> productData) async {
    final message = '''
      New Order:
      Product: ${productData['name']}
      Price: ${productData['price']} EGP
      Description: ${productData['description']}
    ''';

    final whatsappUrl = "whatsapp://send?phone=+201093581482&text=${Uri.encodeComponent(message)}";

    if (await canLaunch(whatsappUrl)) {
      await launch(whatsappUrl);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch WhatsApp'))
      );
    }
  }

  Future<void> _showEditDialog(BuildContext context, DocumentSnapshot doc) async {
    Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    _nameController.text = data['name'] ?? '';
    _descriptionController.text = data['description'] ?? '';
    _iFleetLinkController.text = data['iFleetLink'] ?? '';

    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Product'.tr),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Name'.tr),
              ),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Description'.tr),
                maxLines: 3,
              ),
              TextField(
                controller: _iFleetLinkController,
                decoration: InputDecoration(labelText: 'iFleet Link'.tr),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'.tr),
          ),
          TextButton(
            onPressed: () async {
              try {
                await FirebaseFirestore.instance
                    .collection('Categories')
                    .doc(widget.category_id)
                    .collection('sections')
                    .doc(widget.subCategory_id)
                    .collection('products')
                    .doc(doc.id)
                    .update({
                  'name': _nameController.text,
                  'description': _descriptionController.text,
                  'iFleetLink': _iFleetLinkController.text,
                  'updatedAt': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Product updated successfully'.tr)),
                );
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error updating product: $e')),
                );
              }
            },
            child: Text('Save'.tr),
          ),
        ],
      ),
    );
  }

  Widget _buildMediaContent(Map<String, dynamic> data, String productId) {
    final mediaUrl = data['picture'];
    final contentType = data['contentType'] ?? 'image';

    if (mediaUrl == null || mediaUrl.isEmpty) {
      return Container(
        height: 200,
        child: Center(child: Text('No media available')),
      );
    }

    if (contentType == 'video') {
      String? videoId = _extractYoutubeVideoId(mediaUrl);
      if (videoId == null) return Container();

      if (!_controllers.containsKey(productId)) {
        _controllers[productId] = _createController(videoId);
      }

      return YoutubePlayer(
        controller: _controllers[productId]!,
        showVideoProgressIndicator: true,
        progressIndicatorColor: Colors.red,
        progressColors: ProgressBarColors(
          playedColor: Colors.red,
          handleColor: Colors.redAccent,
        ),
      );
    } else {
      return Image.network(
        mediaUrl,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => Container(
          height: 200,
          child: Center(child: Icon(Icons.error)),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2C51D),
        title: Text('Products'.tr),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_bag),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PhysicalProductsScreen(
                    categoryId: widget.category_id,
                    subCategoryId: widget.subCategory_id,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Categories')
            .doc(widget.category_id)
            .collection('sections')
            .doc(widget.subCategory_id)
            .collection('products')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var doc = snapshot.data!.docs[index];
              Map<String, dynamic> data = doc.data() as Map<String, dynamic>;

              // Skip physical products as they'll be shown in their own screen
              if (data['contentType'] == 'physical') {
                return Container();
              }

              return Card(
                margin: EdgeInsets.all(8.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          IconButton(
                            icon: Icon(Icons.edit, color: Color(0xFFF2C51D)),
                            onPressed: () => _showEditDialog(context, doc),
                          ),
                        ],
                      ),
                      _buildMediaContent(data, doc.id),
                      SizedBox(height: 12),
                      Text(
                        data['name'] ?? 'No name',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        data['description'] ?? 'No description',
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      if (data['iFleetLink'] != null) ...[
                        // Padding(
                        //   padding: const EdgeInsets.only(top: 12.0),
                        //   child: ElevatedButton.icon(
                        //     onPressed: () => _launchURL(data['iFleetLink']),
                        //     icon: Icon(Icons.link),
                        //     label: Text('Show Content'.tr),
                        //     style: ElevatedButton.styleFrom(
                        //       primary: Color(0xFFF2C51D),
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(8),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
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