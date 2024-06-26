import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/view_item.dart';
import 'package:wili/providers/settings_provider.dart';
import 'package:wili/utils/utils.dart';

class ItemCardWidget extends StatelessWidget {
  const ItemCardWidget({super.key, required this.item, required this.categoryName});

  final WishlistItem item;
  final String categoryName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Consumer<SettingsProvider>(
        builder: (context, provider, child) => Card(
          color: item.purchased && provider.colorPurchased ? Theme.of(context).colorScheme.onSecondary : null,
          child: ListTile(
            leading: SizedBox(
              width: 80,
              child:
              item.image != "" && File(item.image).existsSync() ?
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: Image.file(
                  File(item.image),
                  fit: BoxFit.cover,
                ),
              ) :
              const Icon(Icons.image),
            ),
            title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
            subtitle: Text(categoryName, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: Text('${Utils.formatPrice(item.quantity * item.price)}${provider.currency}'),
          ),
        ),
      ),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => ViewItemWidget(item: item))
        );
      },
    );
  }

}