import 'package:flutter/material.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/services/sqlite_service.dart';
import 'package:wili/widgets/list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _counter = 0;
  SQLiteService sqlite = SQLiteService();
  List<WishlistItem> items = [
    WishlistItem(name: "Computer", category: 1, price: 250, link: "https://www.example.com/", image: "assets/4060ti.jpg"),
    WishlistItem(name: "Camera", category: 1, price: 400),
    WishlistItem(name: "Mouse", category: 1),
    WishlistItem(name: "Lens", category: 1),
    WishlistItem(name: "Microwave", category: 2),
    WishlistItem(name: "Phone", category: 1),
    WishlistItem(name: "Watch", category: 4),
    WishlistItem(name: "Basketball", category: 3),
    WishlistItem(name: "Couch", category: 2),
    WishlistItem(name: "Pokemon Plush", category: 4),
    WishlistItem(name: "Hoodie", category: 3),
    WishlistItem(name: "Shoes", category: 3),
  ];
  // List<WishlistItem> items = [];
  List<WishlistItem> newItems = [];
  Map<int, String> categories = {};

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _getItems() async {
    List<WishlistItem> tempItems = await sqlite.getAllItems();
    setState(() {
      newItems = tempItems;
    });
  }

  void _getCategories() async {
    Map<int, String> tempCategories = await sqlite.getCategories();
    setState(() {
      categories = tempCategories;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Right now, this does a billion updates (and SQL queries). This will be moved into an initializing method or something
    _getItems();
    _getCategories();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListWidget(
        items: newItems,
        categories: categories,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
