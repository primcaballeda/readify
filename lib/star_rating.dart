import 'package:flutter/material.dart';

class StarRating extends StatefulWidget {
  final Function(int)? onRatingSelected; // Optional callback to send the rating to the parent
  final int rating; // Current rating passed from parent
  final double size; // Star size
  final Color color; // Filled star color
  final Color borderColor; // Empty star color
  final int maxStars; // Total number of stars
  final bool isInteractive; // Toggle interactivity

  const StarRating({
    super.key,
    this.onRatingSelected,
    required this.rating,
    this.size = 40.0,
    this.color = const Color(0xFFFFD700), // Gold color for filled stars
    this.borderColor = Colors.grey,
    this.maxStars = 5,
    this.isInteractive = true, // Interactive by default
  });

  @override
  _StarRatingState createState() => _StarRatingState();
}

class _StarRatingState extends State<StarRating> {
  // Store the selected rating (using parent's value)
  int get _rating => widget.rating;

  // Update rating when star is tapped
  void _updateRating(int index) {
    if (widget.isInteractive && widget.onRatingSelected != null) {
      widget.onRatingSelected!(index + 1); // Send the new rating back to the parent
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.maxStars, (index) {
        return GestureDetector(
          onTap: () => _updateRating(index),
          child: Icon(
            index < _rating ? Icons.star : Icons.star_border,
            color: index < _rating ? widget.color : widget.borderColor,
            size: widget.size,
          ),
        );
      }),
    );
  }
}
