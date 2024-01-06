import 'package:flutter/material.dart';
import 'package:wili/item.dart';
import 'package:wili/list_widget.dart';

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
      home: const MyHomePage(title: 'Wili Wishlist'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  // Next TODO: other pages (Detail view first)
  List<WishlistItem> items = [
    WishlistItem(name: "Computer", category: "Tech", price: 250, link: "https://www.example.com/", image: "assets/4060ti.jpg"),
    WishlistItem(name: "Camera", category: "Tech", price: 400),
    WishlistItem(name: "Mouse", category: "Tech"),
    WishlistItem(name: "Lens", category: "Tech"),
    WishlistItem(name: "Microwave", category: "Home"),
    WishlistItem(name: "Phone", category: "Tech"),
    WishlistItem(name: "Watch", category: "Misc."),
    WishlistItem(name: "Basketball", category: "Hobby"),
    WishlistItem(name: "Couch", category: "Home"),
    WishlistItem(name: "Pokemon Plush", category: "Misc."),
    WishlistItem(name: "Hoodie", category: "Clothes"),
    WishlistItem(name: "Shoes", category: "Clothes"),
  ];
  // List<WishlistItem> items = [];

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: ListWidget(
          items: items,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
