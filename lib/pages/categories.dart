import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wili/providers/item_provider.dart';

class CategoriesWidget extends StatelessWidget {
  CategoriesWidget({super.key, this.allowDelete = true});

  final bool allowDelete; // I do not want to allow users to delete items when entering this menu from the edit item widget, as that causes a ton of problems

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Categories'),
        centerTitle: true,
      ), // TODO: Re-order categories
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
              // separatorBuilder: (context, index) => const Divider(height: 0),
              itemBuilder: (context, index) {
                int categoryId = provider.categories.keys.elementAt(index);
                return Padding(
                  padding: index == provider.categories.length - 1 ? const EdgeInsets.only(bottom: 65.0): const EdgeInsets.all(0.0),
                  child: Column(
                    children: [
                      ListTile(
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
                                        autofocus: true,
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
                                          if (provider.categories.containsValue(value)) {
                                            return "Category already exists";
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
                            allowDelete ?
                            IconButton(
                              icon: const Icon(Icons.delete),
                              tooltip: "Delete category",
                              onPressed: () async {
                                if (provider.categories.length == 1) {
                                  // ScaffoldMessenger.of(context).showSnackBar(
                                  //   SnackBar(
                                  //     content: const Center(
                                  //       child: Text(
                                  //         "Cannot delete category, as it is the only one left",
                                  //         style: TextStyle(fontSize: 25),
                                  //       ),
                                  //     ),
                                  //     duration: const Duration(seconds: 1, milliseconds: 500),
                                  //     behavior: SnackBarBehavior.floating,
                                  //     shape: RoundedRectangleBorder(
                                  //       borderRadius: BorderRadius.circular(50),
                                  //     ),
                                  //     backgroundColor: Colors.black.withOpacity(0.5),
                                  //   )
                                  // );
                                  Fluttertoast.showToast(
                                    msg: "Cannot delete category, as it is the only one left",
                                    toastLength: Toast.LENGTH_SHORT,
                                  );
                                  return;
                                }
                                final bool? result = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: const Text("Delete this category?"),
                                    content: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          "Are you sure you want to delete ${provider.categories[categoryId]!}?",
                                          textAlign: TextAlign.start,
                                        ),
                                        const Text(
                                          "This will delete all items that use this category.",
                                          style: TextStyle(
                                            color: Colors.red,
                                          ),
                                          textAlign: TextAlign.start,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
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
                                  if (provider.filterId == categoryId) { // If the deleted category is being used as a filter, we remove it as a filter before deleting it
                                    provider.setFilter(-1);
                                  }
                                  provider.deleteCategory(categoryId);
                                }
                              },
                            )
                            : Container(),
                          ],
                        ),
                      ),
                      const Divider(height: 0),
                    ],
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
                  autofocus: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Please enter a name";
                    }
                    if (value.length > 25) {
                      return "Category names can be up to 25 characters";
                    }
                    if (Provider.of<ItemProvider>(context, listen: false).categories.containsValue(value)) {
                      return "Category already exists";
                    }
                    return null;
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
        },
        tooltip: 'Add a new category',
        child: const Icon(Icons.add),
      ),
    );
  }
}