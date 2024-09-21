import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AboutScreen extends StatefulWidget {

  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen> {
  String ?myString;
  _loadCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      myString = prefs.getString('value');
      print("shared:$myString");
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      _loadCounter();
    });
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myString=='en'?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('About'.tr),
        backgroundColor: Color(0xFFF2C51D),
      ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset('assets/welcome.jpg',height: 250,width: double.infinity,fit: BoxFit.cover,),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Row(
                  children: [
                    Text('About Shqanda'.tr,style: TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
              ListTile(
                title: Text('1-Discovers products that do not exist.'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),

              ),
              ListTile(
                title: Text('2-Excellent quality.'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),

              ),
              ListTile(
                title: Text('3- A place responsible for the products it consumes.'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),

              ),
              ListTile(
                title: Text('4- A place oriented with product quality and history.'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),

              ),
              ListTile(
                title: Text('5- A place where you care about the societal environment, the people who make the products, I mean, because the products are excellent.'.tr,style: TextStyle(color: Colors.black,fontSize: 17,fontWeight: FontWeight.normal),),

              )

            ],
          ),
        ),
      ),
    );
  }
}
