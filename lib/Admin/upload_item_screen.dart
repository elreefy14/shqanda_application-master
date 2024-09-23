import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/splash_screen.dart';
import 'package:shqanda_application/Widgets/loading_widget.dart';

class UploadItemScreen extends StatefulWidget {
  final String subCategory_id;
  final String categoryId;

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

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.platform.pickImage(
        source: ImageSource.camera, maxWidth: 680, maxHeight: 790);
    setState(() {
      file = File(imageFile!.path);
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.platform.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      file = File(imageFile!.path);
    });
  }

  bool get wantKeepAlive => true;

  TextEditingController _descriptionTextEditingController =
  TextEditingController();
  TextEditingController _descriptionArabicTextEditingController =
  TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _priceTextEditingController = TextEditingController();
  TextEditingController _shippingDurationTextEditingController =
  TextEditingController();
  TextEditingController _amountTextEditingController = TextEditingController();
  TextEditingController _orderNumberTextEditingController =
  TextEditingController();
  TextEditingController _titleArabicTextEditingController =
  TextEditingController();
  TextEditingController _iFleetLinkTextEditingController =
  TextEditingController(); // TextField for iFleet link

  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    var storageReference =
    FirebaseStorage.instance.ref().child('Items').child(productId);
    UploadTask uploadTask = storageReference.putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _amountTextEditingController.clear();
      _shippingDurationTextEditingController.clear();
      _orderNumberTextEditingController.clear();
      _titleArabicTextEditingController.clear();
      _descriptionArabicTextEditingController.clear();
      _iFleetLinkTextEditingController.clear(); // Clear iFleet link
    });
  }

  saveItemInfo(String downloadUrl) async {
    final itemRef = FirebaseFirestore.instance.collection('items');
    itemRef.doc(productId).set({
      'product_id': productId,
      'category_id': widget.categoryId, // Using categoryId from widget
      'subCategory_id': widget.subCategory_id, // Using subCategory_id from widget
      'longDescription': _descriptionArabicTextEditingController.text.trim(),
      'description_arabic': _descriptionArabicTextEditingController.text.trim(),
      'price': int.parse(_priceTextEditingController.text),
      'publishedDate': DateTime.now(),
      'title': _titleTextEditingController.text.trim(),
      'title_arabic': _titleArabicTextEditingController.text.trim(),
      'thumbnailUrl': downloadUrl,
      'iFleetLink': _iFleetLinkTextEditingController.text.trim(), // iFleet link
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('subCategory-id', widget.subCategory_id);
    setState(() {
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _amountTextEditingController.clear();
      _shippingDurationTextEditingController.clear();
      _orderNumberTextEditingController.clear();
      _titleTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _titleArabicTextEditingController.clear();
      _descriptionArabicTextEditingController.clear();
      _iFleetLinkTextEditingController.clear(); // Clear iFleet link
    });
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }

  displayAdminHomeScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        actions: [
          FlatButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Text(
              'logout'.tr,
              style: TextStyle(
                  color: Colors.pink, fontSize: 16, fontWeight: FontWeight.bold),
            ),
          )
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.pink, Colors.lightGreenAccent],
          begin: FractionalOffset(0.0, 0.0),
          end: FractionalOffset(1.0, 0.0),
          stops: [0.0, 1.0],
          tileMode: TileMode.clamp,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two, color: Colors.white, size: 200),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: () {
                  takeImage(context);
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text(
                  'Add new item'.tr,
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage(mContext) {
    return showDialog(
      context: mContext,
      builder: (con) {
        return SimpleDialog(
          title: Text(
            'Item Image'.tr,
            style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
          ),
          children: [
            SimpleDialogOption(
              child: Text(
                'Capture with camera'.tr,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: capturePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text(
                'Select from Gallery'.tr,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text(
                'Cancel'.tr,
                style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }

  displayAdminUploadScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.pink, Colors.lightGreenAccent],
              begin: FractionalOffset(0.0, 0.0),
              end: FractionalOffset(1.0, 0.0),
              stops: [0.0, 1.0],
              tileMode: TileMode.clamp,
            ),
          ),
        ),
        title: Text(
          'New Product'.tr,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: [
          FlatButton(
            onPressed: uploading ? null : () => uploadImageAndSaveItemInfo(),
            child: Text(
              'Add'.tr,
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(''),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(file!),
                        fit: BoxFit.cover,
                      )),
                ),
              ),
            ),
          ),
          Padding(padding: EdgeInsets.only(top: 12)),
          ListTile(
            leading: Icon(
              Icons.perm_device_information,
              color: Colors.pink,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Title'.tr,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              Icons.link,
              color: Colors.pink,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _iFleetLinkTextEditingController,
                decoration: InputDecoration(
                  hintText: 'iFleet Link'.tr,
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink),
          // Add remaining form fields for input here as needed.
        ],
      ),
    );
  }
}
