import 'package:http/http.dart' as http;
import 'dart:convert';


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

  // Factory method to create a Book from JSON data
  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      author: json['author_name']?.join(', ') ?? 'Unknown Author',
      description: json['first_sentence'] != null 
          ? json['first_sentence'][0] 
          : 'No description available', 
      imageUrl: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://via.placeholder.com/150', // Placeholder image if no cover is found
      blurImage: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://via.placeholder.com/150',
    );
  }
}
Future<Book> fetchBookData(String bookTitle) async {
  final response = await http.get(
    Uri.parse('https://openlibrary.org/search.json?title=$bookTitle'),
  );

  if (response.statusCode == 200) {
    var data = jsonDecode(response.body);
    if (data['docs'].isNotEmpty) {
      return Book.fromJson(data['docs'][0]); // Return the first result
    } else {
      throw Exception('No book found');
    }
  } else {
    throw Exception('Failed to load book');
  }
}