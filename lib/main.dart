import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rewind_words/home_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rewind Words',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'JandaSafeandSound'
      ),
      home: HomeScreen(),
    );
  }
}