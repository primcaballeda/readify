import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference bookReviews = FirebaseFirestore.instance.collection('book_reviews');
  final CollectionReference likedBooks = FirebaseFirestore.instance.collection('liked_books');
  final CollectionReference readingList = FirebaseFirestore.instance.collection('reading_list');
  final CollectionReference users = FirebaseFirestore.instance.collection('users');

  // Helper to get the current user ID
  String? _getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  // Create
  Future<void> addReview(String title, String author, String review, int rating, String imageUrl) async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      try {
        await bookReviews.doc(userId).collection('review_books').add({
          'title': title,
          'author': author,
          'review': review,
          'rating': rating,
          'imageUrl': imageUrl,
        });
      } catch (e) {
        print("Error adding review: $e");
      }
    } else {
      print("User is not authenticated");
    }
  }

  Future<void> addToReadingList(String title, String author, String description, String imageUrl) async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      try {
        await readingList.doc(userId).collection('books').add({
          'title': title,
          'author': author,
          'description': description,
          'imageUrl': imageUrl,
        });
      } catch (e) {
        print("Error adding to reading list: $e");
      }
    } else {
      print("User is not authenticated");
    }
  }

  Future<void> addToLikedBooks(String title, String author, String description, String imageUrl) async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      try {
        await likedBooks.doc(userId).collection('books').add({
          'title': title,
          'author': author,
          'description': description,
          'imageUrl': imageUrl,
        });
      } catch (e) {
        print("Error adding to liked books: $e");
      }
    } else {
      print("User is not authenticated");
    }
  }

  // Read
  Future<Map<String, String>> getUserProfile(String userId) async {
    try {
      DocumentSnapshot snapshot = await users.doc(userId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String fullname = data['fullName'] ?? 'Full Name not found';
        String username = data['username'] ?? 'Username not found';
        String email = data['email'] ?? 'Email not found';

        return {'fullname': fullname, 'username': username, 'email': email};
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return {'fullname': 'Error', 'username': 'Error', 'email': 'Error'};
    }

    return {'fullname': 'Not Found', 'username': 'Not Found', 'email': 'Not Found'};
  }

  Future<Map<String, dynamic>> fetchReview(String docID) async {
    try {
      DocumentSnapshot snapshot = await bookReviews
          .doc(_getCurrentUserId())
          .collection('review_books')
          .doc(docID)
          .get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        print("Review not found.");
        return {};
      }
    } catch (e) {
      print("Error fetching review: $e");
      return {};
    }
  }

  Stream<QuerySnapshot> getReadingList() {
    final userId = _getCurrentUserId();
    if (userId != null) {
      return readingList.doc(userId).collection('books').orderBy('title').snapshots();
    } else {
      print("User is not authenticated");
      return Stream.empty();
    }
  }

  Stream<QuerySnapshot> getLikedBooks() {
    final userId = _getCurrentUserId();
    if (userId != null) {
      return likedBooks.doc(userId).collection('books').orderBy('title').snapshots();
    } else {
      print("User is not authenticated");
      return Stream.empty();
    }
  }

  Stream<QuerySnapshot> getReviewsForBook(String title) {
    return bookReviews.where('title', isEqualTo: title).snapshots();
  }

  Stream<QuerySnapshot> getUserReviews() {
    final userId = _getCurrentUserId();
    if (userId != null) {
      return bookReviews.doc(userId).collection('review_books').orderBy('title').snapshots();
    } else {
      print("User is not authenticated");
      return Stream.empty();
    }
  }

  Future<bool> isBookInReadingList(String title, String author, String description, String imageUrl) async {
    try {
      final userId = _getCurrentUserId();
      if (userId != null) {
        final querySnapshot = await readingList
            .doc(userId)
            .collection('books')
            .where('title', isEqualTo: title)
            .where('author', isEqualTo: author)
            .where('description', isEqualTo: description)
            .where('imageUrl', isEqualTo: imageUrl)
            .get();

        return querySnapshot.docs.isNotEmpty;
      }
      return false;
    } catch (e) {
      print('Error checking if book is in reading list: $e');
      return false;
    }
  }

  Future<bool> isBookInLikedBooks(String title, String author, String description, String imageUrl) async {
    try {
      final userId = _getCurrentUserId();
      if (userId != null) {
        final querySnapshot = await likedBooks
            .doc(userId)
            .collection('books')
            .where('title', isEqualTo: title)
            .where('author', isEqualTo: author)
            .where('description', isEqualTo: description)
            .where('imageUrl', isEqualTo: imageUrl)
            .get();

        return querySnapshot.docs.isNotEmpty;
      }
      return false;
    } catch (e) {
      print('Error checking if book is in liked books: $e');
      return false;
    }
  }

  // Update
  Future<void> updateUserProfile(String docID, String fullname, String username, String email) async {
    try {
      await users.doc(docID).update({
        'fullName': fullname,
        'username': username,
        'email': email,
      });
      print('Updating profile for docID: $docID');

    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> editReview(String docID, String title, String author, String imageUrl, String newReview, int newRating) async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      try {
        await bookReviews
            .doc(userId)
            .collection('review_books')
            .doc(docID)
            .update({
              'title': title,
              'author': author,
              'imageUrl': imageUrl,
              'review': newReview,
              'rating': newRating,
            });
        print("Review updated successfully!");
      } catch (e) {
        print("Error updating review: $e");
      }
    } else {
      print("User is not authenticated");
    }
  }

  // Delete
  Future<void> deleteReviews(String docID) async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      try {
        await bookReviews
            .doc(userId)
            .collection('review_books')
            .doc(docID)
            .delete();
        print("Review deleted successfully!");
      } catch (e) {
        print("Error deleting review: $e");
      }
    } else {
      print("User is not authenticated");
    }
  }
}
