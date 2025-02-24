import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart'; // Import for toast
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Widgets/loading_widget.dart';

import '../Screens/splash_screen.dart';

class CategorySections extends StatefulWidget {
  final String category_id;

  const CategorySections({Key? key, required this.category_id}) : super(key: key);

  @override
  _CategorySectionsState createState() => _CategorySectionsState();
}


class _CategorySectionsState extends State<CategorySections> {
  File? file;

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

  TextEditingController _titleTextEditingController = TextEditingController();
  TextEditingController _titleArabicTextEditingController = TextEditingController();

  String productId = DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading = false;

  uploadImageandSaveItemInfo() async {
    setState(() {
      uploading = true;
    });
    String imageDownloadUrl = await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }

  Future<String> uploadItemImage(mFileImage) async {
    var storageReference = FirebaseStorage.instance.ref().child('subCategories').child(productId);
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
        actions: [
          FlatButton(
            onPressed: () {
              Route route = MaterialPageRoute(builder: (c) => SplashScreen());
              Navigator.pushReplacement(context, route);
            },
            child: Text('logout'.tr, style: TextStyle(color: Colors.pink, fontSize: 16, fontWeight: FontWeight.bold)),
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
            )
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
          )
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
                  hintText: 'subCategory name'.tr,
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
                  hintText: 'subCategory name in arabic'.tr,
                  hintStyle: TextStyle(color: Colors.deepPurpleAccent),
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

  saveItemInfo(String downloadUrl) async {
    final itemRef = FirebaseFirestore.instance.collection('Categories').doc( widget.category_id).collection('sections');
    itemRef.doc(productId).set({
      'category_id': widget.category_id,
      'subCategory-id': productId,
      'name': _titleTextEditingController.text.trim(),
      'title_arabic': _titleArabicTextEditingController.text.trim(),
      'picture': downloadUrl

    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('category_id', productId);

    setState(() {
      uploading = false;
      productId = DateTime.now().millisecondsSinceEpoch.toString();
      clearFormInfo(); // Clear the form after saving
    });

    Fluttertoast.showToast(
      msg: "تمت إضافة الفئة بنجاح", // Toast in Arabic
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return file == null ? displayAdminHomeScreen() : displayAdminUploadScreen();
  }
}
