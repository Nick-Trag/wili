import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/edit_item.dart';
import 'package:wili/pages/settings.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:wili/providers/settings_provider.dart';
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
  Sort sort = Sort.id;
  int filterCategory = -1; // The id of the category currently used for filtering. -1 signifies showing all categories

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
          IconButton(
            padding: const EdgeInsets.all(8.0),
            icon: const Icon(
              Icons.settings,
            ),
            tooltip: "App Settings",
            onPressed: () {
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
              builder: (context, provider, child) {
                List<WishlistItem> sortedItems = List<WishlistItem>.from(provider.items);

                if (provider.filterId != -1) {
                  sortedItems = sortedItems.where((item) => item.category == provider.filterId).toList();
                }

                switch (provider.sort) {
                  case Sort.priceAscending:
                    sortItemsByPrice(sortedItems, ascending: true);
                  case Sort.priceDescending:
                    sortItemsByPrice(sortedItems, ascending: false);
                  case Sort.nameAscending:
                    sortItemsByName(sortedItems, ascending: true);
                  case Sort.nameDescending:
                    sortItemsByName(sortedItems, ascending: false);
                  case Sort.idReverse:
                    sortItemsById(sortedItems, ascending: false);
                  case Sort.id:
                }

                bool moveToBot = Provider.of<SettingsProvider>(context).moveToBot;

                if (moveToBot) {
                  sortedItems.sort((item1, item2) => item1.purchased == item2.purchased ? 0 : (item1.purchased ? 1 : -1));
                }

                return Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Icon(
                                Icons.filter_alt_outlined,
                                semanticLabel: "Filter items by category",
                              ),
                            ),
                            Consumer<ItemProvider>(
                              builder: (context, provider, child) => DropdownButton<int>(
                                value: provider.filterId,
                                items: [
                                  const DropdownMenuItem(
                                    value: -1,
                                    child: Text("All categories"),
                                  )
                                ] + provider.categories.map(
                                  (int id, String name) => MapEntry<String, DropdownMenuItem<int>>(
                                    name,
                                    DropdownMenuItem<int>(
                                      value: id,
                                      child: Text(name),
                                    )
                                  )
                                ).values.toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    filterCategory = value;
                                    provider.setFilter(filterCategory);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 4.0),
                              child: Icon(
                                Icons.sort,
                                semanticLabel: "Sort items",
                              ),
                            ),
                            DropdownButton<Sort>(
                              value: sort,
                              items: [
                                const DropdownMenuItem(
                                  value: Sort.id,
                                  child: Text("Oldest first"),
                                ),
                                const DropdownMenuItem(
                                  value: Sort.idReverse,
                                  child: Text("Newest first"),
                                ),
                                const DropdownMenuItem(
                                  value: Sort.nameAscending,
                                  child: Text("A-Z"),
                                ),
                                const DropdownMenuItem(
                                  value: Sort.nameDescending,
                                  child: Text("Z-A"),
                                ),
                                DropdownMenuItem(
                                  value: Sort.priceAscending,
                                  child: Text('${Provider.of<SettingsProvider>(context).currency}⬆'),
                                ),
                                DropdownMenuItem(
                                  value: Sort.priceDescending,
                                  child: Text('${Provider.of<SettingsProvider>(context).currency}⬇'),
                                ),
                              ],
                              onChanged: (value) {
                                if (value != null) {
                                  sort = value;
                                  Provider.of<ItemProvider>(context, listen: false).setSort(sort);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListWidget(
                        items: sortedItems,
                        categories: provider.categories,
                      ),
                    ),
                  ],
                );
              },
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
                child: SpinKitFadingCircle(color: Theme.of(context).colorScheme.primary),
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

  void sortItemsByPrice(List<WishlistItem> items, {bool ascending = true}) {
    if (ascending) {
      items.sort((item1, item2) => item1.price.compareTo(item2.price));
    }
    else {
      items.sort((item1, item2) => item2.price.compareTo(item1.price));
    }
  }

  void sortItemsByName(List<WishlistItem> items, {bool ascending = true}) {
    if (ascending) {
      items.sort((item1, item2) => item1.name.toLowerCase().compareTo(item2.name.toLowerCase()));
    }
    else {
      items.sort((item1, item2) => item2.name.toLowerCase().compareTo(item1.name.toLowerCase()));
    }
  }

  void sortItemsById(List<WishlistItem> items, {bool ascending = true}) {
    if (ascending) {
      items.sort((item1, item2) => item1.id.compareTo(item2.id));
    }
    else {
      items.sort((item1, item2) => item2.id.compareTo(item1.id));
    }
  }
}
