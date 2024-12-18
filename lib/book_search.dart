import 'dart:convert';
import 'dart:async'; // Import Timer for debouncing
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:readify/addingreview.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookSearch(),
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

class BookSearch extends StatefulWidget {
  const BookSearch({super.key});

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
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
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: const Color(0xFFFFD4D4).withOpacity(0.5),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF953154)),
            onPressed: () {
              Navigator.pop(context); // Close the search page
            },
          ),
        ),
        title: const Text(
          'Search Book Title',
          style: TextStyle(
            fontFamily: 'Josefin Sans Regular',
            fontSize: 20,
            color: Color(0xFF953154),
          ),
        ),
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
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                  color: Color(0xFF953154),
                  ),
                ),
                focusedBorder: UnderlineInputBorder(
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
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => AddingReview(
                                    book: book, // Pass the selected book object
                                  ),
                                ),
                              );
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
