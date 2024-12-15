import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:readify/add_review.dart';
import 'package:readify/addingreview.dart';
import 'package:readify/book_details.dart' as details;

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
              // "Reviews" text added after the description box
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
              // Reviews section
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

                    const Row(
                      children: [
                        Padding(
                          padding: EdgeInsets.only(top: 8.0),
                          child: Text(
                            'To Kill A Mocking Bird',
                            style: TextStyle(
                              fontFamily: 'Josefin Sans Regular',
                              fontSize: 20,
                            ),
                          ),
                        ),
                        Spacer(),
                        Padding(
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
                    const Text(
                      'by Harper Lee',
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
                            Row(
                              children: List.generate(5, (index) {
                                return Icon(
                                  index < 3 ? Icons.star : Icons.star_border,
                                  color: const Color(0xFFFFBEBE),
                                );
                              }),
                            ),
                            const SizedBox(height: 10),
                            // Rated Text
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                'Rated',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        // Spacer to push the heart to the right
                        const Spacer(),
                        // Heart Icon/Image
                        const Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 8.0),
                              child: Image(
                                image: AssetImage('assets/heart.png'),
                                width: 25,
                                height: 25,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
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

                    // Add Review Button
                    Align(
                      alignment: Alignment
                          .topLeft, // Ensures the entire block is aligned to the top-left
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .start, // Aligns the content inside the column to the left
                        mainAxisSize:
                            MainAxisSize.min, // Adjusts the column height
                        children: [
                          Divider(
                            color: const Color(0xFF953154).withOpacity(0.5),
                            thickness: 1.0,
                            indent: 0.0, // Add spacing on the left
                            endIndent: 0.0, // Add spacing on the right
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
                          const SizedBox(
                              height: 16), // Adds space between the buttons
                          TextButton.icon(
                            onPressed: () {
                              // Add to reading list logic here
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

  Widget _reviewComment() {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: [
          // Example Review 1
          _buildReview(
            'John Doe',
            'Amazing book! A true classic. Highly recommended.',
            4.5,
          ),
          const SizedBox(height: 10),
          // Example Review 2
          _buildReview(
            'Jane Smith',
            'A touching story, very well written. 9/10.',
            4.0,
          ),
        ],
      ),
    );
  }

  Widget _buildReview(String name, String review, double rating) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5),
      padding: const EdgeInsets.all(10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar (Replace with actual avatar image if needed)
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey.shade300,
            child: const Icon(Icons.person, color: Colors.white),
          ),
          const SizedBox(width: 10),
          // Review text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF953154),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Row(
                          children: List.generate(5, (index) {
                            return Icon(
                              index < rating ? Icons.star : Icons.star_border,
                              color: const Color(0xFFFFBEBE),
                              size: 18,
                            );
                          }),
                        ),
                        const SizedBox(width: 10),
                        const Icon(
                          Icons.favorite,
                          color: Color(0xFFFFD4D4),
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  review,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 5),
              ],
            ),
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
          // Blurred background image
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
}
