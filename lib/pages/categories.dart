import 'package:flutter/material.dart';

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
      body: const Placeholder(), // TODO: All categories, with an edit button (opens modal for new name) and delete button (opens modal for confirmation)
    );
  }
}