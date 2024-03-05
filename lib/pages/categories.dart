import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/providers/item_provider.dart';

class CategoriesWidget extends StatelessWidget {
  const CategoriesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Categories'),
        centerTitle: true,
      ),
      body: Consumer<ItemProvider>(
        builder: (context, provider, child) {
          if (provider.categories.isEmpty) { // This should never be the case
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.not_interested),
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 100),
                  child: const Text(
                    "There are no categories.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            );
          }
          else {
            return ListView.builder(
              itemCount: provider.categories.length,
              itemBuilder: (context, index) {
                int categoryId = provider.categories.keys.elementAt(index);
                return Card(
                  child: ListTile(
                    title: Text(provider.categories[categoryId]!),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(right: 4.0),
                          child: InkWell(
                            child: const Icon(Icons.edit),
                            onTap: () {},
                          )
                        ),
                        InkWell(
                          child: const Icon(Icons.delete),
                          onTap: () {},
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ), // TODO: All categories, in cards, with an edit button (opens modal for new name) and delete button (opens modal for confirmation)
      floatingActionButton: FloatingActionButton(
        onPressed: () {}, // TODO: Open a modal to create a new category. Also, careful, might be hiding some action buttons
        tooltip: 'Add a new category',
        child: const Icon(Icons.add),
      ),
    );
  }
}