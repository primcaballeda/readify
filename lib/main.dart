import 'package:flutter/material.dart';
import 'flash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();


    await Firebase.initializeApp();

  // Initialize Supabase
  await Supabase.initialize(
    url: 'https://qcqkztzoovbellbctrni.supabase.co', // Replace with your Supabase URL
    anonKey: 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InFjcWt6dHpvb3ZiZWxsYmN0cm5pIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzQyNTIwNzQsImV4cCI6MjA0OTgyODA3NH0.wjcv25mUkrtI3rMBfKzBulNFtngt6AdCQyg6qJ6d_74', // Replace with your Supabase anon key
  );



  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FlashScreen(),
    );
  }
}