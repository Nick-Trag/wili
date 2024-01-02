import 'package:flutter/material.dart';
import 'package:wili/item.dart';

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
  // Next TODO: Dummy data (enought to fill the screen). Will do the UI of the home page first and then move on to the other pages
  List<WishlistItem> items = [
    WishlistItem(name: "Computer", category: "Tech", price: 250, link: "https://www.example.com/", image: "assets/4060ti.jpg"),
    WishlistItem(name: "Camera", category: "Tech", price: 400),
    WishlistItem(name: "Mouse", category: "Tech"),
    WishlistItem(name: "Lens", category: "Tech"),
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
                  leading: items[index].image != "" ? Image.asset(items[index].image) : const Icon(Icons.question_mark),
                  title: Text(items[index].name),
                  subtitle: Text(items[index].category),
                  trailing: Text('${items[index].price}€'),
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
