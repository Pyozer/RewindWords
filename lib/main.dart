import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rewind_words/screens/home_screen.dart';

void main() {
  debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Hide navigation bar and set status bar transparent
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Rewind Words',
      theme: ThemeData(
        primarySwatch: Colors.purple,
        fontFamily: 'JandaSafeandSound',
        brightness: Brightness.dark,
      ),
      home: HomeScreen(),
    );
  }
}
