import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Sign up with email, password, full name, and username
  Future<User?> signUpWithEmailAndPassword(
      String email, String password, String fullName, String username) async {
    try {
      // Create user with email and password
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // If user is created successfully, store full name and username in Firestore
      User? user = userCredential.user;
      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'username': username,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });

        // Return the user
        return user;
      }
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
    return null;
  }


  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      return _handleAuthException(e);
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Reset password
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      print('Error: ${e.message}');
    }
  }

  // Get the current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Centralized error handling method
  User? _handleAuthException(FirebaseAuthException e) {
    String errorMessage;

    switch (e.code) {
      case 'user-not-found':
        errorMessage = 'No user found for that email.';
        break;
      case 'wrong-password':
        errorMessage = 'Wrong password provided for that user.';
        break;
      case 'email-already-in-use':
        errorMessage =
            'The email address is already in use by another account.';
        break;
      case 'weak-password':
        errorMessage = 'The password is too weak.';
        break;
      case 'invalid-email':
        errorMessage = 'The email address is not valid.';
        break;
      default:
        errorMessage = 'An error occurred. Please try again later.';
        break;
    }

    print(
        errorMessage); 
    return null; 
  }

  // Listen for auth state changes
  Stream<User?> authStateChanges() {
    return _auth.authStateChanges();
  }
}
