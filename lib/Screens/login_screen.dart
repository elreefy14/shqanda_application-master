import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shqanda_application/Admin/admin_login_screen.dart';
import 'package:shqanda_application/Screens/home_screen.dart';
import 'package:shqanda_application/Screens/sign_up_screen.dart';
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}
final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
bool isLoading = false;
String p =
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

RegExp regExp = new RegExp(p);
final TextEditingController email = TextEditingController();
final TextEditingController userName = TextEditingController();
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
final TextEditingController password = TextEditingController();
bool obserText = true;
class _LoginScreenState extends State<LoginScreen> {
  void submit(context) async {
    try {
      setState(() {
        isLoading = true;
      });
      UserCredential result = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
          email: email.text, password: password.text);
      print(result);
    } on PlatformException catch (error) {
      var message = "Please Check Your Internet Connection ";
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
        content: Text("Wrong Email or Paassword"),
        duration: Duration(milliseconds: 2000),
        backgroundColor: Theme.of(context).primaryColor,
      ));
    }
    setState(() {
      isLoading = false;
    });
  }

  void vaildation() async {
    if (email.text.isEmpty && password.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Both Flied Are Empty"),
        ),
      );
    } else if (email.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Email Is Empty"),
        ),
      );
    } else if (!regExp.hasMatch(email.text)) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Please Try Vaild Email"),
        ),
      );
    } else if (password.text.isEmpty) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Password Is Empty"),
        ),
      );
    } else if (password.text.length < 8) {
      _scaffoldKey.currentState!.showSnackBar(
        SnackBar(
          content: Text("Password  Is Too Short"),
        ),
      );
    } else {
      submit(context);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        centerTitle: true,
        title: Text('Log In'),
      ),
      body: SingleChildScrollView(
        child: Card(
          shape: OutlineInputBorder(borderRadius: BorderRadius.circular(10),borderSide: BorderSide.none),
          child: Container(
            padding: const EdgeInsets.all(20.0),
            margin:  EdgeInsets.all(20.0),
            height: MediaQuery.of(context).size.height*.5,
            child: Form(
              key: _formKey,
              child: Container(

                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: email,
                        decoration: InputDecoration(
                            suffixIcon: Icon(Icons.email),
                            border: OutlineInputBorder(
                              borderRadius:BorderRadius.circular(15),
                            ),
                            hintText:'email'
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: TextFormField(
                        controller: password,
                        decoration:InputDecoration(
                            suffixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(
                              borderRadius:BorderRadius.circular(15),
                            ),
                            hintText: 'password'
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                          onTap: (){},
                            child: Text('Forget Password?',style: TextStyle(color: Colors.deepOrange),)),
                        InkWell(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp()));
                            },
                            child: Text('Create account',style: TextStyle(color: Colors.deepOrange),)),
                      ],

                    ),
                    RaisedButton(
                        color: Colors.deepOrange,
                        shape: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none
                        ),
                        child: Text('Login',style: TextStyle(color: Colors.white),),
                        onPressed: (){
                          vaildation();
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                        }),

                    // SizedBox(height: 30,),
                    // Container(
                    //   height: 4,
                    //   color: Colors.deepOrange,
                    // ),
                    // SizedBox(height: 30,),
                    // FlatButton.icon(onPressed: (){
                    //   Navigator.push(context, MaterialPageRoute(builder: (context)=>AdminLoginScreen()));
                    // },
                    //     icon: Icon(Icons.nature_people,color: Colors.deepOrange,),
                    //     label: Text('Iam Admin',style: TextStyle(color: Colors.deepOrange,fontWeight: FontWeight.bold),))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
