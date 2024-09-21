

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shqanda_application/Screens/home_page.dart';
import 'package:shqanda_application/Screens/home_screen.dart';
import 'package:shqanda_application/Screens/sign_in_screen.dart';
import 'package:shqanda_application/Widgets/mytextformField.dart';
import 'package:shqanda_application/Widgets/passwordtextformfield.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}
final textFieldFocusNode = FocusNode();
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
bool obserText = true;
final TextEditingController email = TextEditingController();
final TextEditingController userName = TextEditingController();
final TextEditingController phoneNumber = TextEditingController();
final TextEditingController password = TextEditingController();
final TextEditingController address = TextEditingController();
//final TextEditingController agentCode = TextEditingController();

bool isMale = true;
bool isLoading = false;
String ?myString;
String _selectedLang = 'en';
class _SignUpState extends State<SignUp> {
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
  void submit() async {
    UserCredential? result;
    try {
      setState(() {
        isLoading = true;
      });
      result = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: email.text, password: password.text);
      print(result);
    } on PlatformException catch (error) {
      var message = "Please Check Your Internet Connection".tr;
      if (error.message != null) {
        message = error.message!;
      }
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(message.toString()),
        duration: Duration(milliseconds: 600),
        backgroundColor: Theme.of(context).primaryColor,
      ));
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      setState(() {
        isLoading = false;
      });
      _scaffoldKey.currentState!.showSnackBar(SnackBar(
        content: Text(error.toString()),
        duration: Duration(milliseconds: 600),
        backgroundColor: Theme.of(context).primaryColor,
      ));

      print(error);
    }
    FirebaseFirestore.instance.collection("User").doc(result!.user!.uid).set({
      "UserName": userName.text,
      "UserId": result.user!.uid,
      "UserEmail": email.text,
      "UserAddress": address.text,
      "AgentCode": " ",
      "UserNumber": phoneNumber.text,
      "Discount": 0.5,
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('UserId', result.user!.uid );
    prefs.setString('UserEmail', email.text);
    prefs.setString('UserAddress',address.text );
    prefs.setString('UserNumber', phoneNumber.text);
    prefs.setString('UserName', userName.text);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (ctx) => HomePage()));
    setState(() {
      isLoading = false;
    });
  }

  void vaildation() async {
    if (userName.text.isEmpty &&
        email.text.isEmpty &&
        password.text.isEmpty &&
        phoneNumber.text.isEmpty &&
        address.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("All Flied Are Empty".tr),
        ),
      );
    } else if (userName.text.length < 6) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Name Must Be 6".tr),
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
    } else if (phoneNumber.text.length < 11 || phoneNumber.text.length > 11) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Phone Number Must Be 11".tr),
        ),
      );
    } else if (address.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Adress Is Empty".tr),
        ),
      );
    } else {
      submit();
    }
  }
  Widget _buildAllTextFormField() {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          MyTextFormField(
            name: "UserName".tr,
            controller: userName,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Email".tr,
            controller: email,
          ),
          SizedBox(
            height: 10,
          ),
          PasswordTextFormField(
            textFieldFocusNode: textFieldFocusNode,
            obserText: obserText,
            controller: password,
            name: "Password".tr,
            onTap: () {

            },
          ),
          SizedBox(
            height: 10,
          ),
          /* MyTextFormField(
            name: "Agent Code",
            controller: agentCode,
          ),
          SizedBox(
            height: 10,
          ),*/
          MyTextFormField(
            name: "Phone Number".tr,
            controller: phoneNumber,
          ),
          SizedBox(
            height: 10,
          ),
          MyTextFormField(
            name: "Address".tr,
            controller: address,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomPart() {
    return Directionality(
      textDirection: myString=='en'?TextDirection.ltr:TextDirection.rtl,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            _buildAllTextFormField(),
            SizedBox(
              height: 10,
            ),
            isLoading == false?
            Expanded(
              child: Container(
                width: 200,
                height: 60,
                child: RaisedButton(
                    child: Text('Create account'.tr,style: TextStyle(color: Colors.white,fontSize: 17),),
                    color: Color(0xFFF2C51D),
                    shape: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none
                    ),
                    onPressed: (){
                      vaildation();
                    }),
              ),
            )     : Center(
              child: CircularProgressIndicator(),
            ),

          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: ListView(
        children: [
          Container(
            height: 200,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  "Create account".tr,
                  style: TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: 500,
            child: _buildBottomPart(),
          ),
          // InkWell(
          //   onTap:(){
          //     Navigator.push(context, MaterialPageRoute(builder: (context)=>Login()));
          //   },
          //   child:Center(
          //     child:Text.rich(
          //         TextSpan(
          //             text:' تمتلك حساب بالفعل؟', style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Color(0xFF000000),),
          //             children: <InlineSpan>[
          //               TextSpan(
          //                 text: 'تسجيل الدخول',
          //                 style: TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color: Color(0xFFF2C51D),),
          //               )
          //             ]
          //         )
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}
