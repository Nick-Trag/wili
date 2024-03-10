import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/pages/categories.dart';
import 'package:wili/providers/item_provider.dart';

class EditItemWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  EditItemWidget({super.key, required this.item});

  final WishlistItem item; // Note: Final variables can have their fields changed. Const variables cannot

  @override
  State<EditItemWidget> createState() => _EditItemWidgetState();
}

class _EditItemWidgetState extends State<EditItemWidget> {
  final _formKey = GlobalKey<FormState>();
  late WishlistItem item;

  @override
  void initState() {
    item = widget.item;
    super.initState();
  }

  // TODO: Going back after an edit keeps the edited values, even though they have not been saved in the database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Might delete the app bar and the title on this page, will see
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(item.name != "" ? item.name : "Add a new item"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
            ),
            tooltip: "Save item",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (item.id != -1) {
                  Provider.of<ItemProvider>(context, listen: false).updateItem(item);
                }
                else {
                  Provider.of<ItemProvider>(context, listen: false).addItem(item);
                }

                Navigator.of(context).pop();
              }
            },
          )
        ],
      ),
      body: SizedBox(
        width: double.infinity, // Basically width: 100%, just 50 times less intuitive
        child: Form(
          key: _formKey,
          child: SingleChildScrollView( // Allows the column to be scrollable. Reference: https://stackoverflow.com/a/61541293/7400287
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Consumer<ItemProvider>(
                  builder: (context, provider, child) => Column(
                    children: [
                      Center(
                        child: item.image != "" && File(item.image).existsSync() ? Image.file(File(item.image)) : const Padding(
                          padding: EdgeInsets.only(top: 25.0),
                          child: Icon(Icons.image, size: 100, semanticLabel: "No image"),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            tooltip: "Change image",
                            onPressed: () async {
                              final ImagePicker picker = ImagePicker();
                              final XFile? image = await picker.pickImage(
                                source: ImageSource.gallery,
                                maxHeight: 500,
                                maxWidth: 500,
                              ); // Later TODO: Cropping

                              if (image != null) {
                                final String path = (await getApplicationDocumentsDirectory()).path;
                                // String extension = image.name.split('.').last;
                                Directory directory = Directory(join(path, 'item_images'));
                                if (!directory.existsSync()) {
                                  directory.createSync();
                                }
                                final File newImage = File(image.path).renameSync(join(directory.path, image.name)); // Moving the image to a permanent app storage // NOT DOING THIS ATM: and renaming it to $id.$extension
                                // If I do do it, cache kinda fucks me. Hmm...
                                setState(() {
                                  item.image = newImage.path;
                                });
                                // provider.updateImage(item.id, image);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.hide_image_outlined),
                            tooltip: "Clear image",
                            onPressed: () {
                              setState(() {
                                item.image = '';
                              });
                              // provider.clearImage(item.id);
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text(textAlign: TextAlign.start, "Name:"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: TextFormField(
                    initialValue: item.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      item.name = value;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text("Category:"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Row(
                    children: [
                      Consumer<ItemProvider>(
                        builder: (context, provider, child) => DropdownButton<int>( // Reference: https://stackoverflow.com/a/58153394/7400287
                          value: item.category,
                          items: provider.categories.map((int id, String name) {
                            return MapEntry<String, DropdownMenuItem<int>>(
                              name,
                              DropdownMenuItem<int>(
                                value: id,
                                child: Text(name),
                              )
                            );
                          }).values.toList(),
                          onChanged: (int? value) {
                            setState(() {
                              item.category = value!;
                            });
                          },
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, size: 22),
                        tooltip: "Edit categories",
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) => CategoriesWidget(allowDelete: false)));
                        },
                      ),
                    ],
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text("Price:"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true), // Set the keyboard to the number board, while allowing decimals
                    initialValue: item.price != 0 ? item.price.toStringAsFixed(2) : "",
                    decoration: InputDecoration(
                      hintText: item.price.toStringAsFixed(2),
                    ),
                    inputFormatters: <TextInputFormatter>[ //Accept only numbers, either integers or decimals (even from someone pasting it into the field)
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]?[0-9]*')), // Reference: https://www.flutterclutter.dev/flutter/tutorials/how-to-create-a-number-input/2021/86522/
                      TextInputFormatter.withFunction(
                          (oldValue, newValue) => newValue.copyWith(
                            text: newValue.text.replaceAll(',', '.'),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        item.price = 0;
                      }
                      else {
                        item.price = double.parse(value);
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text("Note:"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    initialValue: item.note,
                    onChanged: (value) {
                      item.note = value;
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text("Quantity:"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    initialValue: item.quantity.toString(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // only allow ints
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        item.quantity = 1;
                      }
                      else {
                        item.quantity = int.parse(value);
                      }
                    },
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text("URL:"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    initialValue: item.link,
                    onChanged: (value) {
                      item.link = value;
                    },
                    validator: (value) {
                      String error = "Please enter a valid full URL or leave this field blank";
                      if (value != null && value.isNotEmpty) {
                        Uri link;
                        try {
                          link = Uri.parse(value);
                        }
                        on FormatException {
                          return error;
                        }
                        if (!link.isScheme('http') && !link.isScheme('https')) {
                          return error;
                        }
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: CheckboxListTile(
                    title: const Text("Purchased"),
                    value: item.purchased,
                    onChanged: (newValue) {
                      setState(() {
                        item.purchased = newValue!;
                      });
                    },
                    controlAffinity: ListTileControlAffinity.leading, // leading checkbox
                  ),
                ),
              ]
            ),
          ),
        ),
      ),
    );
  }
}