import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Widgets/loading_widget.dart';

class AddCategoryScreen extends StatefulWidget {
  @override
  _AddCategoryScreenState createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  static late SharedPreferences sharedPreferences;
  File? file;
  String selectedType = "جليقية"; // Default value for the dropdown
  bool isSubCat = false; // Field to determine if it's a subcategory

  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _titleArabicTextEditingController = TextEditingController();

  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  capturePhotoWithCamera() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.platform.pickImage(source: ImageSource.camera, maxWidth: 680, maxHeight: 790);
    setState(() {
      file = File(imageFile!.path);
    });
  }

  pickImageFromGallery() async {
    Navigator.pop(context);
    var imageFile = await ImagePicker.platform.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(imageFile!.path);
    });
  }

  bool get wantKeepAlive => true;

  uploadImageandSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    var storageReference = FirebaseStorage.instance.ref().child('Categories').child(productId);
    UploadTask uploadTask = storageReference.putFile(mFileImage);
    TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
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
                child: Text('Add new item'.tr, style: TextStyle(color: Colors.white, fontSize: 20)),
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
          title: Text('Item Image'.tr, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
          children: [
            SimpleDialogOption(
              child: Text('Capture with camera'.tr, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: capturePhotoWithCamera,
            ),
            SimpleDialogOption(
              child: Text('Select from Gallery'.tr, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: pickImageFromGallery,
            ),
            SimpleDialogOption(
              child: Text('Cancel'.tr, style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  clearFormInfo() {
    setState(() {
      file = null;
      _titleTextEditingController.clear();
      _titleArabicTextEditingController.clear();
      selectedType = "جليقية"; // Reset to default value
    });
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
        title: Text('New Product'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
        actions: [
          FlatButton(
            onPressed: uploading ? null : () => uploadImageandSaveItemInfo(),
            child: Text('Add'.tr, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading ? circularProgress() : Text(''),
          Container(
            height: 260,
            width: MediaQuery.of(context).size.width * .8,
            child: Center(
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(image: DecorationImage(image: FileImage(file!), fit: BoxFit.cover)),
                ),
              ),
            ),
            padding: EdgeInsets.only(top: 12),
          ),
          Divider(color: Colors.pink),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                  hintText: 'category name'.tr,
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink),
          ListTile(
            leading: Icon(Icons.perm_device_information, color: Colors.pink),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleArabicTextEditingController,
                decoration: InputDecoration(
                  hintText: 'category name in arabic'.tr,
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink),
          ListTile(
            leading: Icon(Icons.category, color: Colors.pink),
            title: DropdownButton<String>(
              value: selectedType,
              items: <String>['جليقية', 'لوشيرة', 'رندة', 'اتفح', 'قمارش'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // Display Arabic labels
                );
              }).toList(),
              onChanged: (newValue) {
                setState(() {
                  selectedType = newValue!;
                //isSubCat = selectedType != 'جليقية'; // Update isSubCat based on type
                  isSubCat =false; // Update isSubCat based on type
                });
              },
              hint: Text("Select Type"),
            ),
          ),
          Divider(color: Colors.pink),
        ],
      ),
    );
  }

  saveItemInfo(String downloadUrl) async {
    final itemRef = FirebaseFirestore.instance.collection('Categories');
    await itemRef.doc(productId).set({
      'category_id': productId,
      'name': _titleTextEditingController.text.trim(),
      'title': _titleTextEditingController.text.trim(),
      'title_arabic': _titleArabicTextEditingController.text.trim(),
      'publishedDate': DateTime.now(),
      'status': 'available',
      'thumbnailUrl': downloadUrl,
      'isSubCat': isSubCat, // Added isSubCat field
      'type': selectedType, // Stored selected type
    });

    setState(() {
      file = null;
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      _titleTextEditingController.clear();
      _titleArabicTextEditingController.clear();
      selectedType = "جليقية";
    });
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }
}
