import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'package:readify/edit_profile.dart';
import 'package:readify/login_page.dart';
import 'package:readify/firestore.dart'; // Import your FirebaseServices class
import 'package:readify/star_rating.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirestoreService firestoreService = FirestoreService();
  String _fullname = 'Loading...';
  String _username = 'Loading...';
  bool _isLoading = true;
  String? reviewedTitle;
  int? reviewedRating;

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
  }

  // Fetch user profile data
  Future<void> _fetchUserProfile() async {
    // Fetch the current user's ID dynamically using FirebaseAuth
    String? userId = _getCurrentUserId();

    if (userId == null) {
      // Handle the case when the user is not authenticated
      print('User not authenticated');
      return;
    }

    // Fetch user profile from Firestore using the userId
    Map<String, String> userProfile =
        await firestoreService.getUserProfile(userId);

    setState(() {
      _fullname = userProfile['fullname'] ?? 'Full Name not found';
      _username = userProfile['username'] ?? 'Username not found';
      _isLoading = false;
    });
  }

  // Get the current user's ID from Firebase Authentication
  String? _getCurrentUserId() {
    return FirebaseAuth.instance.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 100),
            // Profile Picture Container
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.only(top: 20.0),
              decoration: BoxDecoration(
                color: Colors.pink[100],
                shape: BoxShape.circle,
              ),
              width: 200,
              height: 100,
            ),
            const SizedBox(height: 20),
            // Name and Username
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _isLoading
                    ? const CircularProgressIndicator()
                    : Text(
                        _fullname,
                        style: const TextStyle(
                          fontFamily: 'Josefin Sans Regular',
                          fontSize: 23,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                IconButton(
                  icon: const Icon(Icons.more_horiz),
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
                                'Edit Profile',
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
                                          const EditProfilePage()),
                                );
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.logout),
                              iconColor: const Color(0xFF953154),
                              title: const Text(
                                'Logout',
                                style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const LoginPage()),
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
            _isLoading
                ? const CircularProgressIndicator()
                : Center(
                    child: Text(
                      '@$_username',
                      style: const TextStyle(
                        fontFamily: 'Josefin Sans Regular',
                        fontSize: 18,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
            const SizedBox(height: 20),
            // Followers and Following Section
            const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text(
                      '123', // Number of followers
                      style: TextStyle(
                        fontFamily: 'Josefin Sans Regular',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Followers',
                      style: TextStyle(
                        fontFamily: 'Josefin Sans Regular',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    Text(
                      '89', // Number of following
                      style: TextStyle(
                        fontFamily: 'Josefin Sans Regular',
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Following',
                      style: TextStyle(
                        fontFamily: 'Josefin Sans Regular',
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 30),
            // Reading List Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Reading List',
                style: TextStyle(
                  fontFamily: 'Josefin Sans Regular',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 20),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('reading_list')
                  .doc(_getCurrentUserId())
                  .collection('books')
                  .orderBy('title', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error fetching reading list.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                      child: Text('No books in your reading list.'));
                }

                final books = snapshot.data!.docs;

                return CarouselSlider(
                  options: CarouselOptions(
                    height: 150.0,
                    autoPlay: false,
                    enableInfiniteScroll: true,
                    viewportFraction: 0.4,
                    enlargeCenterPage: true,
                  ),
                  items: books.map((book) {
                    final imageUrl = book['imageUrl'] as String? ?? '';
                    return Builder(
                      builder: (BuildContext context) {
                        return Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 5.0),
                          decoration: BoxDecoration(
                            color: Colors.pink[50],
                            borderRadius: BorderRadius.circular(10.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(10.0),
                                  child: Image.network(
                                    imageUrl,
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : const Center(
                                  child: Text(
                                    'No Image',
                                    style: TextStyle(
                                      fontFamily: 'Josefin Sans Regular',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                        );
                      },
                    );
                  }).toList(),
                );
              },
            ),
            const SizedBox(height: 30),
            // Reviews Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0),
              child: Text(
                'Reviews',
                style: TextStyle(
                  fontFamily: 'Josefin Sans Regular',
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // StreamBuilder to listen to review updates
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('book_reviews') // First collection: book_reviews
                  .doc(_getCurrentUserId()) // User's specific document
                  .collection('review_books') // Second collection: review_books
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Error fetching reviews.'));
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No reviews available.'));
                }

                final reviewDataList = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics:
                      const NeverScrollableScrollPhysics(), // To prevent nested scrolling issues
                  itemCount: reviewDataList.length,
                  itemBuilder: (context, index) {
                    final reviewData =
                        reviewDataList[index].data() as Map<String, dynamic>;
                    final reviewedTitle = reviewData['title'];
                    final reviewedRating = reviewData['rating'];

                    return buildRatedRow(reviewedTitle, reviewedRating);
                  },
                );
              },
            ),

            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget buildRatedRow(String? title, int? rating) {
    return Row(
      children: [
        // Grey circle
        Padding(
          padding: const EdgeInsets.only(left: 10.0, top: 10),
          child: Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 16),
        // Text and stars
        if (title != null && rating != null)
          Text.rich(
            TextSpan(
              text: 'You rated $title ',
              style: const TextStyle(
                fontSize: 13,
                color: Colors.black,
              ),
              children: [
                ...List.generate(
                  rating,
                  (index) => const WidgetSpan(
                    child: Icon(Icons.star, color: Color(0xFFFFBEBE), size: 16),
                  ),
                ),
                ...List.generate(
                  5 - rating, // Remaining empty stars
                  (index) => const WidgetSpan(
                    child: Icon(Icons.star_border,
                        color: Color(0xFFFFBEBE), size: 16),
                  ),
                ),
              ],
            ),
          )
        else
          const Text(
            'No review available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black54,
            ),
          ),
      ],
    );
  }
}
