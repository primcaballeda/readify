import 'dart:convert';
import 'dart:async'; // Import Timer for debouncing
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Searchbutton(),
    );
  }
}

class Book {
  final String title;
  final String author;
  final String imageUrl;

  Book({required this.title, required this.author, required this.imageUrl});

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      author: (json['author_name'] != null && json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : 'Unknown Author',
      imageUrl: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://via.placeholder.com/150', // Fallback image URL
    );
  }
}

class Searchbutton extends StatefulWidget {
  const Searchbutton({super.key});

  @override
  State<Searchbutton> createState() => _SearchbuttonState();
}

class _SearchbuttonState extends State<Searchbutton> {
  List<Book> books = [];
  String query = "";
  bool isLoading = false;
  Timer? _debounce; // Declare a Timer for debouncing

  Future<void> fetchBooks(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final url = Uri.parse('https://openlibrary.org/search.json?q=$query');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> bookList = data['docs'];

      setState(() {
        books = bookList.take(5).map((json) => Book.fromJson(json)).toList();
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load books');
    }
  }

  // Debounce method to prevent excessive API calls
  void onSearchChanged(String value) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        query = value;
      });
      fetchBooks(query); // Trigger fetchBooks after a delay
    });
  }

  @override
  void dispose() {
    _debounce?.cancel(); // Cancel any active timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: onSearchChanged, // Use debounced search handler
              decoration: const InputDecoration(
                hintText: 'Search a book',
                hintStyle: TextStyle(
                  color: Color(0xFF953154),
                ),
                prefixIcon: Icon(
                  Icons.search,
                  color: Color(0xFFFFBEBE),
                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: Color(0xFF953154),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color(0xFFFFBEBE)), // Replace with your desired color
                    ),
                  )
                : books.isEmpty
                    ? const Center(child: Text('No books found.'))
                    : ListView.builder(
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return ListTile(
                            leading: Image.network(
                              book.imageUrl,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                // If image loading fails, display a placeholder
                                return Image.network(
                                  'https://via.placeholder.com/150',
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                );
                              },
                            ),
                            title: Text(
                              book.title,
                              style: const TextStyle(
                                fontFamily: 'Josefin Sans Regular',
                                color: Color(0xFF953154),
                              ),
                            ),
                            subtitle: Text(
                              'by ${book.author}',
                              style: const TextStyle(color: Colors.black),
                            ),
                            // Inside your ListView onTap method in BookSearch
                            onTap: () {

                            },
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
