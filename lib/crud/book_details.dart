import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BookDetailsPage extends StatefulWidget {
  final String bookTitle;

  const BookDetailsPage({Key? key, required this.bookTitle}) : super(key: key);

  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  late Future<Book> _bookFuture;

  @override
  void initState() {
    super.initState();
    _bookFuture = fetchBookData(widget.bookTitle);
  }

  Future<Book> fetchBookData(String bookTitle) async {
    final response = await http.get(
      Uri.parse('https://openlibrary.org/search.json?title=$bookTitle'),
    );

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['docs'].isNotEmpty) {
        return Book.fromJson(data['docs'][0]);
      } else {
        throw Exception('No book found');
      }
    } else {
      throw Exception('Failed to load book');
    }
  }

  StreamBuilder<QuerySnapshot> buildReviewsSection(String bookTitle) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('book_reviews')
          .where('title', isEqualTo: bookTitle) // Adjust key to Firestore schema
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Center(
            child: Text('Error loading reviews'),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              'No reviews available',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          );
        }

        return ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: snapshot.data!.docs.map((reviewDoc) {
            final reviewData = reviewDoc.data() as Map<String, dynamic>;
            final reviewText = reviewData['review'] ?? 'No review available';
            final userName = reviewData['username'] ?? 'Unknown User';

            return ListTile(
              leading: const CircleAvatar(
                backgroundImage: NetworkImage(
                    'https://via.placeholder.com/150'),
              ),
              title: Text(
                userName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(reviewText),
            );
          }).toList(),
        );
      },
    );
  }
  
  @override
  Widget build(BuildContext context) {
    throw UnimplementedError();
  }
}

class Book {
  final String title;
  final String author;
  final String description;
  final String imageUrl;
  final String blurImage;

  Book({
    required this.title,
    required this.author,
    required this.description,
    required this.imageUrl,
    required this.blurImage,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      author: json['author_name']?.join(', ') ?? 'Unknown Author',
      description: json['first_sentence'] != null
          ? json['first_sentence'][0]
          : 'No description available',
      imageUrl: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://via.placeholder.com/150',
      blurImage: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://via.placeholder.com/150',
    );
  }
}
