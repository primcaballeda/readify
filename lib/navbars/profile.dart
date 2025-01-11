import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:readify/crud/edit_profile.dart';
import 'package:readify/login_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? _getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  @override
  Widget build(BuildContext context) {
    final String? userId = _getCurrentUserId();

    if (userId == null) {
      return const Scaffold(
        body: Center(
          child: Text('User not authenticated.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Center(
        child: ListView(
          children: [
            const SizedBox(height: 100),
            // Profile Section with StreamBuilder
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userId)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('Error fetching profile.'),
                  );
                }

                final userData = snapshot.data?.data() as Map<String, dynamic>?;
                final fullname = userData?['fullName'] ?? 'Full Name';
                final username = userData?['username'] ?? 'Username';
                final avatarUrl = userData?['avatarUrl'] ?? '';

                return Column(
                  children: [
                    // Profile Picture
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      width: 100,
                      height: 100,
                      child: avatarUrl.isNotEmpty
                          ? ClipOval(
                              child: Image.asset(
                                avatarUrl,
                                fit: BoxFit.cover,
                                width: 100,
                                height: 100,
                              ),
                            )
                            : const CircleAvatar(
                              radius: 50,
                              backgroundColor: Color(0xFFFFBEBE),
                              child: Icon(
                              Icons.account_circle,
                              size: 100,
                              color: Colors.white,
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    // Profile Picture
                    // Full Name and Username
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          fullname,
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
                                                const EditProfilePage(),
                                          ),
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
                                        _auth.signOut();
                                        Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const LoginPage(),
                                          ),
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
                    Center(
                      child: Text(
                        '@$username',
                        style: const TextStyle(
                          fontFamily: 'Josefin Sans Regular',
                          fontSize: 18,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
            const SizedBox(height: 20),
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
                  .doc(userId)
                  .collection('books')
                  .orderBy('title', descending: true)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(
                    child: Text('Error fetching reading list.'),
                  );
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No books in your reading list.'),
                  );
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
                    final bookData = book.data() as Map<String, dynamic>;
                    final imageUrl = bookData['imageUrl'] ?? '';

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
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('book_reviews')
                  .doc(userId)
                  .collection('review_books')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError || !snapshot.hasData) {
                  return const Center(child: Text('Error fetching reviews.'));
                }

                if (snapshot.data!.docs.isEmpty) {
                  return const Center(child: Text('No reviews available.'));
                }

                final reviews = snapshot.data!.docs;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: reviews.length,
                  itemBuilder: (context, index) {
                    final reviewData =
                        reviews[index].data() as Map<String, dynamic>;
                    final title = reviewData['title'];
                    final rating = reviewData['rating'];

                    return buildRatedRow(title, rating, userId);
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
Widget buildRatedRow(String? title, int? rating, String? userId) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      // Circle Avatar with user's image from assets
      Padding(
        padding: const EdgeInsets.only(left: 10.0, top: 10),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(userId) // Assuming `userId` is provided
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show a loading indicator while fetching data
              return const CircleAvatar(
                backgroundColor: Color(0xFFFFBEBE),
              );
            }

            if (snapshot.hasError) {
              return const CircleAvatar(
                backgroundColor: Colors.grey,
              );
            }

            if (snapshot.hasData && snapshot.data != null) {
              final userData = snapshot.data!.data() as Map<String, dynamic>;
              final avatarUrl = userData['avatarUrl']; // Assuming 'avatarUrl' field exists

              return CircleAvatar(
                backgroundImage: avatarUrl != null
                    ? AssetImage(avatarUrl) // Fetch image from assets
                    : const AssetImage(
                        'assets/images/default_avatar.png'), // Fallback to a default avatar
                radius: 20,
              );
            } else {
              return const CircleAvatar(
                backgroundColor: Colors.grey,
              );
            }
          },
        ),
      ),
      const SizedBox(width: 16),
      // Text and stars
      if (title != null && rating != null)
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Wrapping the text after a certain number of words
              Wrap(
                spacing: 4.0,
                runSpacing: 4.0,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 15.0),
                    child: Text.rich(
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
                              child: Icon(Icons.star,
                                  color: Color(0xFFFFBEBE), size: 16),
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
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                  ),
                ],
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
