import 'package:flutter/material.dart';
import 'package:readify/firestore.dart';
import 'package:readify/star_rating.dart';
import 'package:readify/view_book.dart';

class AddReview extends StatefulWidget {
  final ViewBook book;

  const AddReview({
    Key? key,
    required this.book,
  }) : super(key: key);

  @override
  State<AddReview> createState() => _AddReviewState();
}

class _AddReviewState extends State<AddReview> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _reviewController = TextEditingController();

  int _selectedRating = 0; // Store the selected star rating

  // Callback to update the rating from StarRating widget
  void _onRatingSelected(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  // Submit the review to Firestore
  void _submitReview() async {
    final reviewText = _reviewController.text;

    if (reviewText.isEmpty || _selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please select a rating and write a review before submitting.')),
      );
    } else {
      await firestoreService.addReview(
        widget.book.title,
        widget.book.author,
        reviewText,
        _selectedRating, 
        widget.book.imageUrl,
        // Pass the star rating
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Review for "${widget.book.title}" submitted successfully!')),
      );
      _reviewController.clear();
      setState(() {
        _selectedRating = 0; // Reset the rating
      });
    }
  }

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
              Navigator.pop(context); // Close the review page
            },
          ),
        ),
        title: const Text(
          'Add Review',
          style: TextStyle(
            fontFamily: 'Josefin Sans Regular',
            fontSize: 20,
            color: Color(0xFF953154),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF953154)),
            onPressed: _submitReview,
          )
        ],
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    widget.book.imageUrl,
                    width: 100,
                    height: 150,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return const Icon(Icons.error, size: 150);
                    },
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.book.title,
                          style: const TextStyle(
                            fontFamily: 'Josefin Sans Regular',
                            fontSize: 20,
                            color: Color(0xFF953154),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'by ${widget.book.author}',
                          style: const TextStyle(
                            fontFamily: 'Josefin Sans Regular',
                            fontSize: 15,
                            color: Color(0xFF953154),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
              const Divider(
                color: Color(0xFF953154),
                thickness: 1.0,
              ),
              const SizedBox(height: 20.0),
              // StarRating widget with callback
              Align(
              alignment: Alignment.centerRight, // Align the stars to the left
              child: StarRating(
                rating: _selectedRating, // Example rating
                onRatingSelected: _onRatingSelected, // Callback
                size: 35, // Adjust size
                color: Color (0xFFFFBEBE), // Filled star color
              ),
            ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  'Rate', // Display selected rating
                  style: const TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 16,
                    color: Color(0xFF953154),
                  ),
                ),
              ),
              const SizedBox(height: 20.0),
              const Divider(
                color: Color.fromARGB(255, 122, 117, 119),
                thickness: 1.0,
              ),
              const SizedBox(height: 10),
              const Text(
                'Review',
                style: TextStyle(
                  fontFamily: 'Josefin Sans Regular',
                  fontSize: 20,
                  color: Color(0xFF953154),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _reviewController,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Write your review here',
                  hintStyle: const TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 15,
                    color: Color(0xFF000000),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF953154),
                      width: 3.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: const Color(0xFF953154).withOpacity(0.5),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: const Color(0xFF953154).withOpacity(0.5),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
