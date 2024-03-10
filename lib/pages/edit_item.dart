import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
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

  @override
  void initState() {
    super.initState();
  }

  // TODO: Going back after an edit keeps the edited values, even though they have not been saved in the database
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Might delete the app bar and the title on this page, will see
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.item.name != "" ? widget.item.name : "Add a new item"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(
              Icons.check,
            ),
            tooltip: "Save item",
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                if (widget.item.id != -1) {
                  Provider.of<ItemProvider>(context, listen: false).updateItem(widget.item);
                }
                else {
                  Provider.of<ItemProvider>(context, listen: false).addItem(widget.item);
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
                    children: [ // TODO TODO TODO: URGENT BUG. Image will need to be submitted along with everything else
                      Center(
                        child: provider.currentItem != null && provider.currentItem!.image != "" && File(provider.currentItem!.image).existsSync() ? Image.file(File(provider.currentItem!.image)) : const Padding(
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
                                provider.updateImage(widget.item.id, image);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.hide_image_outlined),
                            tooltip: "Clear image",
                            onPressed: () {
                              provider.clearImage(widget.item.id);
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
                    initialValue: widget.item.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      widget.item.name = value;
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
                          value: widget.item.category,
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
                              widget.item.category = value!;
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
                    initialValue: widget.item.price != 0 ? widget.item.price.toStringAsFixed(2) : "",
                    decoration: InputDecoration(
                      hintText: widget.item.price.toStringAsFixed(2),
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
                        widget.item.price = 0;
                      }
                      else {
                        widget.item.price = double.parse(value);
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
                    initialValue: widget.item.note,
                    onChanged: (value) {
                      widget.item.note = value;
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
                    initialValue: widget.item.quantity.toString(),
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')), // only allow ints
                    ],
                    onChanged: (value) {
                      if (value == "") {
                        widget.item.quantity = 1;
                      }
                      else {
                        widget.item.quantity = int.parse(value);
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
                    initialValue: widget.item.link,
                    onChanged: (value) {
                      widget.item.link = value;
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
                    value: widget.item.purchased,
                    onChanged: (newValue) {
                      setState(() {
                        widget.item.purchased = newValue!;
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