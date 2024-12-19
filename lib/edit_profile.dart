import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firestore.dart'; // Assuming this file contains your Firestore operations

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  String _fullname = '';
  String _username = '';
  String _email = '';
  bool _isLoading = true;

  // Create TextEditingControllers
  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    // Fetch the current user's ID dynamically using FirebaseAuth
    String? userId = _getCurrentUserId();

    if (userId == null) {
      // Handle the case when the user is not authenticated
      print('User not authenticated');
      return;
    }

    // Fetch user profile from Firestore using the userId
    Map<String, String> userProfile = await firestoreService.getUserProfile(userId);

    setState(() {
      _email = userProfile['email'] ?? 'Email not found';
      _fullname = userProfile['fullname'] ?? 'Full Name not found';
      _username = userProfile['username'] ?? 'Username not found';
      _isLoading = false;

      // Update the controllers with the fetched data
      _fullnameController.text = _fullname;
      _usernameController.text = _username;
      _emailController.text = _email;
    });
  }

  String? _getCurrentUserId() {
    User? user = FirebaseAuth.instance.currentUser;
    return user?.uid;
  }
Future<void> _saveProfileChanges() async {
  String? userId = _getCurrentUserId();

  if (userId == null) {
    print('User not authenticated');
    return;
  }

  try {
    // Update the user profile with the new data
    await firestoreService.updateUserProfile(
      userId,
      _fullnameController.text,
      _usernameController.text,
      _emailController.text,
    );

    // Notify user of successful update
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile updated successfully')),
    );

    // Refresh the profile data after update
    await _fetchUserProfile();  // Re-fetch the updated profile data
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error updating profile: $e')),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8), // Light yellow background
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFFFFFFE8), // Light yellow
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 20,
                    color: const Color(0xFF953154),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Center(
                  child: Column(
                    
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xFFFFBEBE),
                        
                      ),
                      const SizedBox(height: 10),
                      
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Name Field
                const Text(
                  'Name',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                _isLoading
                    ? const CircularProgressIndicator()
                    : TextField(
                        controller: _fullnameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),

                // Username Field
                const Text(
                  'Username',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                _isLoading
                    ? const CircularProgressIndicator()
                    : TextField(
                        controller: _usernameController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                        ),
                      ),
                const SizedBox(height: 20),

                // Email Field
                const Text(
                  'Email',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 8),
                _isLoading
                    ? const CircularProgressIndicator()
                    : TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Color(0xFFFFD4D4), width: 3.0),
                          ),
                        ),
                      ),
                const SizedBox(height: 30),

                // Save Button
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBEBE), // Light pink
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                        onPressed: () async {
                        await _saveProfileChanges();
                        setState(() {});
                        },
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontFamily: 'Josefin Sans Regular',
                          color: Color(0xFF953154),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
