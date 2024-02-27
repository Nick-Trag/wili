import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/edit_item.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:wili/widgets/list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // SQLiteService sqlite = SQLiteService();
  // List<WishlistItem> items = [
  //   WishlistItem(name: "Computer", category: 1, price: 250, link: "https://www.example.com/", image: "assets/4060ti.jpg"),
  //   WishlistItem(name: "Camera", category: 1, price: 400),
  //   WishlistItem(name: "Mouse", category: 1),
  //   WishlistItem(name: "Lens", category: 1),
  //   WishlistItem(name: "Microwave", category: 2),
  //   WishlistItem(name: "Phone", category: 1),
  //   WishlistItem(name: "Watch", category: 4),
  //   WishlistItem(name: "Basketball", category: 3),
  //   WishlistItem(name: "Couch", category: 2),
  //   WishlistItem(name: "Pokemon Plush", category: 4),
  //   WishlistItem(name: "Hoodie", category: 3),
  //   WishlistItem(name: "Shoes", category: 3),
  // ];
  // List<WishlistItem> items = [];
  // List<WishlistItem> items = [];
  // Map<int, String> categories = {};
  //
  // void _getItems() async {
  //   List<WishlistItem> tempItems = await sqlite.getAllItems();
  //   setState(() {
  //     items = tempItems;
  //   });
  // }
  //
  // void _getCategories() async {
  //   Map<int, String> tempCategories = await sqlite.getCategories();
  //   setState(() {
  //     categories = tempCategories;
  //   });
  // }

  // TODO: When I eventually add the functionality to change the database, this will probably not be sufficient, as navigating to another widget and back does not call initState() again
  @override
  void initState() {
    super.initState();
    // _getItems();
    // _getCategories();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: FutureBuilder<List<dynamic>>(
        future: Future.wait([Provider.of<ItemProvider>(context).getAllItems(), Provider.of<ItemProvider>(context).getCategories()]), // TODO: Standard provider
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshots) {
          if (snapshots.hasData) {
            return ListWidget(
              items: snapshots.data![0],
              categories: snapshots.data![1],
            );
          }
          else if (snapshots.hasError) {
            return Center(
              child: Text("Error: ${snapshots.error}")
            );
          }
          else {
            return const Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: CircularProgressIndicator(), // TODO: Doesn't actually show a progress indicator
              ),
            );
          }
        }
      ),
      floatingActionButton: FutureBuilder<Map<int, String>>(
        future: Provider.of<ItemProvider>(context).getCategories(),
        builder: (BuildContext context, AsyncSnapshot<Map<int, String>> snapshot) {
          if (snapshot.hasData) {
            return FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditItemWidget(item: WishlistItem(name: "", category: snapshot.data!.keys.first)))
                );
              },
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          }
          else {
            return FloatingActionButton(
              onPressed: () {},
              tooltip: 'Increment',
              child: const Icon(Icons.add),
            );
          }
        }
      ),
    );
  }
}
