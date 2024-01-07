import 'package:flutter/material.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/home.dart';
import 'package:wili/pages/view_item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: ViewItemWidget(title: 'Wili Wishlist', item: WishlistItem(name: "Computer", category: "Tech", price: 250, link: "https://www.example.com/", image: "assets/4060ti.jpg")),
    );
  }
}
