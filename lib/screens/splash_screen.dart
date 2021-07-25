import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flyingwolf/screens/home_screen.dart';
import 'package:flyingwolf/screens/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  var _visible = true;
  String? finalUserName;

  late AnimationController animationController;
  late Animation<double> animation;

  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    getValidationData().whenComplete(() async {
      if (finalUserName != null) {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      }
    });
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => HomePage()));
  }

  Future getValidationData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    var savedUserName = sharedPreferences.getString('username');
    setState(() {
      finalUserName = savedUserName;
    });
    print(finalUserName);
  }

  @override
  void initState() {
    super.initState();

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 2));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          Container(
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Image.asset(
                  'assets/logo.jpg',
                  width: animation.value * 250,
                  height: animation.value * 250,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
