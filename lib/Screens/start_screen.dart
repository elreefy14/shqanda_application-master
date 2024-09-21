import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Controllers/local_storage/app_language.dart';
import 'package:shqanda_application/Screens/home_screen.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Screens/sign_up_screen.dart';
import 'package:shqanda_application/Widgets/main_drawer.dart';
import 'package:shqanda_application/Widgets/make_page.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  PageController? _pageController;
  int currentIndex = 0;
   String _selectedLang = 'en';

  @override
  void initState() {
    _pageController = PageController(
        initialPage: 0
    );
    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: 6,
      width: isActive ? 30 : 6,
      margin: EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
          color: Color(0xFFF2C51D),
          borderRadius: BorderRadius.circular(5)
      ),
    );
  }
  List<Widget> _buildIndicator() {
    List<Widget> indicators = [];
    for (int i = 0; i<3; i++) {
      if (currentIndex == i) {
        indicators.add(_indicator(true));
      } else {
        indicators.add(_indicator(false));
      }
    }
    return indicators;
  }
     String ?myString;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
          appBar:AppBar(
      centerTitle: true,

    elevation: 0,
    backgroundColor: Color(0xFFF2C51D),
      title: Text('Welcome Screen'.tr),
    ),
      drawer: MainDrawer(),
      body: SafeArea(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            PageView(
              onPageChanged: (int page) {
                setState(() {
                  currentIndex = page;
                });
              },
              controller: _pageController,
              children: <Widget>[
                MakePage(
                    image: 'assets/group2.jpg',
                    title: 'The Italian experience with Luchra'.tr,
                  description: 'Try coffee, pizza and chocolate mixed with Italian culture'.tr,
                  function: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  },

                ),
                MakePage(
                  image: 'assets/3alima.png',
                  title: 'Shqanda'.tr,
                  description: 'The experience with Sheqanda is governed by quality and a proper diet'.tr,
                  function: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  },

                ),
                MakePage(
                  image: 'assets/welcome.jpg',
                  title: 'Welcome to Shekanda'.tr,
                  description: "Today's joy lies in products at the door of the house.".tr,
                  function: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
                  },
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(bottom: 100),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _buildIndicator(),
              ),
            )
          ],
        ),
      ),
      // body: SafeArea(
      //   child: Column(
      //     children: [
      //       Center(child: Text('اهلا بك في شقنده',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 18),)),
      //       Center(child: Text('   متخصص في التجاره الالكترونيه و ',style: TextStyle(color: Color(0xFF9E9E9E),fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),)),
      //       Center(child: Text('  بيعها بكل سهوله ',style: TextStyle(color: Color(0xFF9E9E9E),fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),)),
      //       Image.asset('assets/shqanda.PNG'),
      //       Container(
      //         margin: EdgeInsets.only(top:10),
      //         width: 200,
      //         height: 40,
      //         child: RaisedButton(
      //           color: Color(0xFFF2C51D),
      //           child:Text('ابدا الان',style: TextStyle(color: Colors.white,fontWeight: FontWeight.normal,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 14)),
      //           shape:OutlineInputBorder(
      //             borderRadius: BorderRadius.circular(15),
      //             borderSide: BorderSide.none,
      //           ),
      //             onPressed:(){}),
      //       ),
      //       InkWell(
      //         onTap:(){
      //           Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
      //         },
      //         child:Center(
      //           child:Text.rich(
      //               TextSpan(
      //                   text:' تمتلك حساب بالفعل؟', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Color(0xFF000000),),
      //                   children: <InlineSpan>[
      //                     TextSpan(
      //                       text: 'تسجيل الدخول',
      //                       style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Color(0xFFF2C51D),),
      //                     )
      //                   ]
      //               )
      //           ),
      //         ),
      //       ),
      //
      //     ],
      //   ),
      //
      // ),
    );
  }
}
