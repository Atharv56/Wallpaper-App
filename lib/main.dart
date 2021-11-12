import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:animated_splash_screen/animated_splash_screen.dart'
    show AnimatedSplashScreen, SplashTransition;
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    var animatedSplashScreen = AnimatedSplashScreen(
      splash: Icons.ac_unit_rounded,
      duration: 1500,
      backgroundColor: Colors.white,
      nextScreen: const WallpaperPage(),
      splashTransition: SplashTransition.rotationTransition,
    );
    return MaterialApp(
        title: 'WallpaperApp',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: animatedSplashScreen);
  }
}

class WallpaperPage extends StatefulWidget {
  const WallpaperPage({Key? key}) : super(key: key);

  @override
  _WallpaperPageState createState() => _WallpaperPageState();
}

class _WallpaperPageState extends State<WallpaperPage> {
  //key = Yd98srK-HGd_Ev3FLUlaYKJw2aax6B1Yx_AdaGg1he0
  // ignore: prefer_typing_uninitialized_variables
  var urldata;
  void getApidata() async {
    var url = Uri.parse(
        'https://api.unsplash.com/photos/?per_page=30&client_id=Yd98srK-HGd_Ev3FLUlaYKJw2aax6B1Yx_AdaGg1he0');
    final res = await http.get(url);
    setState(() {
      // ignore: unused_local_variable
      urldata = jsonDecode(res.body);
      // ignore: avoid_print
      print(urldata);
    });
  }

  @override
  void initState() {
    super.initState();
    getApidata();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'WallpaperApp',
        theme: ThemeData(primaryColor: Colors.purple),
        home: Scaffold(
          appBar: AppBar(
            title: const Text('WallpaperApp'),
            elevation: 0.0,
            backgroundColor: Colors.purple,
          ),
          body: Center(
            child: urldata == null
                ? const CircularProgressIndicator()
                : GridView.builder(
                    itemCount: 30,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisSpacing: 6,
                            crossAxisCount: 2,
                            crossAxisSpacing: 6),
                    itemBuilder: (context, i) {
                      return Container(
                          decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(urldata[i]['urls']['regular']),
                        ),
                      ));
                    }),
          ),
        ));
  }
}
