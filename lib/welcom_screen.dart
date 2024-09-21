// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_state_manager/src/simple/get_state.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:shqanda_application/Admin/admin_login_screen.dart';
// import 'package:shqanda_application/Controllers/local_storage/app_language.dart';
// import 'package:shqanda_application/Delivery/delivery_login.dart';
// import 'package:shqanda_application/Screens/sign_in_screen.dart';
//
// class WelcomScreen extends StatefulWidget {
//
//   @override
//   _WelcomScreenState createState() => _WelcomScreenState();
// }
//
// class _WelcomScreenState extends State<WelcomScreen> with TickerProviderStateMixin {
//   String _selectedLang = 'en';
//   String ?myString;
//   final DecorationTween decorationTween = DecorationTween(
//     begin: BoxDecoration(
//       color: const Color(0xFFFFFFFF),
//       border: Border.all(style: BorderStyle.none),
//       borderRadius: BorderRadius.circular(60.0),
//       shape: BoxShape.rectangle,
//       boxShadow: const <BoxShadow>[
//         BoxShadow(
//           color: Color(0x66666666),
//           blurRadius: 10.0,
//           spreadRadius: 3.0,
//           offset: Offset(0, 6.0),
//         )
//       ],
//     ),
//     end: BoxDecoration(
//       color: const Color(0xFFFFFFFF),
//       border: Border.all(
//         style: BorderStyle.none,
//       ),
//       borderRadius: BorderRadius.zero,
//       // No shadow.
//     ),
//   );
//
//   late final AnimationController _controller = AnimationController(
//     vsync: this,
//     duration: const Duration(seconds: 3),
//   )..repeat(reverse: true);
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//     appBar:AppBar(
//       centerTitle: true,
//       actions: [
//         Container(
//           margin: EdgeInsets.only(left: 20,right: 20),
//           child: GetBuilder<AppLanguage>(
//             init: AppLanguage(),
//             builder: (controller) {
//               return Container(
//                 // width: double.infinity,
//                 // height: 50,
//                 child: Center(
//                   child: DropdownButton(
//                     icon: Icon(Icons.language),
//                     iconEnabledColor: Colors.white,
//                     underline: SizedBox(),
//                     value: myString,
//                     onChanged: (value) async {
//                       controller.changeLanguage('${value}');
//                       setState(() {
//                         _selectedLang = '${value}';
//                       });
//                       Get.updateLocale(Locale(value.toString()));
//                       SharedPreferences prefs =
//                       await SharedPreferences.getInstance();
//                       prefs.setString('value', '${value}');
//                       //  print(value);
//                       SharedPreferences x =
//                       await SharedPreferences.getInstance();
//                       setState(() {
//                         myString = x.getString('value');
//                         print("shared:$myString");
//                       });
//                     },
//                     items: [
//                       DropdownMenuItem(
//                           child: Container(
//                             height: 30,
//                             width: 100,
//                             color: Colors.deepOrange,
//                             child: Center(
//                               child: Text(
//                                 'English',
//                                 style: TextStyle(
//                                     color: Colors.white,
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15),
//                               ),
//                             ),
//                           ),
//                           value: 'en'),
//                       DropdownMenuItem(
//                           child: Container(
//                               height: 30,
//                               width: 100,
//                               color: Colors.deepOrange,
//                               child: Center(
//                                   child: Text('العربيه',
//                                       style: TextStyle(
//                                           color: Colors.white,
//                                           fontWeight:
//                                           FontWeight.bold,
//                                           fontSize: 15)))),
//                           value: 'ar')
//                     ],
//                   ),
//                 ),
//               );
//             },
//           ),
//         )
//       ]
//       ,
//     backgroundColor: Colors.deepOrange,
//       title: Text('Welcome Screen'.tr),
//     ),
//       body:Container(
//         margin: EdgeInsets.only(top: 30),
//         child: Column(
//           children:[
//             InkWell(
//               onTap: (){
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AdminLoginScreen(myString: '${myString}',)));
//               },
//               child: Container(
//                 color: Colors.white,
//                 child:Center(
//                   child:DecoratedBoxTransition(
//                     position: DecorationPosition.background,
//                     decoration: decorationTween.animate(_controller),
//                     child:Container(
//                       width:300,
//                       height: 200,
//                       padding:  EdgeInsets.all(10),
//                       child:  Center(child: Text('Login As Admin'.tr,style: TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold),)),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: (){
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>Login(myString:'${myString}',)));
//               },
//               child: Container(
//                 margin: EdgeInsets.only(top: 20),
//                 color: Colors.white,
//                 child:Center(
//                   child:DecoratedBoxTransition(
//                     position: DecorationPosition.background,
//                     decoration: decorationTween.animate(_controller),
//                     child:Container(
//                       width:300,
//                       height: 200,
//                       padding:  EdgeInsets.all(10),
//                       child:  Center(child: Text('Login As User'.tr,style: TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold),)),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             InkWell(
//               onTap: (){
//                 Navigator.pushReplacement(context, MaterialPageRoute(builder:(context)=>DeliveryLogin(myString: '${myString}',)));
//               },
//               child: Container(
//                 margin: EdgeInsets.only(top: 20),
//                 color: Colors.white,
//                 child:Center(
//                   child:DecoratedBoxTransition(
//                     position: DecorationPosition.background,
//                     decoration: decorationTween.animate(_controller),
//                     child:Container(
//                       width:300,
//                       height: 200,
//                       padding:  EdgeInsets.all(10),
//                       child:  Center(child: Text('Login As Delivery Boy'.tr,style: TextStyle(color: Colors.deepOrange,fontSize: 18,fontWeight: FontWeight.bold),)),
//                     ),
//                   ),
//                 ),
//               ),
//             )
//           ],
//         ),
//       ),
//
//     );
//   }
// }
