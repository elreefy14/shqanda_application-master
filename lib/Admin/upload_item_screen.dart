import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/splash_screen.dart';
import 'package:shqanda_application/Widgets/loading_widget.dart';

enum ContentType {
  video,
  image,
  physical
}

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
  final TextEditingController _priceController = TextEditingController();

  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _iFleetLinkTextEditingController = TextEditingController();
  TextEditingController _youtubeLinkTextEditingController = TextEditingController();
  String selectedType = "جليقية";
  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.platform.pickImage(
        source: ImageSource.camera, maxWidth: 680, maxHeight: 790);
    if (imageFile != null) {
      setState(() {
        file = File(imageFile.path);
        selectedContentType = ContentType.image;
      });
    }
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );
    if (imageFile != null) {
      setState(() {
        file = File(imageFile.path);
        selectedContentType = ContentType.image;
      });
    }
  }

  bool get wantKeepAlive => true;

  uploadImageAndSaveItemInfo() async {
    if (!validateForm()) {
      return;
    }

    setState(() {
      uploading = true;
    });

    String pictureUrl = "";
    if (selectedContentType == ContentType.video) {
      pictureUrl = _youtubeLinkTextEditingController.text.trim();
    } else if (selectedContentType == ContentType.image && file != null) {
      pictureUrl = await uploadItemImage(file);
    }

    await saveItemInfo(pictureUrl);

    setState(() {
      uploading = false;
      clearFormInfo();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Item uploaded successfully'))
    );
  }

  bool validateForm() {
    if (_titleTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a title'))
      );
      return false;
    }

    if (selectedContentType == ContentType.video &&
        _youtubeLinkTextEditingController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a YouTube link'))
      );
      return false;
    }

    if (selectedContentType == ContentType.physical &&
        _priceController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a price'))
      );
      return false;
    }

    return true;
  }

  Future<String> uploadItemImage(File? mFileImage) async {
    if (mFileImage == null) return "";

    var storageReference = FirebaseStorage.instance.ref().child('Items').child(productId);
    UploadTask uploadTask = storageReference.putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  void clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _iFleetLinkTextEditingController.clear();
      _youtubeLinkTextEditingController.clear();
      _priceController.clear();
      selectedType = "جليقية";
      selectedContentType = ContentType.physical;
      isYouTubeLink = false;
    });
  }

  Future<void> saveItemInfo(String pictureUrl) async {
    CollectionReference itemRef;

    if (widget.subCategory_id != null && widget.subCategory_id != '0') {
      itemRef = FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.categoryId)
          .collection('sections')
          .doc(widget.subCategory_id)
          .collection('products');
    } else {
      itemRef = FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.categoryId)
          .collection('products');
    }

    final productData = {
      'product_id': productId,
      'category': widget.categoryId ?? '0',
      'section': widget.subCategory_id ?? '0',
      'name': _titleTextEditingController.text.trim(),
      'description': _descriptionTextEditingController.text.trim(),
      'iFleetLink': _iFleetLinkTextEditingController.text.trim(),
      'picture': pictureUrl,
      'publishedDate': DateTime.now(),
      'type': selectedType,
      'contentType': selectedContentType.toString().split('.').last,
    };

    // Add price only for physical products
    if (selectedContentType == ContentType.physical) {
      final price = double.tryParse(_priceController.text);
      if (price != null) {
        productData['price'] = price;
        productData['currency'] = 'EGP';
      }
    }

    if (selectedContentType == ContentType.physical) {
      productData['price'] = double.tryParse(_priceController.text) ?? 0.0;
    }

    await itemRef.doc(productId).set(productData);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('subCategory-id', widget.subCategory_id ?? '0');
  }

  @override
  Widget build(BuildContext context) {
    return file == null && !isYouTubeLink ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          color: Color(0xFFF2C51D),
        ),
        title: Text('Upload Content'.tr),
        actions: [
          TextButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Text(
              'logout'.tr,
              style: TextStyle(color: Colors.white),
            ),
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
          ElevatedButton(
            onPressed: () {
              if (selectedContentType == ContentType.video) {
                setState(() {
                  isYouTubeLink = true;
                });
              } else if (selectedContentType == ContentType.image) {
                takeImage(context);
              } else {
                setState(() {
                  file = File(''); // Dummy file to trigger product form
                });
              }
            },
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFF2C51D),
              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
            child: Text('Add New Content'.tr),
          ),
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
      onTap: () {
        setState(() {
          selectedContentType = type;
        });
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selectedContentType == type ? Color(0xFFF2C51D) : Colors.grey[200],
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
            onPressed: uploading ? null : uploadImageAndSaveItemInfo,
            child: Text(
              'Add'.tr,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          if (uploading) circularProgress(),

          // Content Display
          if (selectedContentType == ContentType.video)
            _buildYoutubeLinkInput()
          else if (selectedContentType == ContentType.image && file != null)
            _buildImagePreview()
          else if (selectedContentType == ContentType.physical)
            _buildProductForm(),

          // Common Fields
          _buildTextField(
            controller: _titleTextEditingController,
            hint: 'Title'.tr,
            icon: Icons.title,
          ),
          _buildTextField(
            controller: _descriptionTextEditingController,
            hint: 'Description'.tr,
            icon: Icons.description,
            maxLines: 3,
          ),

          // Type Selector
          _buildTypeSelector(),

          // Additional Fields based on content type
          if (selectedContentType == ContentType.physical) ...[
            _buildTextField(
              controller: _priceController,
              hint: 'Price (EGP)'.tr,
              icon: Icons.money,
              keyboardType: TextInputType.number,
            ),
            _buildTextField(
              controller: _iFleetLinkTextEditingController,
              hint: 'Seller Link'.tr,
              icon: Icons.link,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildYoutubeLinkInput() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 16),
      child: TextField(
        controller: _youtubeLinkTextEditingController,
        decoration: InputDecoration(
          labelText: 'YouTube Link'.tr,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.video_library),
        ),
      ),
    );
  }

  Widget _buildImagePreview() {
    return Container(
      height: 200,
      margin: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        image: DecorationImage(
          image: FileImage(file!),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildProductForm() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Product Information'.tr,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),
          if (file != null) _buildImagePreview(),
          ElevatedButton(
            onPressed: () => takeImage(context),
            child: Text('Add Product Image'.tr),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFF2C51D),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: hint,
          border: OutlineInputBorder(),
          prefixIcon: Icon(icon),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        decoration: InputDecoration(
          labelText: 'Type'.tr,
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.category),
        ),
        items: <String>['جليقية', 'لوشيرة', 'رندة', 'اتفح', 'قمارش']
            .map((String value) {
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
      ),
    );
  }

  void takeImage(BuildContext mContext) {
    showDialog(
      context: mContext,
      builder: (context) {
        return SimpleDialog(
          title: Text('Select Image'.tr),
          children: [
            SimpleDialogOption(
              child: Text('Camera'.tr),
              onPressed: capturePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text('Gallery'.tr),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text('Cancel'.tr),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _descriptionTextEditingController.dispose();
    _titleTextEditingController.dispose();
    _iFleetLinkTextEditingController.dispose();
    _youtubeLinkTextEditingController.dispose();
    _priceController.dispose();
    super.dispose();
  }
}