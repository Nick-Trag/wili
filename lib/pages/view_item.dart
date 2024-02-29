import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/edit_item.dart';
import 'package:wili/providers/item_provider.dart';

class ViewItemWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ViewItemWidget({super.key, required this.item});

  final WishlistItem item; // Note: Final variables can have their fields changed. Const variables cannot

  @override
  State<ViewItemWidget> createState() => _ViewItemWidgetState();
}

class _ViewItemWidgetState extends State<ViewItemWidget>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.item.name), // TODO: After editing it, this needs to change
        centerTitle: true,
        actions: [
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.delete,
                semanticLabel: "Delete item",
              ),
            ),
            onTap: () async {
              final result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete this item?"), // TODO: Better UI
                  content: Text("Are you sure you want to delete ${widget.item.name}?"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text("Cancel"),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text("Delete"),
                    ),
                  ],
                ),
              );
              if (result != null && result) {
                if (context.mounted) {
                  Provider.of<ItemProvider>(context, listen: false).deleteItem(widget.item.id);
                  Navigator.of(context).pop();
                }
              }
            },
          ),
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.edit,
                semanticLabel: "Edit item",
              ),
            ),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditItemWidget(item: widget.item))
              );
            },
          )
        ],
      ),
      body: const Placeholder(), // TODO: Body
    );
  }
}