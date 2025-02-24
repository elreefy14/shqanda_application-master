// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_utils/src/extensions/internacionalization.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
//
//
// class MainDrawer extends StatefulWidget {
//
//   @override
//   _MainDrawerState createState() => _MainDrawerState();
// }
//
// class _MainDrawerState extends State<MainDrawer> {
//   //
//   // Future<void> _signOut() async {
//   //   GoogleSignIn _googleSignIn = GoogleSignIn();
//   //
//   //   await _auth.signOut();
//   //   await _googleSignIn.signOut();
//   // }
//
//   User? loggedUser;
//   bool homeColor = true;
// bool cartColor=false;
//   bool checkoutColor = false;
//   bool aboutColor = false;
//   bool contactUsColor = false;
//   bool profileColor = false;
//   MediaQueryData? mediaQuery;
//   //
//   // getUser()async{
//   //
//   //     SharedPreferences prefs = await SharedPreferences.getInstance();
//   //     id= prefs.getString('UserId');
//   //     email= prefs.getString('UserEmail');
//   //     username=prefs.getString('UserName');
//   //
//   //
//   //
//   // }
//   @override
//   void initState(){
//     // TODO:implement initState
//     super.initState();
//   }
// FirebaseAuth _auth = FirebaseAuth.instance;
//   @override
//   Widget build(BuildContext context){
//     return Drawer(
//
//       child: ListView(
//         children: [
//           DrawerHeader(child: Container(
//             height: 100,
//             child: ListTile(
//
//               leading: CircleAvatar(
//                 backgroundColor: Colors.grey,
//                 backgroundImage: AssetImage('assets/userImage.png'),
//               ),
//               title: Text('${_auth.currentUser?.email}'),
//             ),
//           )),
//           ListTile(
//             selected:homeColor,
//             onTap:(){
//               setState((){
//                 homeColor=true;
//                 contactUsColor=false;
//                 checkoutColor=false;
//                 aboutColor=false;
//                 profileColor=false;
//               });
//             },
//             leading:Icon(Icons.home),
//             title:Text('Home Page'.tr),
//           ),
//           ListTile(
//             selected: checkoutColor,
//             onTap:()async {
//               setState(() {
//                 checkoutColor = true;
//                 contactUsColor = false;
//                 homeColor = false;
//                 profileColor = false;
//                 aboutColor = false;
//               });
//               Navigator.push(context,MaterialPageRoute(builder: (context)=>MyCart()));
//               // SharedPreferences prefs = await SharedPreferences.getInstance();
//               // var product_id=prefs.getString('productId');
//               // var amount=prefs.getString('productAmount');
//               // var name = prefs.getString('ProductName');
//               // var image = prefs.getString('productImage');
//               // var quantity = prefs.getInt('productQuantity');
//               // var price = prefs.getInt('productPrice');
//               // var id=prefs.getString('userId');
//               //
//               // Navigator.of(context).pushReplacement(
//               //     MaterialPageRoute(builder: (ctx) => CartScreen(
//               //       image: '${image}',
//               //       quantity:quantity!,
//               //       price: price!,
//               //       user_id: '${id}',
//               //       product_id: '${product_id}',
//               //       name: '${name}',
//               //       amount: '${amount}',
//               //
//               //
//               //
//               //
//               //
//               //
//               //     )));
//             },
//             leading: Icon(Icons.shopping_cart),
//             title: Text('My Cart'.tr),
//           ),
//           // ListTile(
//           //   selected: cartColor,
//           //   onTap: () {
//           //     setState(() {
//           //       checkoutColor = true;
//           //       contactUsColor = false;
//           //       homeColor = false;
//           //       profileColor = false;
//           //       aboutColor = false;
//           //     });
//           //     Navigator.of(context).push(
//           //         MaterialPageRoute(builder: (ctx) => OrdersScreen()));
//           //   },
//           //   leading:Icon(Icons.article_outlined),
//           //   title: Text('My Orders'.tr),
//           // ),
//           ListTile(
//             leading: Icon(Icons.person_rounded),
//             title: Text('Profile'.tr),
//             onTap: ()async{
//               SharedPreferences prefs = await SharedPreferences.getInstance();
//              var id= prefs.getString('UserId');
//              var email= prefs.getString('UserEmail');
//              var  username=prefs.getString('UserName');
//              var phoneNumber=prefs.getString('UserNumber');
//              var userAddress=prefs.getString('UserAddress');
//              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile(
//                userName: '${username}',
//                userAddress: '${userAddress}',
//                userEmail: '${email}',
//                userId: '${id}',
//                userNumber: '${phoneNumber}',
//              )));
//               // FirebaseAuth.instance.signOut();
//               // Navigator.of(context).push(
//               //     MaterialPageRoute(builder: (ctx) => Login()));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.contact_phone_rounded),
//             title: Text('ContactUs'.tr),
//             onTap: (){
//               Navigator.push(context,MaterialPageRoute(builder: (context)=>ContactUs()));
//               // FirebaseAuth.instance.signOut();
//               // Navigator.of(context).push(
//               //     MaterialPageRoute(builder: (ctx) => Login()));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.info),
//             title: Text('About'.tr),
//             onTap: (){
//               Navigator.push(context,MaterialPageRoute(builder: (context)=>StartScreen()));
//
//               // FirebaseAuth.instance.signOut();
//               // Navigator.of(context).push(
//               //     MaterialPageRoute(builder: (ctx) => Login()));
//             },
//           ),
//           ListTile(
//             leading: Icon(Icons.logout),
//             title: Text('Logout'.tr),
//              onTap: (){
//           //     SharedPreferences prefs= await SharedPreferences.getInstance();
//           // FirebaseAuth string = prefs.getString('auth') as FirebaseAuth;
//           // string.signOut();
//               // _auth.signOut();
//                FirebaseAuth.instance.signOut();
//               // Navigator.of(context).push(
//               //     MaterialPageRoute(builder: (ctx) => Login()));
//             },
//           )
//
//         ],
//       ),
//     );
//   }
// }
