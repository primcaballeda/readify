import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:readify/add_review.dart';
import 'package:readify/addingreview.dart';
import 'package:readify/book_details.dart' as details;
import 'package:readify/firestore.dart';
import 'package:readify/star_rating.dart';

class MyApp extends StatelessWidget {
  final details.Book book;
  const MyApp({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ViewBook(
        title: book.title,
        author: book.author,
        imageUrl: book.imageUrl,
        description: book.description,
      ),
    );
  }
}

class ViewBook extends StatefulWidget {
  final String title;
  final String author;
  final String imageUrl;
  final String description;

  const ViewBook({
    Key? key,
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
  }) : super(key: key);

  @override
  State<ViewBook> createState() => _ViewBookState();
}

class _ViewBookState extends State<ViewBook> {
  final FirestoreService firestoreService = FirestoreService();
  bool _isLiked = false;
  int _selectedRating = 0;
  void _onRatingSelected(int rating) {
    setState(() {
      _selectedRating = rating;
    });
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
              Navigator.pop(context); // Close the view book page
            },
          ),
        ),
        title: const Text(
          'View Book Description',
          style: TextStyle(
            fontFamily: 'Josefin Sans Regular',
            fontSize: 20,
            color: Color(0xFF953154),
          ),
        ),
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _blurimage(),
              Text(
                widget.title,
                style: const TextStyle(
                  fontFamily: 'Josefin Sans Regular',
                  fontSize: 20,
                  color: Color(0xFF953154),
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                'by ${widget.author}',
                style: const TextStyle(
                  fontFamily: 'Josefin Sans Regular',
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 0, 0),
                  fontWeight: FontWeight.w400,
                ),
              ),
              const SizedBox(height: 10),
              // Star Ratings directly below the author name
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ...List.generate(5, (index) {
                    return Icon(
                      index < 3 ? Icons.star : Icons.star_border,
                      color: index < 3 ? const Color(0xFFFFBEBE) : Colors.grey,
                      size: 20,
                    );
                  }),
                  const SizedBox(width: 10),
                  const Text(
                    '4.34 · 20,000 ratings · 10,000 reviews',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans Regular',
                      fontSize: 13,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const Padding(
                padding: EdgeInsets.only(top: 30.0),
                child: Text(
                  'Book Description',
                  style: TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 20,
                    color: Color.fromARGB(146, 149, 49, 84),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  margin: const EdgeInsets.all(10.0),
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    border:
                        Border.all(color: const Color(0xFF953154), width: 1.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    widget.description,
                    style: const TextStyle(
                      fontFamily: 'Josefin Sans Regular',
                      fontSize: 13,
                      color: Colors.black,
                      fontWeight: FontWeight.w300,
                    ),
                    textAlign: TextAlign.justify,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 20.0, left: 25),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(
                    'Reviews',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans Regular',
                      fontSize: 20,
                      color: Color.fromRGBO(149, 49, 84, 0.5),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              _reviewComment(),
              const Divider(
                color: Color.fromARGB(46, 149, 49, 84),
                thickness: 1.0,
                indent: 0.0, // Add spacing on the left
                endIndent: 0.0, // Add spacing on the right
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: GestureDetector(
                  onTap: () {},
                  child: const Text(
                    'All Reviews',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans Regular',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color.fromRGBO(149, 49, 84, 0.5),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              const Divider(
                color: Color.fromARGB(46, 149, 49, 84),
                thickness: 1.0,
                indent: 0.0, // Add spacing on the left
                endIndent: 0.0, // Add spacing on the right
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            backgroundColor: const Color(0xFFFFE9DE),
            builder: (context) {
              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Book Title and Author
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            widget.title,
                            style: const TextStyle(
                              fontFamily: 'Josefin Sans Regular',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        const Spacer(),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(Icons.check,
                                  color: Color(0xFF953154), size: 30),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'by ${widget.author}',
                      style: TextStyle(
                        fontFamily: 'Josefin Sans Regular',
                        fontWeight: FontWeight.w300,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Divider(
                      color: const Color(0xFF953154).withOpacity(0.5),
                      thickness: 1.0,
                      indent: 0.0, // Add spacing on the left
                      endIndent: 0.0, // Add spacing on the right
                    ),
                    // Rating Stars
                    Row(
                      children: [
                        // Rating Stars Column
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Align(
                              alignment: Alignment
                                  .centerRight, // Align the stars to the left
                              child: StarRating(
                                rating: _selectedRating, // Example rating
                                onRatingSelected: _onRatingSelected, // Callback
                                size: 35, // Adjust size
                                color: Color(0xFFFFBEBE), // Filled star color
                              ),
                            ),
                            const SizedBox(height: 10),
                            // Rated Text
                            Align(
                              alignment: Alignment
                                  .centerLeft, // Align the stars to the left
                              child: StarRating(
                                rating: _selectedRating, // Pass current rating
                                onRatingSelected: (newRating) {
                                  setState(() {
                                    _selectedRating =
                                        newRating; // Update the state
                                  });
                                },
                                size: 35,
                                color: const Color(0xFFFFBEBE),
                              ),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: StatefulBuilder(
                                builder: (context, setState) {
                                  return IconButton(
                                    icon: Image(
                                      image: AssetImage(_isLiked
                                          ? 'assets/cheart.png'
                                          : 'assets/heart.png'),
                                      width: 32,
                                      height: 32,
                                    ),
                                    onPressed: () async {
                                      setState(() {
                                        _isLiked =
                                            !_isLiked; // Toggle the liked state
                                      });
                                      if (_isLiked) {
                                        // Replace with actual image URL

                                        await firestoreService.addToLikedBooks(
                                          widget.title,
                                          widget.author,
                                          widget.description,
                                          widget.imageUrl,
                                        );
                                      }
                                    },
                                  );
                                },
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Like',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Align(
                      alignment: Alignment.topLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Divider(
                            color: const Color(0xFF953154).withOpacity(0.5),
                            thickness: 1.0,
                          ),
                          TextButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddReview(book: widget),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add,
                              color: Color(0xFF953154),
                              size: 28,
                            ),
                            label: const Text(
                              'Add review',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Josefin Sans Regular',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          // Add to Reading List Button
                          TextButton.icon(
                            onPressed: () async {
                              try {
                                // Show a loading dialog to prevent multiple clicks
                                showDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (_) => const Center(
                                    child: CircularProgressIndicator(
                                        valueColor: AlwaysStoppedAnimation(
                                      Color(0xFFFFBEBE),
                                    )),
                                  ),
                                );

                                // Check if the book is already in the reading list
                                bool isAlreadyAdded =
                                    await firestoreService.isBookInReadingList(
                                  widget.title,
                                  widget.author,
                                  widget.description,
                                  widget.imageUrl,
                                );

                                // Close the loading dialog
                                Navigator.pop(context);

                                if (isAlreadyAdded) {
                                  // Show "Already Added" dialog
                                  await _showInfoDialog(
                                    context,
                                    'Already in Reading List',
                                    '${widget.title} by ${widget.author} is already in your reading list.',
                                  );
                                } else {
                                  // Add the book to the reading list
                                  await firestoreService.addToReadingList(
                                    widget.title,
                                    widget.author,
                                    widget.description,
                                    widget.imageUrl,
                                  );

                                  // Show "Added" dialog
                                  await _showInfoDialog(
                                    context,
                                    'Added to Reading List',
                                    '${widget.title} by ${widget.author} has been added to your reading list.',
                                  );
                                }
                              } catch (e) {
                                // Close the loading dialog if an error occurs
                                Navigator.pop(context);

                                // Handle errors gracefully
                                await _showInfoDialog(
                                  context,
                                  'Error',
                                  'Something went wrong. Please try again later.',
                                );
                              }
                            },
                            icon: const Image(
                              image: AssetImage('assets/readinglist.png'),
                              width: 24,
                              height: 24,
                            ),
                            label: const Text(
                              'Add to your Reading List',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'Josefin Sans Regular',
                                fontSize: 18,
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Image.asset(
          'assets/pencil.png',
          width: 15,
          height: 20,
        ),
      ),
    );
  }

  Future<void> _showInfoDialog(
      BuildContext context, String title, String content) {
    return showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _blurimage() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Stack(
        alignment: Alignment.topCenter,
        children: [
          ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
              child: Container(
                color: Colors.transparent,
                child: Image.network(
                  widget.imageUrl, // Replace with your image asset
                  height: 200,
                  width: 500,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              height: 200,
              width: 500,
              color: Colors.transparent,
            ),
          ),
          // Focused foreground image
          Card(
            elevation: 8,
            child: Image.network(
              widget.imageUrl, // Replace with your image asset
              height: 250,
              width: 150,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewComment() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        'This is a great book! I enjoyed reading it. The characters were relatable, and the plot kept me engaged.',
        style: TextStyle(fontSize: 14, color: Colors.black),
      ),
    );
  }
}
