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
  // Next TODO: SQLite
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
  List<WishlistItem> newItems = [];

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

  @override
  Widget build(BuildContext context) {
    _getItems();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListWidget(
        items: newItems,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
