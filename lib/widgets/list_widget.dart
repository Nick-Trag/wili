import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wili/pages/view_item.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:wili/providers/settings_provider.dart';

class ListWidget extends StatefulWidget {
  const ListWidget({
    super.key,
    required this.items,
    required this.categories,
  });

  final List<WishlistItem> items;
  final Map<int, String> categories;

  @override
  State<ListWidget> createState() => _ListWidgetState();
}

class _ListWidgetState extends State<ListWidget> {
  Sort sort = Sort.id;
  int filterCategory = -1; // The id of the category currently used for filtering. -1 signifies showing all categories

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.not_interested),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 100),
            child: const Text(
              "No items wished for yet. Use the plus button to add an item.",
              textAlign: TextAlign.center,
            ),
          ),
        ],
      );
    }
    else {
      return SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
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
                        Icons.filter_alt,
                        semanticLabel: "Filter items by category",
                      ),
                    ),
                    Consumer<ItemProvider>(
                      builder: (context, provider, child) => DropdownButton<int>(
                        value: filterCategory,
                        items: [
                          const DropdownMenuItem(
                            value: -1,
                            child: Text("All categories"),
                          ) // TODO: Very important. What if the currently selected category gets deleted?
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
                            setState(() {
                              filterCategory = value;
                            });
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
                          child: Text("Default"),
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
                          Provider.of<ItemProvider>(context, listen: false).sortItems(sort);
                        }
                      },
                    ),
                  ],
                ),
              ],
            ),
            ListView.builder(
              itemCount: widget.items.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(), // Making sure to scroll the entire column, instead of only the listview. Reference: https://stackoverflow.com/a/58725480/7400287
              itemBuilder: (context, index) {
                return Padding(
                  // The last item gets considerably more padding on the bottom, in order for the floating action button to not hide any item's price
                  padding: index == widget.items.length - 1 ? const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 55.0): const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  child: GestureDetector(
                    child: Card(
                      child: ListTile(
                        leading: SizedBox(
                          width: 100,
                          height: 100,
                          child: widget.items[index].image != "" ? Image.file(File(widget.items[index].image)) : const Icon(Icons.question_mark),
                        ),
                        title: Text(widget.items[index].name),
                        subtitle: Text(widget.categories[widget.items[index].category]!),
                        trailing: Consumer<SettingsProvider>(
                          builder: (context, provider, child) => Text('${intl.NumberFormat('0.00').format(widget.items[index].price)}${provider.currency}'),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ViewItemWidget(item: widget.items[index]))
                      );
                    },
                  ),
                );
              }
            ),
          ],
        ),
      );
    }
  }
}