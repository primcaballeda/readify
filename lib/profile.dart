import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Add this package for the carousel

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false, // Removes debug banner
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Center(
        child: Center(
          child: ListView(
            children: [
              const SizedBox(height: 100),
              // Profile Picture Container
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.only(top: 20.0),
                decoration: BoxDecoration(
                  color: Colors.pink[100], // Set the color of the container
                  shape: BoxShape.circle, // Make the container round
                ),
                width: 200, // Set the width of the container
                height: 100, // Set the height of the container
              ),
              const SizedBox(height: 20),
              // Name and Username
              const Center(
                child: Text(
                  'Princess Caballeda',
                  style: TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Center(
                child: Text(
                  '@primilily',
                  style: TextStyle(
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
              // Carousel for Cards
              CarouselSlider(
                options: CarouselOptions(
                  height: 150.0, // Set the height of the cards
                  autoPlay: false,
                  enableInfiniteScroll: true,
                  viewportFraction: 0.3, // Controls the width of the cards relative to the viewport
                  enlargeCenterPage: false, // Keeps the cards the same size
                ),
                items: [1, 2, 3].map((i) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: 100, // Fixed width for the cards
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.pink[50],
                          borderRadius: BorderRadius.circular(10.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.5),
                              blurRadius: 5,
                              offset: const Offset(0, 3), // Shadow position
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Card $i',
                            style: const TextStyle(
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
              buildRatedRow(),
              const SizedBox(height: 16), // Add some spacing
              buildRatedRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildRatedRow() {
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
        const SizedBox(width: 16), // Spacing between the circle and text
        // Text and stars
        const Text.rich(
          TextSpan(
            text: 'You rated Wicked ',
            style: TextStyle(
              fontSize: 16,
              color: Colors.black,
            ),
            children: [
              WidgetSpan(
                child: Icon(Icons.star, color: Color(0xFFFFBEBE), size: 16),
              ),
              WidgetSpan(
                child: Icon(Icons.star, color: Color(0xFFFFBEBE), size: 16),
              ),
              WidgetSpan(
                child: Icon(Icons.star, color: Color(0xFFFFBEBE), size: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

