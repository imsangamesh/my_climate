import 'package:flutter/material.dart';
import './screens/weatherScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        canvasColor: const Color.fromARGB(255, 173, 229, 255),
      ),
      debugShowCheckedModeBanner: false,
      home: WeatherScreen(),
    );
  }
}
 