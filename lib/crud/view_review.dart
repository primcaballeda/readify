import 'package:flutter/material.dart';

class FullReviewPage extends StatelessWidget {
  final String reviewText;

  const FullReviewPage({Key? key, required this.reviewText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        
      backgroundColor: const Color(0xFFFFFFE8),
        title: const Text('Full Review'),
        
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Text(
            reviewText,
            style: const TextStyle(fontSize: 16),
            textAlign: TextAlign.justify,
          ),
        ),
      ),
    );
  }
}
