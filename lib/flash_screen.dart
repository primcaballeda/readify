import 'package:flutter/material.dart';
import 'dart:async';
import 'login_page.dart'; // Import your login page

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flash Screen Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const FlashScreen(),
    );
  }
}

class FlashScreen extends StatefulWidget {
  const FlashScreen({super.key});

  @override
  _FlashScreenState createState() => _FlashScreenState();
}

class _FlashScreenState extends State<FlashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()), // Navigate to LoginPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Center(
        child: Image.asset('assets/logo.png')
        // child: Text('Readify..', style: TextStyle(fontFamily: 'Brittany', fontSize: 76, color: Color(0xFFFFBEBE))),
      ),
    );
  }
}
