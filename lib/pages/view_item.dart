import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wili/classes/item.dart';

class ViewItemWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  ViewItemWidget({super.key, required this.title, required this.item});

  final WishlistItem item; // Note: Final variables can have their fields changed. Const variables cannot
  // In the future, the item will probably be nullable. This is how this is done:
  // final WishlistItem? item;
  final String title;

  @override
  State<ViewItemWidget> createState() => _ViewItemWidgetState();
}

class _ViewItemWidgetState extends State<ViewItemWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Might delete the app bar and the title on this page, will see
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity, // Basically width: 100%, just 50 times less intuitive
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
                child: TextFormField(initialValue: widget.item.name),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                child: Text("Category:"),
              ),
              Padding( // TODO: Will become a select with values = the categories
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: TextFormField(initialValue: widget.item.category),
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
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                child: Text("Note:"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField(initialValue: widget.item.note),
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
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
                child: Text("URL:"),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextFormField( // TODO: Make this a clickable URL
                  initialValue: widget.item.link,
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
                  controlAffinity: ListTileControlAffinity.leading, // leading Checkbox
                ),
              ),
            ]
          ),
        ),
      ),
    );
  }
}