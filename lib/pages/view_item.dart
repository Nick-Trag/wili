import 'package:flutter/material.dart';
import 'package:wili/classes/item.dart';

class ViewItemWidget extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  ViewItemWidget({super.key, required this.title, required this.item});

  final WishlistItem item;
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
              padding: EdgeInsets.fromLTRB(12, 8, 0, 0),
              child: Text(textAlign: TextAlign.start, "Name:"),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(initialValue: item.name),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(12, 8, 0, 0),
              child: Text("Category:"),
            ),
            Padding( // TODO: Will become a select with values = the categories
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextFormField(initialValue: item.category),
            ),
          ]
        ),
      ),
    );
  }
}