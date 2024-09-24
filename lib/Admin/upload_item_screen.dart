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

  TextEditingController _descriptionTextEditingController = TextEditingController();
  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _iFleetLinkTextEditingController = TextEditingController(); // TextField for iFleet link

  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  uploadImageAndSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    if (file != null) {
      String imageDownloadUrl = await uploadItemImage(file);
      saveItemInfo(imageDownloadUrl);
    } else {
      saveItemInfo(""); // Save without image
    }
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
      _iFleetLinkTextEditingController.clear(); // Clear iFleet link
    });
  }
//if subCategory_id not equal zero or null
  // collection('Categories').
  // doc('${widget.categoryId}').
  //collection('sections').
  //doc('subCategory_id)
  // collection('products');
  saveItemInfo(String downloadUrl) async {
    // Initialize the reference to Firestore
    CollectionReference itemRef;

    // Check if subCategory_id is not null or '0'
    if (widget.subCategory_id != null && widget.subCategory_id != '0') {
      // If subCategory_id is valid, nest under 'sections' -> 'subCategory_id' -> 'products'
      itemRef = FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.categoryId)
          .collection('sections')
          .doc(widget.subCategory_id)
          .collection('products');
    } else {
      // Otherwise, add directly under 'products' collection
      itemRef = FirebaseFirestore.instance
          .collection('Categories')
          .doc(widget.categoryId)
          .collection('products');
    }

    // Set the product details
    await itemRef.doc(productId).set({
      'product_id': productId,
      'category': widget.categoryId ?? '0', // Using categoryId from widget
      'section': widget.subCategory_id ?? '0', // Using subCategory_id from widget
      'name': _titleTextEditingController.text.trim(),
      'description': _descriptionTextEditingController.text.trim(), // Add description field
      'iFleetLink': _iFleetLinkTextEditingController.text.trim(), // iFleet link
      'picture': downloadUrl,
      'publishedDate': DateTime.now(),
    });

    // Save subCategory-id to shared preferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('subCategory-id', widget.subCategory_id ?? '0');

    // Reset the form state after uploading
    setState(() {
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      clearFormInfo();
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
              Icons.description,
              color: Colors.pink,
            ),
            title: Container(
              width: 250,
              child: TextField(
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: 'Description'.tr,
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
        ],
      ),
    );
  }
}
