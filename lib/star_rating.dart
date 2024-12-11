import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  const StarRating({super.key});

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  int _rating = 0; // Store the selected rating

  // Update rating on star tap
  void _updateRating(int index) {
    setState(() {
      _rating = index + 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        return GestureDetector(
          onTap: () => _updateRating(index), // Update rating on tap
          child: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: const Color(0xFFFFD4D4),
            size: 40.0,
          ),
        );
      }),
    );
  }
}
