import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final String bookName;

  const BookDetailsPage({Key? key, required this.bookName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(bookName),
      ),
      body: Center(
        child: Text('Details for $bookName'),
      ),
    );
  }
}

// The SearchResultsPage accepts the searchQuery parameter and displays it.
class Searchbar extends StatelessWidget {
  final String searchQuery;

  const Searchbar({Key? key, required this.searchQuery}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // You can replace this with actual search results later.
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results for "$searchQuery"'),
      ),
      body: Center(
        child: Text('Showing results for "$searchQuery"'),
      ),
    );
  }
}

class BookSearch extends StatefulWidget {
  @override
  _BookSearchState createState() => _BookSearchState();
}

class _BookSearchState extends State<BookSearch> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  final TextEditingController _controller = TextEditingController();

  final List<Map<String, String>> books = [
    {'title': 'To Kill a Mockingbird', 'author': 'Harper Lee'},
    {'title': '1984', 'author': 'George Orwell'},
    {'title': 'The Great Gatsby', 'author': 'F. Scott Fitzgerald'},
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Searchbar(searchQuery: query),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFE8),
      appBar: AppBar(
        title: const Text('Search Books'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Books'),
            Tab(text: 'People'),
          ],
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                _onSearchSubmitted(_controller.text);
              },
            ),
          ),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Search for books or people',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: () {
                        _onSearchSubmitted(_controller.text);
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: _onSearchSubmitted, // Handle "Done" or "Enter" press
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: books.length,
                  itemBuilder: (context, index) {
                    final book = books[index];
                    return ListTile(
                      title: Text(book['title']!),
                      subtitle: Text('by ${book['author']}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BookDetailsPage(bookName: book['title']!),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
          const Center(
            child: Text('People search is not implemented yet.'),
          ),
        ],
      ),
    );
  }
}
