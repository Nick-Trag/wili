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
  List<WishlistItem> items = [
    WishlistItem(name: "Computer", category: "Tech", price: 250, link: "https://www.example.com/", image: "assets/4060ti.jpg"),
    WishlistItem(name: "Camera", category: "Tech"),
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
        child: ListView(
          children: const <Widget>[
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.computer),
                  title: Text("Computer"),
                  subtitle: Text("Tech (category)"),
                  trailing: Text("1500€"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.local_laundry_service),
                  title: Text("Washing machine"),
                  subtitle: Text("Home (category)"),
                  trailing: Text("250€"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.lock),
                  title: Text("Lockpicking set"),
                  subtitle: Text("Hobby (category)"),
                  trailing: Text("30€"),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
              child: Card(
                child: ListTile(
                  leading: Image(image: AssetImage("assets/4060ti.jpg")),
                  title: Text("NVIDIA 4060 Ti"),
                  subtitle: Text("Tech (category)"),
                  trailing: Text("400€"),
                ),
              ),
            ),
          ],
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
