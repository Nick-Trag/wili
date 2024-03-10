import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/edit_item.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:intl/intl.dart' as intl;
import 'package:url_launcher/url_launcher.dart';
import 'package:wili/providers/settings_provider.dart';


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
          IconButton(
            icon: const Icon(
              Icons.delete,
            ),
            tooltip: "Delete item",
            onPressed: () async {
              final bool? result = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text("Delete this item?"),
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
                      child: const Text(
                        "Delete",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
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
          IconButton(
            icon: const Icon(
              Icons.edit,
            ),
            tooltip: "Edit item",
            onPressed: () {
              WishlistItem item = Provider.of<ItemProvider>(context, listen: false).currentItem ?? widget.item;
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => EditItemWidget(item: item))
              );
            },
          ),
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
                  Center(child: item.image != "" ? Image.file(File(item.image)) : const Icon(Icons.image)),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: Card(
                        child: Column(
                          children: [
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.abc),
                                  ),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(item.name),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0),
                            IntrinsicHeight( // Possible TODO: Extract this into another widget
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.category_outlined),
                                  ),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(provider.categories[item.category]!),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.euro),
                                  ),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Consumer<SettingsProvider>(
                                        builder: (context, settingsProvider, child) => Text('${intl.NumberFormat('0.00').format(item.price)}${settingsProvider.currency}'),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.note),
                                  ),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(item.note),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0),
                            IntrinsicHeight(
                              child: Row(
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Icon(Icons.numbers),
                                  ),
                                  const VerticalDivider(),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(item.quantity.toString()),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 0),
                            InkWell(
                              child: Text(
                                item.link, // TODO: Make it look like a URL
                              ),
                              onTap: () {
                                Uri link;
                                try {
                                  link = Uri.parse(item.link);
                                }
                                on FormatException {
                                  return;
                                }
                                if (link.isScheme('http') || link.isScheme('https')) {
                                  // Could also use canLaunch(link), but it returns a future, and I don't think I want to make this function async and await the result for no reason
                                  // Also, everything has already been checked when the link was added. So the check is superfluous as well
                                  launchUrl(link);
                                }
                              },
                            ),
                            const Divider(height: 0),
                            Text(item.purchased ? "Purchased" : "Not purchased"),
                          ],
                        ),
                      ),
                    ),
                  ),
                ], // TODO: Make it look good
              );
            },
          ),
        ),
      ),
    );
  }
}