import 'package:flutter/material.dart';
import 'package:readify/login_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFE8),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(
              'https://media1.tenor.com/m/Qlvyx-LIYiAAAAAC/hu-tao.gif',
              height: 300,
              width: 300,
              fit: BoxFit.cover,
            ),
            const SizedBox(height: 20),
            const Text(
              'You Did It!',
              style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              ),
            ),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
              },
              child: const Text("Log Out"),
            )
            ],
        ),
      ),
    );
  }
}