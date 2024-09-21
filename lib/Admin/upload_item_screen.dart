import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/admin_shift_orders_screen.dart';
import 'package:shqanda_application/Screens/splash_screen.dart';
import 'package:shqanda_application/Widgets/loading_widget.dart';
class UploadItemScreen extends StatefulWidget {
  final String subCategory_id;
  final String categoryId;
  const UploadItemScreen({Key? key, required this.subCategory_id,required this.categoryId}) : super(key: key);
  @override
  _UploadItemScreenState createState() => _UploadItemScreenState();
}
class _UploadItemScreenState extends State<UploadItemScreen> {
  static late  SharedPreferences sharedPreferences;

  File? file;
  capturePhotoWithCamera() async{
    Navigator.pop(context);
    var imageFile=  await ImagePicker.platform.pickImage(source: ImageSource.camera,maxWidth: 680,maxHeight: 790) ;
    setState(() {
      file=File(imageFile!.path);
    });
  }
  pickImageFromGallery()async {
    Navigator.pop(context);
    var imageFile=  await ImagePicker.platform.pickImage(source: ImageSource.gallery,);
    setState(() {
      file=File(imageFile!.path);
    });
  }
  bool get wantKeepAlive => true;
  TextEditingController _descriptionTextEditingController=TextEditingController();
  TextEditingController _descriptionArabicTextEditingController=TextEditingController();
  TextEditingController _titleTextEditingController=TextEditingController();
  TextEditingController _priceTextEditingController=TextEditingController();
  TextEditingController _shippingDurationTextEditingController=TextEditingController();
  TextEditingController _amountTextEditingController=TextEditingController();
  TextEditingController _orderNumberTextEditingController=TextEditingController();
  TextEditingController _titleArabicTextEditingController=TextEditingController();

  String productId=DateTime.now().millisecondsSinceEpoch.toString();
  bool uploading=false;
  uploadImageandSaveItemInfo()async {
    setState(() {
      uploading=true;
    });
    String imageDownloadUrl=await uploadItemImage(file);
    saveItemInfo(imageDownloadUrl);
  }
  Future<String> uploadItemImage(mFileImage) async{
    var  storageReference=FirebaseStorage.instance.ref().child('Items').child(productId);
   UploadTask uploadTask = storageReference.putFile(mFileImage);
   TaskSnapshot taskSnapshot =await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }
  displayAdminHomeScreen(){
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: FractionalOffset(0.0,0.0),
                  end: FractionalOffset(1.0,0.0),
                  stops: [0.0,1.0],
                  tileMode:TileMode.clamp
              )
          ),

        ),
        // leading: IconButton(
        //   onPressed: (){
        //     Route route=MaterialPageRoute(builder: (c)=>AdminShiftOrders());
        //   Navigator.pushReplacement(context, route);},
        //   icon:Icon(Icons.border_color,color: Colors.white),
        // ),
        actions: [
          FlatButton(onPressed: (){
            Route route=MaterialPageRoute(builder: (c)=>SplashScreen());
            Navigator.pushReplacement(context, route);
          }, child: Text('logout'.tr,style: TextStyle(color: Colors.pink,fontSize: 16,fontWeight: FontWeight.bold),))
        ],
      ),
      body: getAdminHomeScreenBody(),
    );
  }

  getAdminHomeScreenBody() {
    return Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.pink,Colors.lightGreenAccent],
              begin: FractionalOffset(0.0,0.0),
              end: FractionalOffset(1.0,0.0),
              stops: [0.0,1.0],
              tileMode:TileMode.clamp
          )
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.shop_two,color: Colors.white,size: 200,),
            Padding(
              padding: EdgeInsets.only(top: 20),
              child: RaisedButton(
                onPressed: (){
                  takeImage(context);
                },
                color: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: Text('Add new item'.tr,style: TextStyle(color: Colors.white,fontSize: 20),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  takeImage( mContext) {
    return showDialog
      (
        context:mContext,
        builder: (con){
          return SimpleDialog(
            title: Text('Item Image'.tr,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),),
            children: [
              SimpleDialogOption(
                child: Text('Capture with camera'.tr,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                onPressed: capturePhotoWithCamera,
              ),
              SimpleDialogOption(
                child: Text('Select from Gallery'.tr,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                onPressed: pickImageFromGallery,
              ),
              SimpleDialogOption(
                child: Text('Cancel'.tr,style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold)),
                onPressed: (){
                  Navigator.pop(context);
                },
              )
            ],
          );
        }
    );
  }
  clearFormInfo() {
    setState(() {
      file==null;
      _descriptionTextEditingController.clear();
      _titleTextEditingController.clear();
      _priceTextEditingController.clear();
      _amountTextEditingController.clear();
      _shippingDurationTextEditingController.clear();
      _orderNumberTextEditingController.clear();
      _titleArabicTextEditingController.clear();
      _descriptionArabicTextEditingController.clear();


    });
  }
  displayAdminUploadScreen() {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: [Colors.pink,Colors.lightGreenAccent],
                  begin: FractionalOffset(0.0,0.0),
                  end: FractionalOffset(1.0,0.0),
                  stops: [0.0,1.0],
                  tileMode:TileMode.clamp
              )
          ),

        ),
        // leading: IconButton(
        //   onPressed: clearFormInfo,
        //   icon: Icon(Icons.arrow_back,color: Colors.white,
        //   ),),
        title: Text('New Product'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 24),),
        actions: [
          FlatButton(
              onPressed: uploading?null:()=>uploadImageandSaveItemInfo(),

              child: Text('Add'.tr,style:  TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 16),))
        ],
      ),
      body: ListView(
        children: [
          uploading?circularProgress():Text(''),
          Container(
            height: 260,
            width: MediaQuery.of(context).size.width*.8,
            child: Center(child: AspectRatio(
              aspectRatio: 16/9,
              child: Container(
                decoration: BoxDecoration(image: DecorationImage(image: FileImage(file!),fit: BoxFit.cover)),
              ),
            )),
            padding: EdgeInsets.only(top: 12),
          ),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _amountTextEditingController,
                decoration: InputDecoration(
                    hintText: 'amount'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),

          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleTextEditingController,
                decoration: InputDecoration(
                    hintText: 'product name in english'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),
          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _titleArabicTextEditingController,
                decoration: InputDecoration(
                    hintText: 'product name in arabic'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),

          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Description in English'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),

          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _descriptionArabicTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Description in arabic'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),

          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _shippingDurationTextEditingController,
                decoration: InputDecoration(
                    hintText: 'shippingInfo'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),

          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _orderNumberTextEditingController,
                decoration: InputDecoration(
                    hintText: 'orderNumber'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),

          ),
          Divider(color: Colors.pink,),
          ListTile(
            leading: Icon(Icons.perm_device_information,color: Colors.pink,),
            title: Container(
              width: 240,
              child: TextField(
                style: TextStyle(color: Colors.deepPurpleAccent),
                controller: _priceTextEditingController,
                decoration: InputDecoration(
                    hintText: 'Price'.tr,
                    hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                    border: InputBorder.none
                ),
              ),
            ),

          ),

          Divider(color: Colors.pink,)
        ],
      ),
    );
  }
  saveItemInfo(String downloadUrl) async{
    //SharedPreferences prefs = await SharedPreferences.getInstance();
    final itemRef=FirebaseFirestore.instance.collection('items');
    itemRef.doc(productId).set({
      'amount':_amountTextEditingController.text.trim(),
      'shippingDuration':_shippingDurationTextEditingController.text.trim(),
      'orderNum':int.parse(_orderNumberTextEditingController.text),
      'product_id':productId,
      'category_id':widget.categoryId,
      'subCategory_id':   widget.subCategory_id ,
      'longDescription':_descriptionTextEditingController.text.trim(),
      'description_arabic':_descriptionArabicTextEditingController.text.trim(),
      'price':int.parse(_priceTextEditingController.text),
      'publishedDate':DateTime.now(),
      'status':'available',
      'title':_titleTextEditingController.text.trim(),
      'title_arabic':_titleArabicTextEditingController.text.trim(),
      'thumbnailUrl':downloadUrl
    });
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    prefs.setString('subCategory-id',  widget.subCategory_id);
    setState(() {
      uploading=false;
      productId=DateTime.now().millisecondsSinceEpoch.toString();
      _amountTextEditingController.clear();
      _shippingDurationTextEditingController.clear();
      _orderNumberTextEditingController.clear();
      _titleTextEditingController.clear();
      _descriptionTextEditingController.clear();
      _priceTextEditingController.clear();
      _titleArabicTextEditingController.clear();
      _descriptionArabicTextEditingController.clear();
    });
  }
      @override
  Widget build(BuildContext context) {
        return file==null? displayAdminHomeScreen():displayAdminUploadScreen();
  }
}
