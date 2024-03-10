import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:intl/intl.dart' as intl;
import 'package:wili/pages/view_item.dart';
import 'package:wili/providers/settings_provider.dart';

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    required this.items,
    required this.categories,
  });

  final List<WishlistItem> items;
  final Map<int, String> categories;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
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
      return ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return Padding(
            // The last item gets considerably more padding on the bottom, in order for the floating action button to not hide any item's price
            padding: index == items.length - 1 ? const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 55.0): const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
            child: GestureDetector(
              child: Consumer<SettingsProvider>(
                builder: (context, provider, child) => Card(
                  color: items[index].purchased && provider.colorPurchased ? const Color.fromRGBO(221, 227, 237, 0.7) : null, // TODO: Choose better color
                  child: ListTile(
                    leading: SizedBox(
                      width: 80,
                      height: 100,
                      child: items[index].image != "" && File(items[index].image).existsSync() ? Image.file(File(items[index].image)) : const Icon(Icons.image),
                    ),
                    title: Text(items[index].name),
                    subtitle: Text(categories[items[index].category]!),
                    trailing: Text('${intl.NumberFormat('0.00').format(items[index].price)}${provider.currency}'),
                  ),
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => ViewItemWidget(item: items[index]))
                );
              },
            ),
          );
        }
      );
    }
  }
}