import 'package:flutter/material.dart';
import 'package:jmusic/pages/dashboard/song_list.dart';
import 'package:jmusic/pages/splash_screen.dart';
void main() async {
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  
  MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: SplashScreen(),
      
    );
  }
}
