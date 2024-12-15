import 'package:flutter/material.dart';
import 'package:readify/edit_review.dart';

class Library extends StatelessWidget {
  const Library({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LibraryPage(),
    );
  }
}

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}

class _LibraryPageState extends State<LibraryPage>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose(); // Disposing the TabController
    super.dispose(); // Make sure to call super.dispose() here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      backgroundColor: const Color(0xFFFFFFE8),
      body: Column(
        children: [
          Container(
            
            color: const Color(0xFFFFFFE8),
            child: TabBar(
              controller: _tabController,
              indicatorColor: const Color(0xFF953154),
              labelColor: const Color(0xFF953154),
              unselectedLabelColor: Colors.grey,
              tabs: const [
                Tab(text: "Reviews"),
                Tab(text: "Liked Books"),
                Tab(text: "Reading List"),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ListView.builder(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 15),
                      elevation: 0,
                      color: Colors
                          .transparent, // Set Card background color to transparent
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 60,
                            height: 80,
                            color: const Color.fromARGB(255, 255, 164,
                                222), // Placeholder for the image
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Block Blast",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                Text(
                                  "by Author",
                                  style: TextStyle(color: Colors.grey),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    Icon(Icons.star,
                                        color: Colors.amber, size: 16),
                                    Icon(Icons.star_border,
                                        color: Colors.amber, size: 16),
                                    Icon(Icons.star_border,
                                        color: Colors.amber, size: 16),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  "Beneath the serene twilight, a soft breeze whispered through the grove, carrying with it the faintest echo of a distant melody. The lanterns flickered gently, casting a warm, golden hue over the meadow. As the shimmer of starlight danced on the rippling surface of the nearby lake, a faint ripple of memories stirred. In the tranquil air, the nimbus clouds drifted lazily across the horizon, while the distant glow of a lantern flickered in the calm. The journey ahead seemed uncertain, but the path was illuminated by the glow of dreams, guiding like a prism of hope through the night.",
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.justify,
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.more_vert),
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
                                          'Edit',
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
                                                    const EditReview()),
                                          );
                                        },
                                      ),
                                      ListTile(
                                        leading: const Icon(Icons.delete),
                                        iconColor: const Color(0xFF953154),
                                        title: const Text(
                                          'Delete',
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        onTap: () {
                                          // Handle delete action
                                          Navigator.pop(context);
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
                    );
                  },
                ),
                Center(
                  child: const Text("Your Liked Books will appear here."),
                ),
                const Center(
                  child: Text("Your Reading List will appear here."),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const Library());
}
