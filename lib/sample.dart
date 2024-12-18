import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ReadingListPage extends StatelessWidget {
  final String userId;

  ReadingListPage({required this.userId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Reading List'),
        backgroundColor: const Color(0xFF953154),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .doc(userId)  // Accessing user data using userId
            .collection('reading_list')  // Accessing the reading_list sub-collection
            .orderBy('addedAt', descending: true) // Sort by the time the book was added
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No books in your reading list.'));
          }

          final books = snapshot.data!.docs;

          return ListView.builder(
            itemCount: books.length,
            itemBuilder: (context, index) {
              var bookData = books[index];
              return ListTile(
                leading: Image.network(bookData['imageUrl']),  // Book image
                title: Text(bookData['title']),  // Book title
                subtitle: Text(bookData['author']),  // Book author
                trailing: IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    deleteBookFromReadingList(bookData.id);  // Call to delete the book
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Delete book from reading list
  void deleteBookFromReadingList(String bookId) {
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('reading_list')
        .doc(bookId)  // Document reference to the specific book
        .delete()
        .then((value) {
          print('Book removed from reading list');
        })
        .catchError((error) {
          print('Error removing book from reading list: $error');
        });
  }
}
