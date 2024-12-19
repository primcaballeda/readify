import 'package:flutter/material.dart';
import 'package:readify/Searchbar.dart';
import 'package:readify/library.dart';
import 'package:readify/notifications.dart';
import 'package:readify/profile.dart';
import 'package:readify/homepage.dart';
import 'package:readify/view_book.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({super.key});

  final int _bottomNavIndex = 0;
  final List<Widget> pages = const [
    HomePage(title: ''),
    Library(),
    ProfilePage(),
  ];

  final List<String> imageList = [
    'assets/home.png',
    'assets/library.png',
    'assets/person.png',
  ];

  final List<String> imageListSelected = [
    'assets/chome.png',
    'assets/clibrary.png',
    'assets/cperson.png',
  ];

  final List<String> titleList = [
    'Home',
    'Library',
    'Profile',
  ];

  @override
  State<RootPage> createState() => _RootPageState();
}

// Define the Book model
class Book {
  final String title;
  final String author;
  final String imageUrl;
  final String description;

  Book({
    required this.title,
    required this.author,
    required this.imageUrl,
    required this.description,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      title: json['title'] ?? 'No Title',
      author: (json['author_name'] != null && json['author_name'].isNotEmpty)
          ? json['author_name'][0]
          : 'Unknown Author',
      imageUrl: json['cover_i'] != null
          ? 'https://covers.openlibrary.org/b/id/${json['cover_i']}-L.jpg'
          : 'https://via.placeholder.com/150',
      description: json['description'] ?? 'No Description Available',
    );
  }
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;
  String _searchQuery = ''; // To store the search query
  bool isLoading = false; // To indicate loading state
  List<Book> books = []; // List of books fetched from the API

  // Method to update search query
  void _onSearchChanged(String value) {
    setState(() {
      _searchQuery = value;
    });

    // Fetch books based on the search query
    fetchBooks(value);
  }

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

      // Convert the response into a list of Book objects
      final fetchedBooks = bookList.map((json) => Book.fromJson(json)).take(4).toList();

      setState(() {
        books = fetchedBooks;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      throw Exception('Failed to load books');
    }
  }

  Widget _buildSearchResults(List<Book> books) {
    if (_searchQuery.isEmpty) {
      return const SizedBox.shrink(); // Show nothing when search is empty
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Search Results for "$_searchQuery"',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(height: 10),
          // Show a loading indicator while fetching the data
          isLoading
              ? const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFBEBE)),
                  ),
                )
              : books.isEmpty
                  ? const Center(child: Text('No books found.'))
                  : Column(
                      children: books.map((book) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ViewBook(
                                  title: book.title,
                                  author: book.author,
                                  imageUrl: book.imageUrl,
                                  description: book.description,
                                ),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 5.0),
                            child: Row(
                              children: [
                                Image.network(
                                  book.imageUrl,
                                  width: 50,
                                  height: 50,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.broken_image,
                                        size: 50);
                                  },
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    book.title,
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
        ],
      ),
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: const Color(0xFFFFFFE8),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: SizedBox(
            width: 280,
            child: SizedBox(
              height: 50,
              child: TextField(
                style: const TextStyle(color: Color(0XFFFFD4D4)),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  hintText: 'Search for books or people',
                  hintStyle: TextStyle(color: Color(0x7F953154)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xFFFFD4D4),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xFFFFD4D4),
                      width: 3.0,
                    ),
                  ),
                ),
                onChanged: _onSearchChanged, // Update search query on input change
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Image.asset(
                'assets/notif_bell.png',
                width: 35,
                height: 35,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Notifications()),
                );
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: Column(
        children: [
          _buildSearchResults(books), // Show search results here
          Expanded(child: widget.pages[_bottomNavIndex]), // Show other pages
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFE8),
        items: widget.imageList
            .asMap()
            .map((index, icon) {
              return MapEntry(
                index,
                BottomNavigationBarItem(
                  icon: Image.asset(
                    _bottomNavIndex == index
                        ? widget.imageListSelected[index]
                        : icon,
                    width: 24,
                    height: 24,
                  ),
                  label: widget.titleList[index],
                ),
              );
            })
            .values
            .toList(),
        currentIndex: _bottomNavIndex,
        selectedItemColor: const Color(0xFFFFBEBE),
        unselectedItemColor: const Color(0xFFFFBEBE),
        onTap: _onItemTapped,
      ),
    );
  }
}
