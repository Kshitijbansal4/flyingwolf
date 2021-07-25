import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flyingwolf/screens/splash_screen.dart';

void main() => runApp(
      ProviderScope(child: MyApp()),
    );

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        canvasColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}
