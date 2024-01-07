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
          children: [
            item.image != "" ? Image.asset(item.image) : const Icon(Icons.question_mark),
            Text(item.name),
            Text(item.category),
          ]
        ),
      ),
    );
  }
}