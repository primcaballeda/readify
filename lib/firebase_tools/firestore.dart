import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference bookReviews =
      FirebaseFirestore.instance.collection('book_reviews');
  final CollectionReference likedBooks =
      FirebaseFirestore.instance.collection('liked_books');
  final CollectionReference readingList =
      FirebaseFirestore.instance.collection('reading_list');
  final CollectionReference users =
      FirebaseFirestore.instance.collection('users');

  // Helper to get the current user ID
  String? _getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<Map<String, String>> getBookAndUserIds() async {
    try {
      final userId = _getCurrentUserId();
      if (userId != null) {
        // Fetch all review books for the current user
        final userReviewsSnapshot =
            await bookReviews.doc(userId).collection('review_books').get();

        Map<String, String> bookAndUserIds = {};
        // Add each bookId and userId to the map
        for (var doc in userReviewsSnapshot.docs) {
          String bookId = doc.id; // Book document ID is the bookId
          bookAndUserIds[bookId] = userId; // Map bookId to userId
        }
        return bookAndUserIds;
      }
      return {};
    } catch (e) {
      print("Error fetching book and user IDs: $e");
      return {};
    }
  }

  // Create
  Future<void> addReview(String title, String author, String review, int rating,
      String imageUrl) async {
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

  Future<void> addToReadingList(
      String title, String author, String description, String imageUrl) async {
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

  Future<void> addToLikedBooks(
      String title, String author, String description, String imageUrl) async {
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

    return {
      'fullname': 'Not Found',
      'username': 'Not Found',
      'email': 'Not Found'
    };
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

  Future<List<Map<String, dynamic>>> fetchAllReviewsWithUsernames() async {
    try {
      List<Map<String, dynamic>> allReviewsWithUsernames = [];

      // 1. Fetch all user documents from the "book_reviews" collection
      final QuerySnapshot<Map<String, dynamic>> reviewsSnapshot =
          await FirebaseFirestore.instance.collection('book_reviews').get();

      print(
          "Fetched book_reviews collection: ${reviewsSnapshot.docs.length} documents");

      // 2. Iterate through each user document in the "book_reviews" collection
      for (var userDoc in reviewsSnapshot.docs) {
        final userId = userDoc.id;

        // 3. Fetch the username for each user from the "users" collection
        final userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .get();

        if (userSnapshot.exists) {
          String username = userSnapshot.data()?['username'] ?? 'Unknown User';
          print("Found username for userId $userId: $username");

          // 4. Fetch reviews from the "review_books" subcollection for this user
          final userReviewsSnapshot =
              await userDoc.reference.collection('review_books').get();

          print(
              "Found ${userReviewsSnapshot.docs.length} reviews for userId $userId");

          // 5. Iterate over the reviews and add each review with the username to the list
          for (var reviewDoc in userReviewsSnapshot.docs) {
            final reviewData = reviewDoc.data();
            final reviewText = reviewData['review'] ?? 'No review available';
            final imageUrl =
                reviewData['imageUrl'] ?? 'https://via.placeholder.com/150';

            // Add the review along with the username and image URL
            allReviewsWithUsernames.add({
              'username': username,
              'review': reviewText,
              'imageUrl': imageUrl,
            });
          }
        } else {
          print("No user data found for userId $userId");
        }
      }

      print("Total reviews fetched: ${allReviewsWithUsernames.length}");
      return allReviewsWithUsernames;
    } catch (e) {
      print("Error fetching all reviews with usernames: $e");
      return [];
    }
  }

  Stream<QuerySnapshot> getReadingList() {
    final userId = _getCurrentUserId();
    if (userId != null) {
      return readingList
          .doc(userId)
          .collection('books')
          .orderBy('title')
          .snapshots();
    } else {
      print("User is not authenticated");
      return Stream.empty();
    }
  }

  Stream<QuerySnapshot> getLikedBooks() {
    final userId = _getCurrentUserId();
    if (userId != null) {
      return likedBooks
          .doc(userId)
          .collection('books')
          .orderBy('title')
          .snapshots();
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
      return bookReviews
          .doc(userId)
          .collection('review_books')
          .orderBy('title')
          .snapshots();
    } else {
      print("User is not authenticated");
      return Stream.empty();
    }
  }

  Future<bool> isBookInReadingList(
      String title, String author, String description, String imageUrl) async {
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

  Future<bool> isBookInLikedBooks(
      String title, String author, String description, String imageUrl) async {
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
  Future<void> updateUserProfile(
      String docID, String fullname, String username, String avatarUrl) async {
    try {
      await users.doc(docID).update({
        'fullName': fullname,
        'username': username,
        'avatarUrl': avatarUrl, // Adding avatarUrl field
      });
      print('Updating profile for docID: $docID');
    } catch (e) {
      print('Error updating user data: $e');
    }
  }

  Future<void> editReview(String docID, String title, String author,
      String imageUrl, String newReview, int newRating) async {
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

  Future<void> deleteLikedBooks(String docID) async {
    final userId = _getCurrentUserId();
    if (userId != null) {
      try {
        await likedBooks.doc(userId).collection('books').doc(docID).delete();
        print("Book deleted from liked books successfully!");
      } catch (e) {
        print("Error deleting review: $e");
      }
    } else {
      print("User is not authenticated");
    }
  }
}
