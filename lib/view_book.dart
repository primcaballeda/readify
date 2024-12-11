import 'package:flutter/material.dart';
import 'package:readify/homepage.dart';

class ViewBook extends StatefulWidget {
  const ViewBook({super.key});

  @override
  State<ViewBook> createState() => _ViewBookState();
}

class _ViewBookState extends State<ViewBook> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('View Book'),
      ),
      body: const Center(
        child: Text('Book details go here'),
      ),
    );
  }
}