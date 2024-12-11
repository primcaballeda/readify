import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:http/http.dart' as http;
import 'package:readify/book_search.dart';
import 'package:readify/view_book.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(title: 'Home Page'),
    );
  }
}

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
    fetchTopBooks();
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
              Expanded(child: buildBookCoverCard(bookCovers[i]['thumbnail'])),
              if (i + 1 < bookCovers.length)
                Expanded(child: buildBookCoverCard(bookCovers[i + 1]['thumbnail'])),
              if (i + 2 < bookCovers.length)
                Expanded(child: buildBookCoverCard(bookCovers[i + 2]['thumbnail'])),
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
            ? const Center(child: CircularProgressIndicator())
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
                  const SizedBox(height: 10),
                  // Wrap CarouselSlider inside SingleChildScrollView
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
                      primary: false,
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
                        'username',
                        style: TextStyle(
                          fontFamily: 'Josefin Sans Bold',
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF953154),
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



  Widget buildBookCoverCard(String bookCoverUrl) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ViewBook()),
        );
      },
      child:
         Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible( // Use Flexible to allow the image to adjust
                child: Container(
                  width: 100,
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.network(
                      bookCoverUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.image_not_supported,
                            size: 100, color: Colors.grey);
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      
    );
  }

  Future<void> fetchTopBooks() async {
    const String url = 'https://openlibrary.org/search.json?q=top+books&limit=6';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List items = data['docs'];

        setState(() {
          bookCovers = items.map((item) {
            return {
              'thumbnail': item['cover_i'] != null
                  ? 'https://covers.openlibrary.org/b/id/${item['cover_i']}-M.jpg'
                  : 'https://via.placeholder.com/150',
            };
          }).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load books');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching books: $e');
    }
  }
}
