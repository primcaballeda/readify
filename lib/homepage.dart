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
    List<Widget> itemTriples = [];
    if (bookCovers.isNotEmpty) {
      for (int i = 0; i < bookCovers.length; i += 3) {
        itemTriples.add(
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
    } else {
      itemTriples.add(
        const Center(
          child: Text('No books available.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 10, right: 10),
        child: isLoading
            ? const Center(child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFFFBEBE)),
            ))
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
                  const SizedBox(height: 10.0),
                  SingleChildScrollView(
                    child: CarouselSlider(
                      items: itemTriples,
                      options: CarouselOptions(
                        autoPlay: false,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 2.0,
                        height: 150,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Popular Reviews',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans Bold',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0x80953154),
                    ),
                  ),
                  const SizedBox(height: 10),
                  
              // Grid view for reviews using GridView.count
              Expanded(
                child: GridView.count(
                  primary: true,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  crossAxisCount: 2,
                  children: <Widget>[
                    buildReviewCardPlaceholder(),
                    buildReviewCardPlaceholder(),
                    buildReviewCardPlaceholder(),
                    buildReviewCardPlaceholder(),
                    buildReviewCardPlaceholder(),
                    buildReviewCardPlaceholder(),
                  ],
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

  Widget buildBookCoverCard(Map<String, dynamic> book) {
    return GestureDetector(
      onTap: () {
        // Navigate to ViewBook with the selected book details
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

  Future<void> fetchSelectedBooks() async {
    const List<String> bookTitles = [
      'The Great Gatsby',
      '1984',
      'Pride and Prejudice',
      'Moby Dick',
      'War and Peace',
      'To Kill a Mockingbird',
    ];

    List<Map<String, dynamic>> fetchedBooks = [];

    for (String title in bookTitles) {
      final response = await http.get(Uri.parse(
          'https://openlibrary.org/search.json?title=${Uri.encodeQueryComponent(title)}'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final books = data['docs'];

        if (books.isNotEmpty) {
          final book = books[0];

          // Fetch detailed book information
          final bookDetailsResponse = await http.get(Uri.parse(
              'https://openlibrary.org${book['key']}.json'));

          if (bookDetailsResponse.statusCode == 200) {
            final bookDetails = json.decode(bookDetailsResponse.body);

            fetchedBooks.add({
              'title': book['title'],
              'author': book['author_name'] != null &&
                      book['author_name'].isNotEmpty
                  ? book['author_name'][0]
                  : 'Unknown Author',
              'imageUrl': book['cover_i'] != null
                  ? 'https://covers.openlibrary.org/b/id/${book['cover_i']}-L.jpg'
                  : 'https://via.placeholder.com/150',
              'description': bookDetails['description'] ??
                  'No description available', // Fallback description
            });
          }
        }
      }
    }

    setState(() {
      bookCovers = fetchedBooks;
      isLoading = false;
    });
  }
}
Widget buildReviewCardPlaceholder() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Container for the card (left: book cover, right: title, author, stars)
      Container(
        padding: const EdgeInsets.all(2),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left section: Book cover placeholder
            Container(
              width: 80,
              height: 110,
              decoration: BoxDecoration(
                color: Colors.grey[300], // Placeholder color
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            const SizedBox(width: 5), // Space between image and text

            // Right section: Text content
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // User avatar and username in a Row
                  Row(
                    children: [
                      // Avatar circle
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: Colors.grey[300], // Placeholder color
                          borderRadius: BorderRadius.circular(50),
                        ),
                      ),
                      const SizedBox(width: 5), // Space between avatar and username

                      // Username text
                      const Text(
                        'yanna',
                        style: TextStyle(
                          fontFamily: 'Josefin Sans Bold',
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 2, 2, 2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10), // Space between username and title

                  // Book title and author
                  const Text(
                    'The Silence',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans Bold',
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF953154),
                    ),
                  ),
                  const Text(
                    'by Author\'s name',
                    style: TextStyle(
                      fontFamily: 'Josefin Sans',
                      fontSize: 8,
                      fontWeight: FontWeight.normal,
                      color: Color.fromARGB(255, 0, 0, 0),
                    ),
                  ),
                  const SizedBox(height: 18), // Space between text and description

                  // Rating stars
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 3 ? Icons.star : Icons.star_border,
                        color: index < 3 ? Colors.amber : Colors.grey,
                        size: 15,
                      );
                    }),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      const SizedBox(height: 8), // Space between the card and the description section

      // Description
      const Text(
        'Aalalalla ansjsaa nd sjdnj dsdsds sd as njdws sjndjas',
        style: TextStyle(
          fontFamily: 'Josefin Sans',
          fontSize: 10,
          fontWeight: FontWeight.normal,
          color: Color.fromARGB(255, 0, 0, 0),
        ),
      ),
      const SizedBox(height: 8), // Space before hearts and likes section

      // Hearts section
      const Row(
        children: [
          Icon(
            Icons.favorite_border,
            color: Color(0xFF953154),
            size: 10,
          ),
          SizedBox(width: 4),
          Text(
            '1,234 hearts',
            style: TextStyle(
              fontFamily: 'Josefin Sans',
              fontSize: 10,
              fontWeight: FontWeight.normal,
              color: Color.fromARGB(255, 0, 0, 0),
            ),
          ),
        ],
      ),
    ],
  );
}