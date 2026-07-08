import 'package:flutter/material.dart';

import 'screens/home_screen.dart';

void main() {
  runApp(const BooklyFinderApp());
}

class BooklyFinderApp extends StatelessWidget {
  const BooklyFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bookly Finder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}
