import 'routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled1/loginScreen.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/mainscreen.dart';
import 'package:untitled1/progressDialog.dart';

class registrationScreen extends StatelessWidget {
  static const String idScreen = "register";

  TextEditingController nameTextEditingConntroller = TextEditingController();
  TextEditingController emailTextEditingConntroller = TextEditingController();
  TextEditingController aadharTextEditingConntroller = TextEditingController();
  TextEditingController passwordTextEditingConntroller = TextEditingController();
  TextEditingController phoneTextEditingConntroller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/3115.png"),
                width: 390.0,
                height: 250.0,
                alignment: Alignment.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Register",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingConntroller,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          labelText: "Name",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0
                          )
                      ),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: emailTextEditingConntroller,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                          labelText: "Email",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0
                          )
                      ),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: aadharTextEditingConntroller,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                          labelText: "Aadhar Card Number",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0
                          )
                      ),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingConntroller,
                      obscureText: true,
                      decoration: InputDecoration(
                          labelText: "Password",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0
                          )
                      ),
                    ),
                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingConntroller,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          labelText: "Phone Number",
                          labelStyle: TextStyle(
                            fontSize: 14.0,
                          ),
                          hintStyle: TextStyle(
                              color: Colors.grey,
                              fontSize: 10.0
                          )
                      ),
                    ),
                    SizedBox(height: 1.0,),
                    TextButton(
                      child: Text(
                        'Register', style: TextStyle(fontSize: 20.0),),
                      style: TextButton.styleFrom(
                        primary: Colors.white,
                        backgroundColor: Colors.black,
                        shadowColor: Colors.white,
                        elevation: 5,
                      ),
                      onPressed: () {
                        if (nameTextEditingConntroller.text.length < 3) {
                          displayToastMessage(
                              "Name must be atleast 3 characters long",
                              context);
                        }
                        else if (!emailTextEditingConntroller.text.contains("@")) {
                          displayToastMessage("Invalid email address", context);
                        }
                        else if (phoneTextEditingConntroller.text.isEmpty) {
                          displayToastMessage(
                              "Phone number is mandatory", context);
                        }
                        else if (aadharTextEditingConntroller.text.isEmpty) {
                          displayToastMessage(
                              "Aadhar card number is mandatory", context);
                        }
                        else if (passwordTextEditingConntroller.text.length < 6) {
                          displayToastMessage(
                              "Password must be atleast 6 characters long",
                              context);
                        }
                        else {
                          registerNewUser(context);
                        }
                      },
                    ),
                    TextButton(
                      child: Text('Already have an account? Sign in',
                        style: TextStyle(
                            fontSize: 17.0, fontFamily: "Brant Bold"),),
                      style: TextButton.styleFrom(
                        primary: Colors.black,
                        backgroundColor: Colors.white,
                        shadowColor: Colors.blue,
                        elevation: 5,
                      ),
                      onPressed: () {
                        Navigator.pushNamedAndRemoveUntil(
                            context, LoginScreen.idScreen, (route) => false);
                      },
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async
  {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context)
        {return ProgressDialog(message: "Creating New Account",);}
    );

    final User firebaseUser = (await _firebaseAuth
        .createUserWithEmailAndPassword(email: emailTextEditingConntroller.text,
        password: passwordTextEditingConntroller.text).catchError((errMsg){Navigator.pop(context);
          displayToastMessage("Error:" +errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) //user created
        {

          Map userDataMap = {
            "name": nameTextEditingConntroller.text.trim(),
            "email": emailTextEditingConntroller.text.trim(),
            "phone": phoneTextEditingConntroller.text.trim(),
            "aadhar": aadharTextEditingConntroller.text.trim(),
          };
          usersRef.child(firebaseUser.uid).set(userDataMap);
          displayToastMessage("Account Created", context);

          Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);

        }
    else {Navigator.pop(context);
      displayToastMessage("New user account has not been created", context);

    }
  }

  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
