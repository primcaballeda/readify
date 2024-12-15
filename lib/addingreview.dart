import 'package:flutter/material.dart';
import 'package:readify/star_rating.dart';
import 'package:readify/book_search.dart';

class AddingReview extends StatefulWidget {
  final Book book;  // The book passed from the BookSearch screen

  const AddingReview({super.key, required this.book});

  @override
  State<AddingReview> createState() => _AddingReviewState();
}

class _AddingReviewState extends State<AddingReview> {
  final TextEditingController _reviewController = TextEditingController();

  // Function to handle the submission of the review
  void _submitReview() {
    final reviewText = _reviewController.text;

    if (reviewText.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please write a review before submitting.')),
      );
    } else {
      // Handle the review (save to a database, server, or display on the screen)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Review for "${widget.book.title}": $reviewText')),
      );
      // Clear the text field after submitting the review
      _reviewController.clear();
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
                  const SizedBox(width: 16.0), // Spacing between the image and the text
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
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFF953154),
                      thickness: 1.0,
                    ),
                  ),
                  SizedBox(width: 4.0), // Space matching the heart icon width
                ],
              ),
              const SizedBox(height: 20.0), // Add spacing before star rating
              const StarRating(), // Add the StarRating widget here
              const SizedBox(height: 20.0), // Add spacing after star rating
              const Center(
                child: Text(
                  'Rate this book',
                  style: TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color.fromARGB(255, 122, 117, 119),
                      thickness: 1.0,
                    ),
                  ),
                  SizedBox(width: 4.0), // Space matching the heart icon width
                ],
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
            ],
          ),
        ),
      ),
    );
  }
}
