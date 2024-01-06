import 'package:flutter/material.dart';
import 'package:wili/item.dart';
import 'package:intl/intl.dart' as intl;

class ListWidget extends StatelessWidget {
  const ListWidget({
    super.key,
    required this.items,
  });

  final List<WishlistItem> items;

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
      );
    }
  }
}