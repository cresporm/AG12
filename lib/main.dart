import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'homepage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
	  debugShowCheckedModeBanner: false,
      home: const HomePage(),
      theme: ThemeData.dark(),
      darkTheme: ThemeData.dark(),
    );
  }
}
