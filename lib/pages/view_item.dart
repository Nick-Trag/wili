import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wili/classes/item.dart';

class ViewItemWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ViewItemWidget({super.key, required this.title, required this.item});

  final WishlistItem item;
  // In the future, the item will probably be nullable. This is how this is done:
  // final WishlistItem? item;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( // Might delete the app bar and the title on this page, will see
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(title),
        centerTitle: true,
      ),
      body: SizedBox(
        width: double.infinity, // Basically width: 100%, just 50 times less intuitive
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(child: item.image != "" ? Image.asset(item.image) : const Icon(Icons.question_mark)),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              child: Text(textAlign: TextAlign.start, "Name:"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(initialValue: item.name),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              child: Text("Category:"),
            ),
            Padding( // TODO: Will become a select with values = the categories
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(initialValue: item.category),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 8, 0, 0),
              child: Text("Price:"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextFormField(
                keyboardType: const TextInputType.numberWithOptions(decimal: true), // Set the keyboard to the number board, while allowing decimals
                initialValue: item.price.toString(),
                inputFormatters: <TextInputFormatter>[ //Accept only numbers, either integers or decimals (even from someone pasting it into the field)
                  FilteringTextInputFormatter.allow(RegExp(r'[0-9]+[,.]{0,1}[0-9]*')), // Reference: https://www.flutterclutter.dev/flutter/tutorials/how-to-create-a-number-input/2021/86522/
                  TextInputFormatter.withFunction(
                      (oldValue, newValue) => newValue.copyWith(
                        text: newValue.text.replaceAll(',', '.'),
                    ),
                  ),
                ],
              ),
            ),
          ]
        ),
      ),
    );
  }
}