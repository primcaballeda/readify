import 'package:flutter/material.dart';
import 'package:readify/library.dart';
import 'package:readify/profile.dart';
import 'package:readify/homepage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  RootPage({super.key});

  final int _bottomNavIndex = 0;
  final List<Widget> pages = const [
    HomePage(title: '',),
    Library(),
    ProfilePage(),
  ];

  final List<String> imageList = [
    'assets/home.png', 
    'assets/library.png',  
    'assets/person.png',  
  ];

  final List<String> imageListSelected = [
    'assets/chome.png', 
    'assets/clibrary.png',  
    'assets/cperson.png',  
  ];

  final List<String> titleList = [
    'Home',
    'Library',
    'Profile'
  ];

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  int _bottomNavIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

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
            width: 280, // Adjust the width as needed
            child: SizedBox(
              height: 50, // Set the height of the TextField
              child: TextField(
              style: const TextStyle(color: Color(0XFFFFD4D4)),
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                hintText: 'Search for books or people',
                hintStyle: TextStyle(color: Color(0x7F953154)),
                border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xFFFFD4D4), // Color for the border
                  width: 3.0, // Adjust width as needed
                ),
                ),
                focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(
                  color: Color(0xFFFFD4D4), // Color for the border when focused
                  width: 3.0, // Adjust width as needed
                ),
                ),
              ),
              onChanged: (value) {
                // Perform search functionality here
              },
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
                // Handle notification button press
              },
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFFFFFFE8),
      body: widget.pages[_bottomNavIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: const Color(0xFFFFFFE8),
        items: widget.imageList.asMap().map((index, icon) {
          return MapEntry(
            index,
            BottomNavigationBarItem(
              icon: Image.asset(
                _bottomNavIndex == index ? widget.imageListSelected[index] : icon,
                width: 24,  // Set the width of the image icon
                height: 24, // Set the height of the image icon
              ),
              label: widget.titleList[index],
            ),
          );
        }).values.toList(),
        currentIndex: _bottomNavIndex,
        selectedItemColor: const Color(0xFFFFBEBE),
        unselectedItemColor: const Color(0xFFFFBEBE),
        onTap: _onItemTapped,
      ),
    );
  }
}
