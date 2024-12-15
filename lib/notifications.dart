import 'package:flutter/material.dart';
import 'package:readify/star_rating.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Notifications(),
    );
  }
}

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => NotificationsState();
}

class NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: const Color(0xFFFFD4D4).withOpacity(0.5),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF953154)),
            onPressed: () {
              Navigator.pop(context); // Close the search page
            },
          ),
        ),
        title: const Text(
          'Notifications',
          style: TextStyle(
            fontFamily: 'Josefin Sans Regular',
            fontSize: 20,
            color: Color(0xFF953154),
          ),
        ),
        
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: const SingleChildScrollView(
        child: Text(
          'No notifications yet',
          style: TextStyle(
            fontFamily: 'Josefin Sans Regular',
            fontSize: 20,
            color: Color(0xFF953154),
          ),
        )
        
      ),
    );
  }
}
