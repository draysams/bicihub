import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'platform_adaptive.dart';
import 'chatScreen3.dart';
import 'menu.dart';
import 'maps.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Transfeed',
      debugShowCheckedModeBanner: false,
      theme: defaultTargetPlatform == TargetPlatform.iOS
          ? kIOSTheme
          : kIOSTheme,
      home: new Menu(),
      routes: <String, WidgetBuilder> {
        '/chatScreen': (BuildContext context) => new ChatScreen(),
        '/menu': (BuildContext context) => new Menu(),
        '/mapsPage': (BuildContext context) => new MapsPage()
      },
    );
  }
}
