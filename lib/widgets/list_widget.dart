import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wili/pages/view_item.dart';
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
                // DropdownButton(
                //   items: [items],
                //   onChanged: onChanged,
                // ),
                TextButton(
                  child: const Text("filter"),
                  onPressed: () {
                    setState(() {
                      // widget.items = widget.items.where((item) => item.category == 1).toList();
                    });
                  },
                ),
                TextButton(
                  child: const Text("sort alphabetically"),
                  onPressed: () { // TODO: Use the provider for sorting and filtering.
                    setState(() {
                      widget.items.sort((item1, item2) => item1.name.compareTo(item2.name));
                    });
                  },
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