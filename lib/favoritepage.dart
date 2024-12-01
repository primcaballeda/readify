import 'package:flutter/material.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  State<FavoritePage> createState() => _FavoritePage();
}

class _FavoritePage extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

      body: Center(
        child: Text('Favorite Page'),
        
      ),
    );
  }
}