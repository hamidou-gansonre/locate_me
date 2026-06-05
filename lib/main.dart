import 'package:flutter/material.dart';
import 'package:locate_me/map_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Locate Me',
      debugShowCheckedModeBanner: false,
      home: const MapScreen(),
    );
  }
}
