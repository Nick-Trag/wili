import 'package:flutter/material.dart';
import 'package:wili/item.dart';
import 'package:intl/intl.dart' as intl;

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
  // Next TODO: All the possible values and errors (no items, no pics, no prices, etc.). Then make it look nice (TEXT FORMATTING TOO (eg the prices)). Will do the UI of the home page first and then move on to the other pages.
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
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  leading: Container(
                    width: 100,
                    height: 100,
                    child: items[index].image != "" ? Image.asset(items[index].image) : const Icon(Icons.question_mark),
                  ),
                  title: Text(items[index].name),
                  subtitle: Text(items[index].category),
                  trailing: Text('${intl.NumberFormat('0.00').format(items[index].price)}€'),
                ),
              ),
            );
          }
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
