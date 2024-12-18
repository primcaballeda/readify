import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:readify/book_search.dart';
import 'view_book.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> bookCovers = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchSelectedBooks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFBEBE)),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Popular Books',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80953154),
                    ),
                  ),
                  const SizedBox(height: 5.0), // Reduced gap
                  Expanded(
                    flex: 0, // Make sure the carousel takes less space
                    child: SingleChildScrollView(
                      child: CarouselSlider(
                        items: buildBookRows(),
                        options: CarouselOptions(
                          autoPlay: false,
                          enlargeCenterPage: true,
                          viewportFraction: 0.9,
                          aspectRatio: 2.0,
                          height: 150, // Carousel height
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20), // Reduced gap
                  const Text(
                    'Popular Reviews',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80953154),
                    ),
                  ),
                  const SizedBox(height: 10), // Reduced gap
                  Expanded(
                    flex: 1, // Make sure the grid of reviews takes the remaining space
                    child: GridView.builder(
                      itemCount: 6, // Placeholder count
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (context, index) {
                        return buildReviewCardPlaceholder();
                      },
                    ),
                  ),
                ],
              ),
      ),
      floatingActionButton: FloatingActionButton(
        foregroundColor: Theme.of(context).colorScheme.onTertiaryContainer,
        backgroundColor: Theme.of(context).colorScheme.tertiaryContainer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const BookSearch()),
          );
        },
        child: const Icon(Icons.add, size: 30, color: Color(0xFF953154)),
      ),
    );
  }

  /// Build book cover rows for Carousel
  List<Widget> buildBookRows() {
    List<Widget> rows = [];
    for (int i = 0; i < bookCovers.length; i += 3) {
      rows.add(
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Expanded(child: buildBookCoverCard(bookCovers[i])),
            if (i + 1 < bookCovers.length)
              Expanded(child: buildBookCoverCard(bookCovers[i + 1])),
            if (i + 2 < bookCovers.length)
              Expanded(child: buildBookCoverCard(bookCovers[i + 2])),
          ],
        ),
      );
    }
    return rows;
  }

  /// Book Cover Card Widget
  Widget buildBookCoverCard(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () {
        if (!mounted) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewBook(
              title: book['title'],
              author: book['author'],
              imageUrl: book['imageUrl'],
              description: book['description'],
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(4),
        child: Card(
          elevation: 4,
          color: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              image: DecorationImage(
                image: NetworkImage(book['imageUrl']),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Fetch book data concurrently
  Future<void> fetchSelectedBooks() async {
    const List<String> bookTitles = [
      'The Great Gatsby',
      '1984',
      'Pride and Prejudice',
      'Moby Dick',
      'War and Peace',
      'To Kill a Mockingbird',
    ];

    List<Future<Map>> fetchTasks = bookTitles.map((title) async {
      try {
        final response = await http
            .get(Uri.parse(
                'https://openlibrary.org/search.json?title=${Uri.encodeQueryComponent(title)}'))
            .timeout(const Duration(seconds: 10));

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final books = data['docs'];
          if (books.isNotEmpty) {
            final book = books[0];
            final detailsResponse = await http
                .get(Uri.parse('https://openlibrary.org${book['key']}.json'))
                .timeout(const Duration(seconds: 10));

            if (detailsResponse.statusCode == 200) {
              final bookDetails = json.decode(detailsResponse.body);
              return {
                'title': book['title'],
                'author': book['author_name']?.isNotEmpty ?? false
                    ? book['author_name'][0]
                    : 'Unknown Author',
                'imageUrl': book['cover_i'] != null
                    ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-L.jpg'
                    : 'https://via.placeholder.com/150',
                'description': bookDetails['description'] ?? 'No description available',
              };
            }
          }
        }
      } catch (e) {
        debugPrint('Error fetching book: $title -> $e');
      }
      return {};
    }).toList();

    final results = await Future.wait(fetchTasks);

    if (!mounted) return;
    setState(() {
      bookCovers = results.where((book) => book.isNotEmpty).cast<Map<String, dynamic>>().toList();
      isLoading = false;
    });
  }

  /// Review Card Placeholder
  Widget buildReviewCardPlaceholder() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(2),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 110,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text('yanna', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'The Silence',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                    const Text('by Author\'s name', style: TextStyle(fontSize: 8)),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        const Text('Placeholder review text...', style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
