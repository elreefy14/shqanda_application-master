import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ProductBottomSheet extends StatefulWidget {
   String id;
   String image;
   String description_arabic;
   String longDescription;
   int orderNum;
   int price;
   Timestamp publishedDate;
   String shippingDuration;
   String status;
   String subCategory_id;
   String title;
   String title_arabic;
   String amount;
   ProductBottomSheet({required this.amount,required this.title_arabic,required this.status, required this.id,required this.image,required this.description_arabic,required this.longDescription,required this.orderNum,required this.price,required this.publishedDate,required this.shippingDuration,required this.subCategory_id,required this.title}) ;
  @override
  _ProductBottomSheetState createState() => _ProductBottomSheetState();
}
class _ProductBottomSheetState extends State<ProductBottomSheet> {
  // TextEditingController _descriptionTextEditingController=TextEditingController();
  // TextEditingController _titleTextEditingController=TextEditingController();
  // TextEditingController _priceTextEditingController=TextEditingController();
  // TextEditingController _shippingDurationTextEditingController=TextEditingController();
  // TextEditingController _amountTextEditingController=TextEditingController();
  // TextEditingController _orderNumberTextEditingController=TextEditingController();
  // TextEditingController _titleArabicTextEditingController=TextEditingController();
  File? file;
  bool uploading=false;
  updateProductInfo(String downloadUrl)async {
    final itemRef=FirebaseFirestore.instance.collection('items');
    itemRef.doc(widget.id).update({
     // 'product_id':widget.id,
      'title_arabic': widget.title_arabic.trim(),
      'title': widget.title.trim(),
      'thumbnailUrl':downloadUrl,
      'amount': widget.amount.trim(),
      'orderNum': widget.orderNum,
      'longDescription': widget.longDescription.trim(),
      'shippingDuration': widget.shippingDuration.trim(),
      'price': widget.price,
      'description_arabic': widget.description_arabic.trim()
    });
    Fluttertoast.showToast(msg: 'Product updated successfully',gravity: ToastGravity.CENTER,);
    SharedPreferences  prefs = await SharedPreferences.getInstance();
    prefs.setString('category_id', widget.id);

  }

  Future<void> deleteProductInfoById()async{
    final itemRef= await FirebaseFirestore.instance.collection('items');
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
                    child:Icon(Icons.camera_alt))
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
                      hintText: 'product name'.tr,
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
                      hintText: 'product name in arabic'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    widget.title_arabic=value;
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
                  controller: TextEditingController(text: widget.longDescription),
                  decoration: InputDecoration(
                      hintText: 'Description in English'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    widget.longDescription=value;
                  },
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
                  controller: TextEditingController(text: widget.description_arabic),
                  decoration: InputDecoration(
                      hintText: 'Description in arabic'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    widget.description_arabic=value;
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
                  controller: TextEditingController(text: widget.shippingDuration),
                  decoration: InputDecoration(
                      hintText: 'shippingInfo'.tr,
                      hintStyle:TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                    widget.shippingDuration=value;
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
                  controller: TextEditingController(text: '${widget.price}'),
                  decoration: InputDecoration(
                      hintText: 'price'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (  value){
                    widget.price=int.parse(value) ;
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
                  controller: TextEditingController(text: '${widget.orderNum}'),
                  decoration: InputDecoration(
                      hintText: 'orderNumber'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
                  onChanged: (value){
                   widget.orderNum=int.parse(value);
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
                  controller: TextEditingController(text: widget.amount),
                  decoration: InputDecoration(
                      hintText: 'amount'.tr,
                      hintStyle:   TextStyle(color: Colors.deepPurpleAccent),
                      border: InputBorder.none
                  ),
          onChanged: (value){
            widget.amount=value;
          },
                ),
              ),

            ),
            FlatButton(
                onPressed: uploading?null:()=>updateProductInfo(widget.image),

                child: Text('update'.tr,style:  TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 16),)),

            FlatButton(
                onPressed: uploading?null:()=>deleteProductInfoById(),

                child: Text('delete'.tr,style:  TextStyle(color: Colors.pink,fontWeight: FontWeight.bold,fontSize: 16),)),


          ],
        ),
      ),
    );
  }
}
