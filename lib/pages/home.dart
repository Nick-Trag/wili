import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/edit_item.dart';
import 'package:wili/pages/settings.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:wili/widgets/list_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.settings,
                semanticLabel: "App Settings",
              ),
            ),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsWidget()));
            },
          ),
        ],
      ),
      body: FutureBuilder<void>(
        future: Future.wait([Provider.of<ItemProvider>(context, listen: false).getAllItems(), Provider.of<ItemProvider>(context, listen: false).getCategories()]),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ItemProvider>(
              builder: (context, provider, child) => ListWidget(
                items: provider.items,
                categories: provider.categories,
              ),
            );
          }
          else if (snapshot.hasError) { // Should never happen
            return Center(
              child: Text("Error: ${snapshot.error}")
            );
          }
          else {
            return Center(
              child: SizedBox(
                width: 60,
                height: 60,
                child: SpinKitFadingCircle(color: Theme.of(context).colorScheme.secondary,),
              ),
            );
          }
        }
      ),
      floatingActionButton: FutureBuilder<void>(
        future: Provider.of<ItemProvider>(context, listen: false).getCategories(),
        builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Consumer<ItemProvider>(
              builder: (context, provider, child) => FloatingActionButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => EditItemWidget(item: WishlistItem(name: "", category: provider.categories.keys.first)))
                  );
                },
                tooltip: 'Add new item',
                child: const Icon(Icons.add),
              )
            );
          }
          else {
            return FloatingActionButton(
              onPressed: () {},
              tooltip: 'Add new item',
              child: const Icon(Icons.add),
            );
          }
        }
      ),
    );
  }
}
