import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/show_category_products.dart';
import 'package:shqanda_application/Admin/show_sub_categories.dart';

class UpdateCategory extends StatefulWidget {
   String id;
   String title;
   String title_arabic;
   String image;
   UpdateCategory({ required this.id,required this.image,required this.title,required this.title_arabic});
  @override
  _UpdateCategoryState createState() => _UpdateCategoryState();
}
class _UpdateCategoryState extends State<UpdateCategory> {
  static late  SharedPreferences sharedPreferences;
  //TextEditingController _titleTextEditingController=TextEditingController();
 // TextEditingController _titleArabicTextEditingController=TextEditingController();
  File? file;
  bool uploading=false;
  // update category info
updateCategoryInfo(String downloadUrl)async {
    final itemRef=FirebaseFirestore.instance.collection('categories');
    itemRef.doc(widget.id).update({
    //  'category_id':widget.id,
      'title':widget.title.trim(),
      'title_arabic':widget.title_arabic.trim(),
      'thumbnailUrl':downloadUrl
    });
    Fluttertoast.showToast(msg: 'Category updated successfully',gravity: ToastGravity.CENTER,);

    SharedPreferences  prefs = await SharedPreferences.getInstance();
    prefs.setString('category_id', widget.id);
    setState(() {
      uploading=false;
    });
  }
 Future<void> deleteCategoryInfoById()async{
      final itemRef= await FirebaseFirestore.instance.collection('categories');
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
              leading: Icon(Icons.perm_device_information,color: Colors.deepOrange,),
              title: Container(
                width: 240,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: TextEditingController(text: widget.title),
                  onChanged: (value){
                    widget.title=value;
                  },
                  decoration: InputDecoration(
                      hintText: 'category name'.tr,
                      hintStyle:   TextStyle(color: Colors.black),
                      border: InputBorder.none
                  ),
                ),
              ),

            ),
            ListTile(
              leading: Icon(Icons.perm_device_information,color: Colors.deepOrange,),
              title: Container(
                width: 240,
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  controller: TextEditingController(text: widget.title_arabic),
                  decoration: InputDecoration(
                      hintText: 'category name in arabic'.tr,
                      hintStyle:   TextStyle(color: Colors.black),
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

                child: Text('update'.tr,style:  TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize: 16),)),

            // FlatButton(
            //     onPressed: uploading?null:()=>deleteCategoryInfoById(),
            //
            //     child: Text('delete'.tr,style:  TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize: 16),)),

            FlatButton(
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ShowSubCategories(
                  id: widget.id,
                )));
              },

                child: Text('showSubCategories'.tr,style:  TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold,fontSize: 16),))
          ],
        ),
      ),
    );
  }
}
