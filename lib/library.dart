import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:readify/edit_review.dart';
import 'package:readify/star_rating.dart';
import 'package:readify/view_book.dart';
import 'package:readify/firestore.dart';
import 'package:readify/view_review.dart';
import 'package:readify/book.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LibraryPage(),
    );
  }
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;
  final FirestoreService firestoreService = FirestoreService();
  final userId = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Column(
        children: [
          Container(
            color: const Color(0xFFFFFFE8),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF953154),
              labelColor: const Color(0xFF953154),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Reviews"),
                Tab(text: "Liked Books"),
                Tab(text: "Reading List"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('book_reviews') // First collection
                      .doc(userId) // Assuming a document for the user
                      .collection(
                          'review_books') // Second collection as subcollection
                      .orderBy('title', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    if (snapshot.hasError) {
                      return Center(child: Text("Error: ${snapshot.error}"));
                    }

                    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                      return const Center(child: Text("No reviews found"));
                    }

                    var reviews = snapshot.data!.docs; // List of documents
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      itemCount: reviews.length,
                      itemBuilder: (context, index) {
                        var review =
                            reviews[index].data() as Map<String, dynamic>;

                        // Extracting the fields from the review document
                        String title = review['title'] ?? 'No Title';
                        String author = review['author'] ?? 'Unknown Author';
                        String reviewText =
                            review['review'] ?? 'No Review Text';
                        int rating = review['rating'] ?? 0;
                        String imageUrl = review['imageUrl'] ?? '';

                        // Split the review text into words to check the length
                        List<String> words = reviewText.split(' ');
                        bool isLongReview = words.length > 30;

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 15),
                          elevation: 0,
                          color: Colors.transparent,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Placeholder for an image or thumbnail
                              Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(imageUrl),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                width: 60,
                                height: 80,
                              ),
                              const SizedBox(width: 16),

                              // Main review content
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Text(
                                      author,
                                      style:
                                          const TextStyle(color: Colors.grey),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(right: 125.0),
                                      child: StarRating(
                                        rating: rating,
                                        color: const Color(0xFFFFBEBE),
                                        onRatingSelected: (rating) {},
                                        size:
                                            20, // Slightly smaller size for better alignment with text
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    // Show review text with "See more" if it's long
                                    Text(
                                      isLongReview
                                          ? '${reviewText.substring(0, reviewText.indexOf(' ', 30))}...'
                                          : reviewText,
                                      style:
                                          const TextStyle(color: Colors.black),
                                      textAlign: TextAlign.justify,
                                    ),
                                    if (isLongReview)
                                      TextButton(
                                        onPressed: () {
                                          // Navigate to a new page to view the full review
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  FullReviewPage(
                                                      reviewText: reviewText),
                                            ),
                                          );
                                        },
                                        child: const Text(
                                          'See more',
                                          style: TextStyle(
                                            color: Color(0xFF953154),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),

                              // More options button
                              IconButton(
                                icon: const Icon(Icons.more_vert),
                                onPressed: () {
                                  showModalBottomSheet(
                                    backgroundColor: const Color(0xFFFFE9DE),
                                    context: context,
                                    builder: (context) {
                                      return Wrap(
                                        children: [
                                          ListTile(
                                            leading: const Icon(Icons.edit),
                                            iconColor: const Color(0xFF953154),
                                            title: const Text(
                                              'Edit',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditReview(
                                                    books: Book(
                                                      title: title,
                                                      author: author,
                                                      imageUrl: imageUrl,
                                                    ),
                                                    reviewDocId:
                                                        reviews[index].id,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                          ListTile(
                                            leading: const Icon(Icons.delete),
                                            iconColor: const Color(0xFF953154),
                                            title: const Text(
                                              'Delete',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            onTap: () {
                                              confirmDelete(
                                                context,
                                                reviews[index].id,
                                                () {
                                                  // Call your delete method here
                                                  firestoreService
                                                      .deleteReviews(
                                                          reviews[index].id);
                                                },
                                              );
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),

                // Liked Books Tab (Fetch user data from Firestore)
                UserBookStream(collection: 'liked_books'),

                // Reading List Tab (Fetch user data from Firestore)
                UserBookStream(collection: 'reading_list'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserBookStream extends StatelessWidget {
  final String collection;

  const UserBookStream({Key? key, required this.collection}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;

    if (userId == null) {
      return const Center(child: Text('Please log in to access your books.'));
    }

    // Conditional logic for handling different collections and paths
    if (collection == 'liked_books') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collection)
            .doc(userId) // Assuming each user has a subcollection of books
            .collection('books')
            .orderBy('title', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return _buildBookGrid(snapshot);
        },
      );
    } else if (collection == 'reading_list') {
      return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection(collection)
            .doc(userId) // Each user has their own document in reading_list
            .collection('books')
            .orderBy('title', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          return _buildBookGrid(snapshot);
        },
      );
    } else {
      return const Center(child: Text('Unknown collection'));
    }
  }

  // This method helps in creating a consistent grid display
  Widget _buildBookGrid(AsyncSnapshot<QuerySnapshot> snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (snapshot.hasError) {
      return Center(child: Text("Error: ${snapshot.error}"));
    }

    if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
      return const Center(child: Text("No books found"));
    }

    var books = snapshot.data!.docs;
    return GridView.builder(
      padding: const EdgeInsets.all(15),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 3,
        childAspectRatio: 0.6,
      ),
      itemCount: books.length,
      itemBuilder: (context, index) {
        var book = books[index].data() as Map<String, dynamic>;
        String title = book['title'] ?? 'No Title';
        String author = book['author'] ?? 'Unknown Author';
        String imageUrl = book['imageUrl'] ?? '';

        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: BookCard(
            title: title,
            author: author,
            imageUrl: imageUrl,
          ),
        );
      },
    );
  }
}

class BookCard extends StatelessWidget {
  final String title;
  final String author;
  final String imageUrl;

  const BookCard({
    Key? key,
    required this.title,
    required this.author,
    required this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: Colors.transparent,
      ),
      child: Column(
        children: [
          // Displaying the image
          Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                image: imageUrl.isNotEmpty
                    ? NetworkImage(imageUrl)
                    : const AssetImage('assets/placeholder.jpg')
                        as ImageProvider,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 7),
          // Title under the image
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            author,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

void confirmDelete(
    BuildContext context, String reviewId, Function deleteCallback) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Confirm Deletion'),
        content: Text('Are you sure you want to delete this review?'),
        actions: [
          TextButton(
            onPressed: () {
              // Close the dialog without doing anything
              Navigator.of(context).pop();
            },
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Perform the delete action
              deleteCallback();
              Navigator.of(context).pop(); // Close the dialog
            },
            child: Text('Delete'),
          ),
        ],
      );
    },
  );
}

void main() {
  runApp(const Library());
}
