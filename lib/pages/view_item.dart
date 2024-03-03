import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/edit_item.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:intl/intl.dart' as intl;


class ViewItemWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ViewItemWidget({super.key, required this.item});

  final WishlistItem item; // Note: Final variables can have their fields changed. Const variables cannot

  @override
  State<ViewItemWidget> createState() => _ViewItemWidgetState();
}

class _ViewItemWidgetState extends State<ViewItemWidget>{
  @override
  void initState() {
    super.initState();

    Provider.of<ItemProvider>(context, listen: false).getItemById(widget.item.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title:
          Consumer<ItemProvider>(
            builder: (context, provider, child) => provider.currentItem != null ? Text(provider.currentItem!.name) : Text(widget.item.name)
          ),
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
              final bool? result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete this item?"), // TODO: Better UI
                  content: Consumer<ItemProvider>(
                    builder: (context, provider, child) {
                      String name = provider.currentItem?.name ?? widget.item.name;
                      return Text("Are you sure you want to delete $name?");
                    }
                  ),
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
              WishlistItem item = Provider.of<ItemProvider>(context, listen: false).currentItem ?? widget.item;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditItemWidget(item: item))
              );
            },
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: SingleChildScrollView(
          child: Consumer<ItemProvider>(
            builder: (context, provider, child) {
              WishlistItem item = provider.currentItem ?? widget.item;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(child: item.image != "" ? Image.asset(item.image) : const Icon(Icons.question_mark)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(item.name),
                            ),
                            const Divider(),
                            Text(provider.categories[item.category]!),
                            const Divider(),
                            Text('${intl.NumberFormat('0.00').format(item.price)}€'),
                          ],
                        ),
                      ),
                    ),
                  )
                ], // TODO: Rest of the item attributes
              );
            }
          ),
        ),
      ),
    );
  }
}