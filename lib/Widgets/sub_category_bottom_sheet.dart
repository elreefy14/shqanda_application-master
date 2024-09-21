import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/show_category_products.dart';

class SubCategoryBottomSheet extends StatefulWidget {
   String id,image;
   String category_id;
   String title;
   String title_arabic;
   SubCategoryBottomSheet({Key? key,required this.title_arabic,required this.title, required this.id, required this.image,required this.category_id}) : super(key: key);

  @override
  _SubCategoryBottomSheetState createState() => _SubCategoryBottomSheetState();
}

class _SubCategoryBottomSheetState extends State<SubCategoryBottomSheet> {
  static late  SharedPreferences sharedPreferences;
  // TextEditingController _titleTextEditingController=TextEditingController();
  // TextEditingController _titleArabicTextEditingController=TextEditingController();
  File? file;
  bool uploading=false;
  // update category info
  updateCategoryInfo(String downloadUrl)async {
    final itemRef=FirebaseFirestore.instance.collection('subCategories');
    itemRef.doc(widget.id).update({
    //  'subCategory-id':widget.id,
      'title':widget.title.trim(),
      'title_arabic':widget.title_arabic.trim(),
      'thumbnailUrl':downloadUrl
    });
    Fluttertoast.showToast(msg: 'SubCategory updated successfully',gravity: ToastGravity.CENTER,);

    setState(() {
      uploading=false;
      // _titleTextEditingController.clear();
      // _titleArabicTextEditingController.clear();
    });
  }
  Future<void> deleteCategoryInfoById()async{
    final itemRef= await FirebaseFirestore.instance.collection('subCategories');
    itemRef.doc(widget.id).delete();
  }
  pickImageFromGallery()async {
    var imageFile=  await ImagePicker.platform.pickImage(source: ImageSource.gallery,);
    setState(() {
      file=File(imageFile!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        child: Column(
          children: [
            Stack(
              children: [

                CircleAvatar(

                    radius: 50,

                    backgroundImage: NetworkImage(widget.image)
                ),
                InkWell(
                    onTap: (){
                      pickImageFromGallery();
                    },
                    child: Icon(Icons.camera_alt))
              ],
            ),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title: Container(
                width: 240,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: TextEditingController(text: widget.title),
                  decoration: InputDecoration(
                      hintText: 'subCategory name'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    widget.title=value;
                  },
                ),
              ),

            ),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.pink,),
              title: Container(
                width: 240,
                child: TextField(
                  style: TextStyle(color: Colors.deepPurpleAccent),
                  controller: TextEditingController(text: widget.title_arabic),
                  decoration: InputDecoration(
                      hintText: 'subCategory name in arabic'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    widget.title_arabic=value;
                  },
                ),
              ),

            ),
            FlatButton(
                onPressed: uploading?null:()=>updateCategoryInfo(widget.image),

                child: Text('update'.tr,style:  TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 16),)),

            // FlatButton(
            //     onPressed: uploading?null:()=>deleteCategoryInfoById(),
            //
            //     child: Text('delete'.tr,style:  TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 16),)),

            FlatButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ShowCategoryProducts(id: widget.id,)));
                },

                child: Text('showPrpducts'.tr,style:  TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 16),))
          ],
        ),
      ),
    );
  }
}
