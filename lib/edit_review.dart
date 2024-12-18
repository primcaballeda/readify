import 'package:flutter/material.dart';
import 'package:readify/firestore.dart';
import 'package:readify/library.dart';
import 'package:readify/star_rating.dart';

class EditReview extends StatefulWidget {
  final Book books;
  final String reviewDocId;

  const EditReview({
    Key? key,
    required this.books,
    required this.reviewDocId,
  }) : super(key: key);

  @override
  State<EditReview> createState() => EditReviewState();
}

class EditReviewState extends State<EditReview> {
  final FirestoreService firestoreService = FirestoreService();
  final TextEditingController _reviewController = TextEditingController();
  int _selectedRating = 0;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _loadExistingReview();
  }

  Future<void> _loadExistingReview() async {
    final review = await firestoreService.fetchReview(widget.reviewDocId);
    setState(() {
      _reviewController.text = review['review'] ?? '';
      _selectedRating = review['rating'] ?? 0;
    });
  }

  void _onRatingSelected(int rating) {
    setState(() {
      _selectedRating = rating;
    });
  }

  void _editReview() async {
    final reviewText = _reviewController.text;

    if (reviewText.isEmpty || _selectedRating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a rating and write a review before submitting.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    await firestoreService.editReview(
      widget.reviewDocId,
      widget.books.title,
      widget.books.author,
      widget.books.imageUrl,
      reviewText,
      _selectedRating,
    );

    setState(() {
      _isSubmitting = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Review for "${widget.books.title}" updated successfully!')),
    );
 // Close the EditReview page after successful update
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: const Color(0xFFFFFFE8),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF953154)),
            onPressed: () {
              Navigator.pop(context); // Close the EditReview page
            },
          ),
        ),
        title: const Text(
          'Edit Review',
          style: TextStyle(
            fontFamily: 'Josefin Sans Regular',
            fontSize: 20,
            color: Color(0xFF953154),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF953154)),
            onPressed: _isSubmitting ? null : _editReview, // Disable button during submission
          ),
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
                    widget.books.imageUrl,
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
                          widget.books.title,
                          style: const TextStyle(
                            fontFamily: 'Josefin Sans Regular',
                            fontSize: 20,
                            color: Color(0xFF953154),
                          ),
                        ),
                        const SizedBox(height: 5.0),
                        Text(
                          'by ${widget.books.author}',
                          style: const TextStyle(
                            fontFamily: 'Josefin Sans Regular',
                            fontSize: 15,
                            color: Color(0xFF953154),
                          ),
                        ),
                        const SizedBox(height: 50),
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
              StarRating(
                rating: _selectedRating,
                onRatingSelected: _onRatingSelected,
                color: const Color(0xFFFFBEBE),
              ),
              const SizedBox(height: 20.0),
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
            ],
          ),
        ),
      ),
    );
  }
}
