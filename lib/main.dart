import 'package:addinginteractivityandnavigationtoyourapp_codefromchapter/login_screen.dart';
import 'package:flutter/material.dart';
import './stopwatch.dart';

void main() {
  runApp(const StopWatchApp());
}

class StopWatchApp extends StatelessWidget {
  //creating a basic stopwatch app

  const StopWatchApp({super.key});
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LoginScreen(),
      //we are creating the LoginWidget widget and setting it to home here
      //StopWatch page is accessible after the LoginWidget page
    );
  }
}
