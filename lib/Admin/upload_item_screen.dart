import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/splash_screen.dart';
import 'package:shqanda_application/Widgets/loading_widget.dart';

enum ContentType { video, image, physical }

class UploadItemScreen extends StatefulWidget {
  final String? subCategory_id;
  final String? categoryId;

  const UploadItemScreen({
    Key? key,
    required this.subCategory_id,
    required this.categoryId,
  }) : super(key: key);

  @override
  _UploadItemScreenState createState() => _UploadItemScreenState();
}

class _UploadItemScreenState extends State<UploadItemScreen> {
  static late SharedPreferences sharedPreferences;
  File? file;
  bool isYouTubeLink = false;
  ContentType selectedContentType = ContentType.physical;
  String selectedType = "جليقية";
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  // Controllers
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _iFleetLinkController = TextEditingController();
  final TextEditingController _youtubeLinkController = TextEditingController();

  Future<void> _pickImage(ImageSource source) async {
    final imageFile = await ImagePicker.platform.pickImage(source: source);
    if (imageFile != null) {
      setState(() {
        file = File(imageFile.path);
        if (selectedContentType == ContentType.physical) {
          _showProductDetailsDialog();
        } else {
          selectedContentType = ContentType.image;
        }
      });
    }
  }

  Future<String> _uploadImage(File imageFile) async {
    final storageRef = FirebaseStorage.instance.ref().child('Items').child(productId);
    final uploadTask = storageRef.putFile(imageFile);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  Widget _buildProductDetailsForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildTextField(
          controller: _titleController,
          label: 'Title'.tr,
          icon: Icons.title,
        ),
        const SizedBox(height: 8),
        _buildTextField(
          controller: _descriptionController,
          label: 'Description'.tr,
          icon: Icons.description,
          maxLines: 3,
        ),
        if (selectedContentType == ContentType.physical) ...[
          const SizedBox(height: 8),
          _buildTextField(
            controller: _priceController,
            label: 'Price (EGP)'.tr,
            icon: Icons.money,
            keyboardType: TextInputType.number,
          ),
        ],
        const SizedBox(height: 8),
        _buildTypeSelector(),
        if (selectedContentType != ContentType.physical) ...[
          const SizedBox(height: 8),
          _buildTextField(
            controller: _iFleetLinkController,
            label: 'iFleet Link'.tr,
            icon: Icons.link,
          ),
        ],
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return DropdownButtonFormField<String>(
      value: selectedType,
      decoration: InputDecoration(
        labelText: 'Type'.tr,
        border: OutlineInputBorder(),
        prefixIcon: Icon(Icons.category),
      ),
      items: ['جليقية', 'لوشيرة', 'رندة', 'اتفح', 'قمارش'].map((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList(),
      onChanged: (newValue) {
        setState(() {
          selectedType = newValue!;
        });
      },
    );
  }

  void _showProductDetailsDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Product Details'.tr),
          content: SingleChildScrollView(
            child: _buildProductDetailsForm(),
          ),
          actions: [
            TextButton(
              child: Text('Cancel'.tr),
              onPressed: () {
                Navigator.of(context).pop();
                _clearForm();
              },
            ),
            ElevatedButton(
              child: Text('Upload'.tr),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF2C51D),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _uploadContent();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _uploadContent() async {
    if (!_validateForm()) return;

    setState(() {
      uploading = true;
    });

    try {
      String contentUrl = "";
      if (selectedContentType == ContentType.video) {
        contentUrl = _youtubeLinkController.text.trim();
      } else if (file != null) {
        contentUrl = await _uploadImage(file!);
      }

      await _saveContent(contentUrl);

      setState(() {
        uploading = false;
        _clearForm();
      });

      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Content uploaded successfully'.tr))
      );
    } catch (e) {
      setState(() {
        uploading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error uploading content: $e'))
      );
    }
  }

  bool _validateForm() {
    if (_titleController.text.isEmpty) {
      _showError('Please enter a title');
      return false;
    }

    if (selectedContentType == ContentType.video && _youtubeLinkController.text.isEmpty) {
      _showError('Please enter a YouTube link');
      return false;
    }

    if (selectedContentType == ContentType.physical) {
      if (_priceController.text.isEmpty) {
        _showError('Please enter a price');
        return false;
      }
      if (file == null || file!.path.isEmpty) {
        _showError('Please upload a product image');
        return false;
      }
    }

    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message.tr))
    );
  }

  Future<void> _saveContent(String contentUrl) async {
    final itemRef = widget.subCategory_id != null && widget.subCategory_id != '0'
        ? FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.categoryId)
        .collection('sections')
        .doc(widget.subCategory_id)
        .collection('products')
        : FirebaseFirestore.instance
        .collection('Categories')
        .doc(widget.categoryId)
        .collection('products');

    final productData = {
      'product_id': productId,
      'category': widget.categoryId ?? '0',
      'section': widget.subCategory_id ?? '0',
      'name': _titleController.text.trim(),
      'description': _descriptionController.text.trim(),
      'picture': contentUrl,
      'publishedDate': DateTime.now(),
      'type': selectedType,
      'contentType': selectedContentType.toString().split('.').last,
    };

    if (selectedContentType != ContentType.physical &&
        _iFleetLinkController.text.isNotEmpty) {
      productData['iFleetLink'] = _iFleetLinkController.text.trim();
    }

    if (selectedContentType == ContentType.physical) {
      final price = double.tryParse(_priceController.text);
      if (price != null) {
        productData['price'] = price;
        productData['currency'] = 'EGP';
      }
    }

    await itemRef.doc(productId).set(productData);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('subCategory-id', widget.subCategory_id ?? '0');
  }

  void _clearForm() {
    setState(() {
      file = null;
      _titleController.clear();
      _descriptionController.clear();
      _priceController.clear();
      _iFleetLinkController.clear();
      _youtubeLinkController.clear();
      selectedType = "جليقية";
      selectedContentType = ContentType.physical;
      isYouTubeLink = false;
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _iFleetLinkController.dispose();
    _youtubeLinkController.dispose();
    super.dispose();
  }

  // Build methods from your original code remain the same
  @override
  Widget build(BuildContext context) {
    return file == null && !isYouTubeLink
        ? displayAdminHomeScreen()
        : displayAdminUploadScreen();
  }

  Widget displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Color(0xFFF2C51D),
        ),
        title: Text('رفع محتوى'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (c) => SplashScreen()),
              );
            },
            child: Text('logout'.tr, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  Widget getAdminHomeScreenBody() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildContentTypeButton(
                icon: Icons.video_library,
                label: 'Video',
                type: ContentType.video,
              ),
              _buildContentTypeButton(
                icon: Icons.image,
                label: 'Image',
                type: ContentType.image,
              ),
              _buildContentTypeButton(
                icon: Icons.shopping_bag,
                label: 'Product',
                type: ContentType.physical,
              ),
            ],
          ),
          SizedBox(height: 30),

          if (selectedContentType == ContentType.physical)
            Column(
              children: [
                Text(
                  'Upload Product Image'.tr,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: Icon(Icons.photo_library),
                  label: Text('Choose from Gallery'.tr),
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFFF2C51D),
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                if (file != null) ...[
                  SizedBox(height: 16),
                  Container(
                    height: 150,
                    width: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: FileImage(file!),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ],
            )
          else
            ElevatedButton(
              onPressed: () {
                if (selectedContentType == ContentType.video) {
                  setState(() => isYouTubeLink = true);
                } else if (selectedContentType == ContentType.image) {
                  _pickImage(ImageSource.gallery);
                }
              },
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF2C51D),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text('Add New Content'.tr),
            ),

          if (selectedContentType == ContentType.physical && file != null) ...[
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => _showProductDetailsDialog(),
              child: Text('Add Product Details'.tr),
              style: ElevatedButton.styleFrom(
                primary: Color(0xFFF2C51D),
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
            ),
          ],
        ],
      ),
    );
  }
  Widget _buildContentTypeButton({
    required IconData icon,
    required String label,
    required ContentType type,
  }) {
    return InkWell(
      onTap: () => setState(() => selectedContentType = type),
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedContentType == type
              ? Color(0xFFF2C51D)
              : Colors.grey[200],
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 32),
            SizedBox(height: 8),
            Text(label),
          ],
        ),
      ),
    );
  }

  Widget displayAdminUploadScreen() {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        title: Text('New ${selectedContentType.toString().split('.').last}'.tr),
        actions: [
          TextButton(
            onPressed: uploading ? null : _uploadContent,
            child: Text('Add'.tr, style: TextStyle(color: Colors.white)),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (uploading) circularProgress(),
          if (selectedContentType == ContentType.video)
            _buildTextField(
              controller: _youtubeLinkController,
              label: 'YouTube Link'.tr,
              icon: Icons.video_library,
            )
          else if (file != null)
            Container(
              height: 200,
              margin: EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: FileImage(file!),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          SizedBox(height: 16),
          _buildProductDetailsForm(),
        ],
      ),
    );
  }
}