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
  String _selectedAvatar = '';
  bool _isLoading = true;

  final TextEditingController _fullnameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();

  final FirestoreService firestoreService = FirestoreService();

  List<String> avatarPaths = [
    'assets/avatar/prim1.jpg',
    'assets/avatar/prim2.jpg',
    'assets/avatar/prim3.jpg',
    'assets/avatar/prim4.jpg',
  ];

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _fetchUserProfile() async {
    String? userId = _getCurrentUserId();

    if (userId == null) {
      print('User not authenticated');
      return;
    }

    Map<String, String> userProfile = await firestoreService.getUserProfile(userId);

    setState(() {
      _fullname = userProfile['fullname'] ?? 'Full Name not found';
      _username = userProfile['username'] ?? 'Username not found';
      _selectedAvatar = userProfile['avatar'] ?? avatarPaths[0]; // Default avatar

      _isLoading = false;
      _fullnameController.text = _fullname;
      _usernameController.text = _username;
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
      await firestoreService.updateUserProfile(
        userId,
        _fullnameController.text,
        _usernameController.text,
        _selectedAvatar // Save the selected avatar
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profile updated successfully')),
      );

      await _fetchUserProfile();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: const Color(0xFFFFFFE8),
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
                const Text(
                  'Profile Picture',
                  style: TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 20,
                    color: Color(0xFF953154),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Center(
                  child: Column(
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage(_selectedAvatar),
                        backgroundColor: const Color(0xFFFFBEBE),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Tap an avatar below to select',
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: avatarPaths.length,
                  itemBuilder: (context, index) {
                    final avatarPath = avatarPaths[index];
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedAvatar = avatarPath;
                        });
                      },
                      child: CircleAvatar(
                        backgroundImage: AssetImage(avatarPath),
                        backgroundColor: _selectedAvatar == avatarPath
                            ? Colors.greenAccent
                            : Colors.transparent,
                      ),
                    );
                  },
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
                const SizedBox(height: 30),

                // Save Button
                Align(
                  alignment: Alignment.centerRight,
                  child: SizedBox(
                    width: 120,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFFBEBE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () async {
                        await _saveProfileChanges();
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
