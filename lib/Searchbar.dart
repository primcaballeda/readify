import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final String bookName;

  const BookDetailsPage({Key? key, required this.bookName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: Center(
        child: Text(
          'Details for $bookName',
          style: const TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
