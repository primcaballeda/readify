import 'package:flutter/material.dart';
import 'flash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
  runApp(const MaterialApp(
    
     debugShowCheckedModeBanner: false,
    home: FlashScreen(),
  ));
}