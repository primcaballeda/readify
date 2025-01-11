import 'package:flutter/material.dart';
import 'package:readify/tools/book.dart';
import 'package:readify/notifications.dart';

class CustomAppBarBottomNav extends StatelessWidget {
  final String searchQuery;
  final bool isLoading;
  final List<Book> books;
  final Function(String) onSearchChanged;
  final int bottomNavIndex;
  final Function(int) onBottomNavTapped;
  final List<Widget> pages;

  const CustomAppBarBottomNav({
    Key? key,
    required this.searchQuery,
    required this.isLoading,
    required this.books,
    required this.onSearchChanged,
    required this.bottomNavIndex,
    required this.onBottomNavTapped,
    required this.pages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: const Color(0xFFFFFFE8),
        ),
        title: Padding(
          padding: const EdgeInsets.only(left: 2),
          child: SizedBox(
            width: 280,
            child: SizedBox(
              height: 50,
              child: TextField(
                style: const TextStyle(color: Color(0XFFFFD4D4)),
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  hintText: 'Search for books or people',
                  hintStyle: TextStyle(color: Color(0x7F953154)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xFFFFD4D4),
                      width: 3.0,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20.0)),
                    borderSide: BorderSide(
                      color: Color(0xFFFFD4D4),
                      width: 3.0,
                    ),
                  ),
                ),
                onChanged: onSearchChanged, // Update search query on input change
              ),
            ),
          ),
        ),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20.0),
            child: IconButton(
              icon: Image.asset(
                'assets/notif_bell.png',
                width: 35,
                height: 35,
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const Notifications()),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFE8),
        items: const [
          BottomNavigationBarItem(
            icon: Image(image: AssetImage('assets/home.png')),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Image(image: AssetImage('assets/library.png')),
            label: 'Library',
          ),
          BottomNavigationBarItem(
            icon: Image(image: AssetImage('assets/person.png')),
            label: 'Profile',
          ),
        ],
        currentIndex: bottomNavIndex,
        selectedItemColor: const Color(0xFFFFBEBE),
        unselectedItemColor: const Color(0xFFFFBEBE),
        onTap: onBottomNavTapped,
      ),
    );
  }
}
