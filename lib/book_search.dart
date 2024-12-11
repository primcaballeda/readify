import 'package:flutter/material.dart';
import 'package:readify/add_review.dart';

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
}

class BookSearch extends StatefulWidget {
  const BookSearch({super.key});

  @override
  State<BookSearch> createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> {
  final List<Book> books = [
    Book(
      title: "To Kill A Mockingbird",
      author: "Harper Lee",
      imageUrl: "https://covers.openlibrary.org/b/id/8228691-L.jpg",
    ),
    // Add more books if needed
  ];

  String query = "";

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books
        .where((book) =>
            book.title.toLowerCase().contains(query.toLowerCase()))
        .toList();

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
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
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
            child: ListView.builder(
              itemCount: filteredBooks.length,
              itemBuilder: (context, index) {
                final book = filteredBooks[index];
                return ListTile(
                  leading: Image.network(
                    book.imageUrl,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
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
                    style: const TextStyle(color: Color(0xFF953154)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AddReview(),
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
