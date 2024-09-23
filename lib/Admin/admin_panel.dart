import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/Category_screen.dart';
import 'package:shqanda_application/Admin/cart_page.dart';
import 'package:shqanda_application/Admin/order_screen.dart';
import 'package:shqanda_application/Admin/user_message_screen.dart';
import 'add_category_screen.dart';
import 'upload_item_screen.dart';
class AdminPanel extends StatefulWidget {
  @override
  _AdminPanelState createState() => _AdminPanelState();
}
class _AdminPanelState extends State<AdminPanel> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFF2C51D),
        centerTitle: true,
        title: Text('Admin Panel'.tr),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(top: 40),
          child: Center(
            child: Column(
              children: [
                RaisedButton(onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddCategoryScreen()));

                },
                  child: Text('Add Category'.tr),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                RaisedButton(onPressed:(){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>CategoryScreen()));
                },
                  child: Text('Show category'.tr),
                  shape: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                RaisedButton(onPressed:()async{
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>CartPage()));
                },
                  child:Text('Show Orders'.tr),
                  shape:OutlineInputBorder(
                    borderSide:BorderSide.none,
                    borderRadius:BorderRadius.circular(14),
                  ),
                ),
                RaisedButton(onPressed:()async{
                  Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>UserMessageScreen()));
                },
                  child:Text('Show Messages'.tr),
                  shape:OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
