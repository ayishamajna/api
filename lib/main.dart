import 'package:flutter/material.dart';
import 'package:todo_api/ToDo/home.dart';
import 'package:todo_api/ToDo/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: MyHome());
  }
}
