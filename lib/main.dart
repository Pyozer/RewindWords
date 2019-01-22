import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_i18n/flutter_i18n_delegate.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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
      supportedLocales: const [Locale('en'), Locale('fr')],
      localizationsDelegates: [
        FlutterI18nDelegate(false, 'en', 'assets/locales'),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate
      ],
      home: HomeScreen(),
    );
  }
}
