import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/providers/item_provider.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({super.key});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

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
                        IconButton(
                          icon: const Icon(Icons.edit),
                          tooltip: "Edit category",
                          onPressed: () async {
                            String newName = "";
                            await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Please type in the new name for this category"),
                                content: Form(
                                  key: _formKey,
                                  child: TextFormField(
                                    // initialValue: provider.categories[categoryId]!,
                                    decoration: InputDecoration(
                                      hintText: provider.categories[categoryId]!,
                                    ),
                                    validator: (value) {
                                      if (value == null) {
                                        return "Please enter a name";
                                      }
                                      if (value.length > 25) {
                                        return "Category names can be up to 25 characters";
                                      }
                                      return null;
                                    },
                                    onChanged: (value) {
                                      newName = value;
                                    },
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      if (_formKey.currentState!.validate()) {
                                        if (newName.isNotEmpty) {
                                          provider.updateCategory(categoryId, newName);
                                        }
                                        Navigator.of(context).pop();
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          tooltip: "Delete category",
                          onPressed: () async {
                            if (provider.categories.length == 1) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Center(
                                    child: Text(
                                      "Cannot delete category, as it is the only one left",
                                      // style: TextStyle(fontSize: 15), // Possible TODO: Find appropriate text size
                                    ),
                                  ),
                                  duration: const Duration(seconds: 1),
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  backgroundColor: Colors.black.withOpacity(0.5),
                                )
                              );
                              return;
                            }
                            final bool? result = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text("Delete this category?"),
                                content: Text("Are you sure you want to delete ${provider.categories[categoryId]!}? "
                                    "This will delete all items that use this category."),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton( // TODO: This is super destructive. The UI should reflect that
                                    onPressed: () => Navigator.of(context).pop(true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                            if (result != null && result) {
                              provider.deleteCategory(categoryId);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          String name = "";
          await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text("Please enter a name for this category"),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    if (value.length > 25) {
                      return "Category names can be up to 25 characters";
                    }
                    return null; // Possible TODO: Check if name already exists (both here and in edit_category)
                  },
                  onChanged: (value) {
                    name = value;
                  },
                ),
              ),
              actions: [
                TextButton(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text("OK"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<ItemProvider>(context, listen: false).addCategory(name);
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        }, // TODO: Might be hiding some action buttons
        tooltip: 'Add a new category',
        child: const Icon(Icons.add),
      ),
    );
  }
}