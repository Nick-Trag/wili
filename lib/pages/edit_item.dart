import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:wili/services/sqlite_service.dart';

class EditItemWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  EditItemWidget({super.key, required this.item});

  final WishlistItem item; // Note: Final variables can have their fields changed. Const variables cannot
  // In the future, the item will probably be nullable. This is how this is done:
  // final WishlistItem? item;

  @override
  State<EditItemWidget> createState() => _EditItemWidgetState();
}

class _EditItemWidgetState extends State<EditItemWidget> {
  SQLiteService sqlite = SQLiteService(); // TODO: This is a duplicate from home, will probably change it to inherit it from main or something
  Map<String, int> categories = {};
  final _formKey = GlobalKey<FormState>();

  void _getCategories() async { // TODO: Remove this, use the provider instead
    Map<String, int> tempCategories = await sqlite.getCategoriesReversed();
    setState(() {
      categories = tempCategories;
    });
  }

  // TODO: When I eventually add the functionality to change the database, this will probably not be sufficient, as navigating to another widget and back does not call initState() again
  @override
  void initState() {
    super.initState();
    _getCategories();
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
          GestureDetector(
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: Icon(
                Icons.check,
                semanticLabel: "Save item",
              ),
            ),
            onTap: () {
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
                Center(child: widget.item.image != "" ? Image.asset(widget.item.image) : const Icon(Icons.question_mark)),
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
                  child: DropdownButton<int>( // Reference: https://stackoverflow.com/a/58153394/7400287
                    value: widget.item.category,
                    items: categories.map((String name, int id) {
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
                const Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                  child: Text("Price:"),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: TextFormField(
                    keyboardType: const TextInputType.numberWithOptions(decimal: true), // Set the keyboard to the number board, while allowing decimals
                    initialValue: widget.item.price.toStringAsFixed(2),
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