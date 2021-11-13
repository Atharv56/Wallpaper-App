import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'login.dart';
import 'package:velocity_x/velocity_x.dart';
import 'main.dart';
import 'routes.dart';

class RegPage extends StatefulWidget {
  const RegPage({Key? key}) : super(key: key);

  @override
  _RegPageState createState() => _RegPageState();
}

class _RegPageState extends State<RegPage> {
  String? name = "";
  String? confirmpass = "";
  bool changeButton = false;
  final _formKey = GlobalKey<FormState>();

  moveToLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        changeButton = true;
      });
      await Future.delayed(const Duration(seconds: 1));
      await Navigator.pushNamed(context, MyRoutes.loginRoute);
      setState(() {
        changeButton = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Material(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 15.0),
                Image.asset(
                  "assets/images/register.png",
                  fit: BoxFit.cover,
                  //height: 1000,
                ),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                  "Enter your registration details",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 16.0, horizontal: 32.0),
                  child: Column(
                    children: [
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter your Full Name",
                            labelText: "Full Name"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a valid input";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        decoration: const InputDecoration(
                            hintText: "Enter your email ID",
                            labelText: "E-Mail"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a valid input";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Enter password", labelText: "Password"),
                        validator: (value) {
                          confirmpass = value;
                          if (value!.isEmpty) {
                            return "Enter a valid input";
                          } else if (value.length < 6) {
                            return "Password length must be at least 6 characters";
                          }
                          return null;
                        },
                      ),
                      TextFormField(
                        obscureText: true,
                        decoration: const InputDecoration(
                            hintText: "Re-enter your password",
                            labelText: "Confirm Password"),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Enter a valid input";
                          } else if (value.length < 6) {
                            return "Password length must be at least 6 characters";
                          } else if (value != confirmpass) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                      ),
                      const SizedBox(
                        height: 20.0,
                      ),
                      Material(
                        color: Colors.deepPurple,
                        borderRadius:
                            BorderRadius.circular(changeButton ? 20 : 10),
                        child: InkWell(
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LoginPage()));
                          },
                          child: AnimatedContainer(
                            duration: const Duration(seconds: 1),
                            width: changeButton ? 42 : 110,
                            height: 40,
                            alignment: Alignment.center,
                            child: changeButton
                                ? const Icon(Icons.done, color: Colors.white)
                                : const Text(
                                    "Register",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
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
