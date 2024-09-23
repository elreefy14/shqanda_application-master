

import 'package:auth_buttons/auth_buttons.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_login_facebook/flutter_login_facebook.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Admin/admin_login_screen.dart';
import 'package:shqanda_application/Admin/admin_panel.dart';
import 'package:shqanda_application/Controllers/local_storage/app_language.dart';
import 'package:shqanda_application/Screens/home_page.dart';
// import 'package:shqanda_application/Screens/home_page.dart';
import 'package:shqanda_application/Screens/home_screen.dart';
import '../Widgets/mybutton.dart';
import 'package:shqanda_application/Screens/sign_up_screen.dart';
import 'package:shqanda_application/Widgets/mytextformField.dart';
import 'package:shqanda_application/Widgets/passwordtextformfield.dart';

class Login extends StatefulWidget {
  // final String myString;
  //
  // const Login({ required this.myString}) ;
  @override
  _LoginState createState() => _LoginState();
}

final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
int _value = 1;
 String ?myString;
 String _selectedLang = 'en';

String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
final TextEditingController email = TextEditingController();
final TextEditingController userName = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final TextEditingController password = TextEditingController();
late bool obserText ;
class _LoginState extends State<Login> {
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
    obserText=false;
    setState(() {
      _loadCounter();
    });
  }
  final textFieldFocusNode = FocusNode();

  GoogleSignIn _googleSignIn = GoogleSignIn();
 // FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  //FacebookLogin _facebookLogin = FacebookLogin();
  User? user ;
  // signInWithGoogle() async{
  //   GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
  //   GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;
  //   AuthCredential authCredential = GoogleAuthProvider.credential(accessToken: googleSignInAuthentication.accessToken);
  //   UserCredential authResult = await firebaseAuth.signInWithCredential(authCredential);
  //   setState(() {
  //     user = authResult.user;
  //     try {
  //
  //     }catch(e){
  //       print(e.toString());
  //     }
  //   });
  // }
  FirebaseAuth _auth = FirebaseAuth.instance;

  void submit(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text, password: password.text);
      print(result);
      // SharedPreferences prefs= await SharedPreferences.getInstance();
      // prefs.setString('auth', '${result}');
    } on PlatformException catch (error) {
      var message = "Please Check Your Internet Connection".tr;
      if (error.message != null) {
        message = error.message!;
      }
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text(message.toString()),
          duration: Duration(milliseconds: 2000),
          backgroundColor: Theme.of(context).primaryColor,
        ),
      );
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      print("error: " + error.toString());
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text("Wrong Email or Paassword".tr),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }

    setState(() {
      isLoading = false;
    });
  }
   bool isSigned = false ;
  // Future signInWithFacebook(FacebookLoginResult _result)async{
  //   FacebookAccessToken? _accessToken = _result.accessToken;
  //   AuthCredential _authCredential = FacebookAuthProvider.credential(_accessToken!.token);
  //   var facebookUser = await firebaseAuth.signInWithCredential(_authCredential);
  //   setState(() {
  //     user = facebookUser.user ;
  //     isSigned = true ;
  //   });
  // }
  FacebookLogin _facebookLogin = FacebookLogin();

  // Future _handleLogin ()async {
  //   FacebookLoginResult _result = await _facebookLogin.logIn(customPermissions: ['email']);
  //   switch (_result.status){
  //     case FacebookLoginStatus.cancelledByUser:
  //       print('cancel by user');
  //       break;
  //     case FacebookLoginStatus.error:
  //       print('error');
  //       break;
  //     case FacebookLoginStatus.loggedIn:
  //       await signInWithFacebook(_result);
  //       break;
  //   }
  // }

  bool isLoggedIn = false;

  Future<UserCredential> signInWithGoogle() async {
    // Initiate the auth procedure
    final GoogleSignInAccount? googleUser = await GoogleSignIn(scopes: <String>["email"]).signIn();
    // fetch the auth details from the request made earlier
    final GoogleSignInAuthentication googleAuth = await googleUser!.authentication;
    // Create a new credential for signing in with google
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    // Get.to(HomePage());
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }
  signInWithFacebook() async {
    final fb = FacebookLogin();
    // Log in
    final res = await fb.logIn(permissions: [
      FacebookPermission.publicProfile,
      FacebookPermission.email,
    ]);
    // Check result status
    switch (res.status) {
      case FacebookLoginStatus.success:
     //   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
        // The user is suceessfully logged in
      // Send access token to server for validation and auth
        final FacebookAccessToken? accessToken = res.accessToken;
        final AuthCredential authCredential = FacebookAuthProvider.credential(accessToken?.token??'');
        final result = await FirebaseAuth.instance.signInWithCredential(authCredential);
        // Get profile data from facebook for use in the app
        final profile = await fb.getUserProfile();
        print('Hello, ${profile?.name}! You ID: ${profile?.userId}');
        // Get user profile image url
        final imageUrl = await fb.getProfileImageUrl(width: 100);
        print('Your profile image: $imageUrl');
        // fetch user email
        final email = await fb.getUserEmail();
        // But user can decline permission
        if (email != null) print('And your email is $email');
        break;
      case FacebookLoginStatus.cancel:
      // In case the user cancels the login process
        break;
      case FacebookLoginStatus.error:
      // Login procedure failed
        print('Error while log in: ${res.error}');
        break;
    }
  }
  //
  //  facebookSignInMethod() async {
  //   final AccessToken result = (await FacebookAuth.instance.login()) as AccessToken;
  //   final OAuthCredential facebookAuthCredential =
  //   FacebookAuthProvider.credential(result.token);
  //   await _auth.signInWithCredential(facebookAuthCredential).then((user) {
  //   });
  // }
  void vaildation()async{
    if (email.text.isEmpty && password.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content:Text("Both Fields Are Empty".tr),
        ),
      );
    } else if (email.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Email Is Empty".tr),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Please Try Vaild Email".tr),
        ),
      );
    } else if (password.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Password Is Empty".tr),
        ),
      );
    } else if (password.text.length < 8) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short".tr),
        ),
      );
    } else{
      submit(context);
    //  Get.to(HomePage());
    }
  }

  Widget _buildAllPart() {
    return Expanded(
      child: Container(
margin: EdgeInsets.only(top: 50),
        width: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Login'.tr,
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 100.0),
                child: MyTextFormField(
                  name: "اسم المستخدم",
                  controller: email,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 20),
              //   child: PasswordTextFormField(
              //     textFieldFocusNode: textFieldFocusNode,
              //     obserText: obserText,
              //     name: "Password".tr,
              //     controller: password,
              //     onTap: () {
              //
              //    obserText =!obserText;
              //
              //     //  FocusScope.of(context).unfocus();
              //     },
              //   ),
              // ),
              SizedBox(
                height: 90,
              ),
              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: Row(
              //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //     children: [
              //       InkWell(
              //           onTap: (){},
              //           child: Text('Forget Password?'.tr,style: TextStyle(color: Colors.deepOrange),)),
              //       InkWell(
              //           onTap: (){
              //             Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
              //           },
              //           child: Text('Create account'.tr,style: TextStyle(color: Colors.deepOrange),)),
              //     ],
              //
              //   ),
              // ),
              isLoading == false?
              Container(
                height: 50,
                width: 200,
                child: RaisedButton(
                    child: Text('Login'.tr,style: TextStyle(color: Colors.white),),

                    color: Color(0xFFF2C51D),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none
                    ),
                    onPressed: () async {
                      SharedPreferences prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isUserSignedIn', true);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage()));
                      //vaildation();
                }),
              ): Center(
            child: CircularProgressIndicator(),
    ),
              // InkWell(
              //   onTap:(){
              //     Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
              //   },
              //   child:Center(
              //     child:Text.rich(
              //         TextSpan(
              //             text:'Have not an account?'.tr, style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Color(0xFF000000),),
              //             children: <InlineSpan>[
              //               TextSpan(
              //                 text: 'Create account'.tr,
              //                 style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Color(0xFFF2C51D),),
              //               )
              //             ]
              //         )
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: 10),
              //   child: Text('OR With',style: TextStyle(color: Color(0xFFF2C51D),fontSize: 16,fontWeight: FontWeight.bold),),
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: 10),
              //   child: GoogleAuthButton(
              //     onPressed: () async{
              //       signInWithGoogle();
              //       // Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomePage()));
              //     },
              //     darkMode: false,
              //     style:AuthButtonStyle(
              //       iconType: AuthIconType.outlined,
              //     ),
              //   ),
              // ),
              // Container(
              //   margin: EdgeInsets.only(top: 20),
              //   child: FacebookAuthButton(
              //     onPressed: () async{
              //       facebookSignInMethod();
              //
              //     },
              //     darkMode: false,
              //     style:AuthButtonStyle(
              //       iconType:AuthIconType.outlined,
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: myString=='en'?TextDirection.ltr:TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          actions: [
            // Container(
            //   margin: EdgeInsets.only(left: 20,right: 20),
            //   child: GetBuilder<AppLanguage>(
            //     init: AppLanguage(),
            //     builder: (controller) {
            //       return Container(
            //         // width: double.infinity,
            //         // height: 50,
            //         child: Center(
            //           child: DropdownButton(
            //             icon: Icon(Icons.language,color: Color(0xFFF2C51D),),
            //             iconEnabledColor: Colors.white,
            //             underline: SizedBox(),
            //             value: myString,
            //             onChanged: (value) async {
            //               controller.changeLanguage('${value}');
            //               setState(() {
            //                 _selectedLang = '${value}';
            //               });
            //               Get.updateLocale(Locale(value.toString()));
            //               SharedPreferences prefs =
            //               await SharedPreferences.getInstance();
            //               prefs.setString('value', '${value}');
            //               //  print(value);
            //               SharedPreferences x =
            //               await SharedPreferences.getInstance();
            //               setState(() {
            //                 myString = x.getString('value');
            //                 print("shared:$myString");
            //               });
            //             },
            //             items: [
            //               DropdownMenuItem(
            //                   child: Container(
            //                     height: 30,
            //                     width: 100,
            //                     color: Color(0xFFF2C51D),
            //                     child: Center(
            //                       child: Text(
            //                         'English',
            //                         style: TextStyle(
            //                             color: Colors.white,
            //                             fontWeight: FontWeight.bold,
            //                             fontSize: 15),
            //                       ),
            //                     ),
            //                   ),
            //                   value: 'en'),
            //               DropdownMenuItem(
            //                   child: Container(
            //                       height: 30,
            //                       width: 100,
            //                       color: Color(0xFFF2C51D),
            //                       child: Center(
            //                           child: Text('العربيه',
            //                               style: TextStyle(
            //                                   color: Colors.white,
            //                                   fontWeight:
            //                                   FontWeight.bold,
            //                                   fontSize: 15)))),
            //                   value: 'ar')
            //             ],
            //           ),
            //         ),
            //       );
            //     },
            //   ),
            // )
          ],
          backgroundColor: Colors.white,
        ),
        key: _scaffoldKey,
        body: Stack(
          children: [
            Form(
              key: _formKey,
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                 child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _buildAllPart(),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 130,right: 20,left: 170 ),
              width: 200,
              height: 50,
              child:Center(child: Text('User'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),)),
              decoration:BoxDecoration(

                  color:Color(0xFFF2C51D),
                borderRadius:BorderRadius.circular(15)
              ),
            ),
            Container(
              margin:EdgeInsets.only(top:130,right:180,left: 20),
              width:200,
              height:50,
              child:InkWell(
                onTap: (){
                  Navigator.push(context,MaterialPageRoute(builder:(context)=>AdminLoginScreen()));
                },
                child: Center(
                    child:Text('Workers in Shekanda'.tr,style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Noto Sans Arabic ExtraCondensed',fontSize: 12),)),
              ),
              decoration:BoxDecoration(
                  color:Color(0xFF9E9E9E),
                  borderRadius: BorderRadius.circular(15)
              ),
            )
          ],
        ),
      ),
    );
  }
}