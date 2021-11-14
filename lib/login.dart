import 'routes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:untitled1/main.dart';
import 'package:untitled1/mainscreen.dart';
import 'package:untitled1/progressDialog.dart';
import 'package:untitled1/registrationScreen.dart';

class LoginScreen extends StatelessWidget {
  static const String idScreen = "login";
  TextEditingController emailTextEditingConntroller = TextEditingController();

  TextEditingController passwordTextEditingConntroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
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
                "Help App",
                style: TextStyle(fontSize: 30.0, fontFamily: "Brand Bold", color: Colors.blue),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 1.0,),
              Text(
                "Login",
                style: TextStyle(fontSize: 24.0, fontFamily: "Brand Bold"),
                textAlign: TextAlign.center,
              ),
              Padding(padding: EdgeInsets.all(20.0),
              child: Column(
                children: [
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
                  TextButton(
                    child: Text('Login', style: TextStyle(fontSize: 20.0),),
                    style: TextButton.styleFrom(
                      primary: Colors.white,
                      backgroundColor: Colors.black,
                      shadowColor: Colors.white,
                      elevation: 5,
                    ),
                    onPressed: () {
                      if (!emailTextEditingConntroller.text.contains("@")) {
                        displayToastMessage("Invalid email address", context);
                      }
                      else if (passwordTextEditingConntroller.text.isEmpty) {
                        displayToastMessage(
                            "Password is mandatory",
                            context);
                      }
                      else{loginAndAuthenticateUser(context);}


                    },
                  ),
                  TextButton(
                    child: Text('Do not have an account? Register Now', style: TextStyle(fontSize: 17.0, fontFamily: "Brant Bold"),),
                    style: TextButton.styleFrom(
                      primary: Colors.black,
                      backgroundColor: Colors.white,
                      shadowColor: Colors.blue,
                      elevation: 5,
                    ),
                    onPressed: () {
                      Navigator.pushNamedAndRemoveUntil(context, registrationScreen.idScreen, (route) => false);
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
  void loginAndAuthenticateUser(BuildContext context) async
  {
    final User firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(email: emailTextEditingConntroller.text,
        password: passwordTextEditingConntroller.text).catchError((errMsg){
          Navigator.pop(context);
          displayToastMessage("Error:" +errMsg.toString(), context);
    })).user;

    if (firebaseUser != null) //user created
        {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context)
            {return ProgressDialog(message: "Authenticating",);}
          );


      usersRef.child(firebaseUser.uid).once().then((DataSnapshot snap){
        if(snap.value != null)
          {
            Navigator.pushNamedAndRemoveUntil(context, MainScreen.idScreen, (route) => false);
            displayToastMessage("Sign In successful", context);
          }
        else
          {Navigator.pop(context);
            _firebaseAuth.signOut();
            displayToastMessage("No records exist for this user", context);
          }
      });

    }
    else {
      Navigator.pop(context);
      displayToastMessage("Error Occured", context);

    }

  }
  displayToastMessage(String message, BuildContext context){
    Fluttertoast.showToast(msg: message);
  }
}
