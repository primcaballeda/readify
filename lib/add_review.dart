import 'package:flutter/material.dart';
import 'package:readify/star_rating.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AddReview(),
    );
  }
}

class AddReview extends StatefulWidget {
  const AddReview({super.key});

  @override
  State<AddReview> createState() => AddReviewState();
}

class AddReviewState extends State<AddReview> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: const Color(0xFFFFD4D4).withOpacity(0.5),
        ),
        leading: Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: IconButton(
            icon: const Icon(Icons.close, color: Color(0xFF953154)),
            onPressed: () {
              Navigator.pop(context); // Close the search page
            },
          ),
        ),
        title: const Text(
          'Add Review',
          style: TextStyle(
            fontFamily: 'Josefin Sans Regular',
            fontSize: 20,
            color: Color(0xFF953154),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.check, color: Color(0xFF953154)),
            onPressed: () {},
          )
        ],
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Card(
                    color: Color(0xFFFFD4D4),
                    child: SizedBox(
                      width: 100.0,
                      height: 150.0,
                    ),
                  ),
                  const SizedBox(width: 16.0), // Spacing between the card and the text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Title',
                          style: TextStyle(
                            fontFamily: 'Josefin Sans Regular',
                            fontSize: 20,
                            color: Color(0xFF953154),
                          ),
                        ),
                        const SizedBox(height: 5.0), // Spacing between the two texts
                        const Text(
                          'by Author name',
                          style: TextStyle(
                            fontFamily: 'Josefin Sans Regular',
                            fontSize: 15,
                            color: Color(0xFF953154),
                          ),
                        ),
                        const SizedBox(height: 50),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end, // Align the content to the right
                          children: [
                            Column(
                              mainAxisSize: MainAxisSize.min, // Ensure it wraps tightly around the content
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 20.0), // Space between icon and text
                                  child: Image.asset(
                                    'assets/heart.png',
                                    width: 34.0,
                                    height: 34.0,
                                    color: const Color(0xFFFFD4D4),
                                  ),
                                ),
                                const SizedBox(height: 5),
                                GestureDetector(
                                  onTap: () {
                                    // Add your onTap code here
                                  },
                                  child: const Padding(
                                    padding: EdgeInsets.only(right: 20.0),
                                    child: Text(
                                      'Like',
                                      style: TextStyle(
                                        fontFamily: 'Josefin Sans Regular',
                                        fontSize: 15,
                                        color: Color(0xFF953154),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20.0), // Add spacing before the divider
                      ],
                    ),
                  ),
                ],
              ),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color(0xFF953154),
                      thickness: 1.0,
                      indent: 0.0, // Add spacing on the left
                      endIndent: 0.0, // Add spacing on the right
                    ),
                  ),
                  SizedBox(width: 4.0), // Space matching the heart icon width
                ],
              ),
              const SizedBox(height: 20.0), // Add spacing before star rating
              const StarRating(), // Add the StarRating widget here
              const SizedBox(height: 20.0), // Add spacing after star rating
              const Center(
                child: Text(
                  'Rate this book',
                  style: TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 16,
                    color: Color.fromARGB(255, 0, 0, 0),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Color.fromARGB(255, 122, 117, 119),
                      thickness: 1.0,
                      indent: 0.0, // Add spacing on the left
                      endIndent: 0.0, // Add spacing on the right
                    ),
                  ),
                  SizedBox(width: 4.0), // Space matching the heart icon width
                ],
              ),
              SizedBox(height: 10),
              const Text(
                'Review',
                style: TextStyle(
                  fontFamily: 'Josefin Sans Regular',
                  fontSize: 20,
                  color: Color(0xFF953154),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Write your review here',
                  hintStyle: const TextStyle(
                    fontFamily: 'Josefin Sans Regular',
                    fontSize: 15,
                    color: Color(0xFF000000),
                  ),
                  border: const OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF953154),
                      width: 3.0,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: const Color(0xFF953154).withOpacity(0.5),
                      width: 2.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xFF953154).withOpacity(0.5),
                      width: 2.0,
                    ),
                  ),
                ),
              )
              
              
            ],
            
            
          ),
        ),
      ),
    );
  }
}
