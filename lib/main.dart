import 'package:flutter/material.dart';

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
              padding: EdgeInsets.all(8.0),
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
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
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
              padding: EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Card(
                child: ListTile(
                  leading: Icon(Icons.lock),
                  title: Text("Lockpicking set"),
                  subtitle: Text("Hobby (category)"),
                  trailing: Text("30€"),
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
