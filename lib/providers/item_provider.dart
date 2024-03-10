import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/services/sqlite_service.dart';

enum Sort {
  priceAscending,
  priceDescending,
  nameAscending,
  nameDescending,
  id,
}

// Later version TODO: Use the SQLiteService WAY LESS. Do updates locally instead of pulling everything from the db always
class ItemProvider extends ChangeNotifier {
  final SQLiteService _sqlite = SQLiteService();

  List<WishlistItem> _items = [];

  List<WishlistItem> get items => _items;

  Map<int, String> _categories = {};

  Map<int, String> get categories => _categories;

  WishlistItem? _currentItem;

  WishlistItem? get currentItem => _currentItem;

  Sort _sort = Sort.id;

  Sort get sort => _sort;

  int _filterId = -1;

  int get filterId => _filterId;

  ItemProvider() {
    getAllItems();
    getCategories();
  }

  Future<void> getAllItems() async {
    _items = await _sqlite.getAllItems();
    _currentItem = null;

    if (_filterId != -1) {
      _items = _items.where((item) => item.category == _filterId).toList();
    }

    switch (_sort) {
      case Sort.priceAscending:
        sortItemsByPrice(ascending: true);
      case Sort.priceDescending:
        sortItemsByPrice(ascending: false);
      case Sort.nameAscending:
        sortItemsByName(ascending: true);
      case Sort.nameDescending:
        sortItemsByName(ascending: false);
      case Sort.id:
    }
  }

  Future<void> addItem(WishlistItem item) async {
    await _sqlite.addItem(item);

    await getAllItems();

    notifyListeners();
  }

  Future<void> updateItem(WishlistItem item) async {
    await _sqlite.updateItem(item);

    await getAllItems();

    _currentItem = item;

    notifyListeners();
  }

  Future<void> deleteItem(int id) async {
    await _sqlite.deleteItem(id);

    await getAllItems();

    notifyListeners();
  }

  Future<void> getCategories() async {
    _categories = await _sqlite.getCategories();
  }

  Future<void> getItemById(int id) async {
    _currentItem = await _sqlite.getItemById(id);

    notifyListeners();
  }

  Future<void> deleteCategory(int id) async {
    await _sqlite.deleteCategory(id);

    await getCategories();
    await getAllItems(); // Deleting a category might also delete an item, so we need to update them as well

    notifyListeners();
  }

  Future<void> updateCategory(int id, String name) async {
    await _sqlite.updateCategory(id, name);

    await getCategories();

    notifyListeners();
  }

  Future<void> addCategory(String name) async {
    await _sqlite.addCategory(name);

    await getCategories();

    notifyListeners();
  }

  // Future<void> updateImage(int id, XFile image) async {
  //   final String path = (await getApplicationDocumentsDirectory()).path;
  //   // String extension = image.name.split('.').last;
  //   final File newImage = File(image.path).renameSync(join(path, image.name)); // Moving the image to a permanent app storage // NOT DOING THIS ATM: and renaming it to $id.$extension
  //   // If I do do it, cache kinda fucks me. Hmm...
  //
  //   await _sqlite.updateImage(id, newImage.path);
  //
  //   await getAllItems();
  //   await getItemById(id);
  //
  //   notifyListeners();
  // }
  //
  // Future<void> clearImage(int id) async {
  //   if (currentItem == null) {
  //     await getItemById(id);
  //   }
  //   if (currentItem != null) {
  //     // File(currentItem!.image).delete();
  //     // We actually don't want to delete it. Another item might be using the same image
  //     await _sqlite.clearImage(id);
  //   }
  //
  //   await getAllItems();
  //   await getItemById(id);
  //
  //   notifyListeners();
  // }

  void sortItemsByName({bool ascending = true}) {
    if (ascending) {
      items.sort((item1, item2) => item1.name.compareTo(item2.name));
      _sort = Sort.nameAscending;
    }
    else {
      _sort = Sort.nameDescending;
      items.sort((item1, item2) => item2.name.compareTo(item1.name));
    }

    notifyListeners();
  }

  void sortItemsByPrice({bool ascending = true}) {
    if (ascending) {
      items.sort((item1, item2) => item1.price.compareTo(item2.price));
      _sort = Sort.priceAscending;
    }
    else {
      _sort = Sort.priceDescending;
      items.sort((item1, item2) => item2.price.compareTo(item1.price));
    }

    notifyListeners();
  }

  Future<void> sortItems(Sort sorting) async {
    _sort = sorting;

    await getAllItems();

    notifyListeners();
  }

  Future<void> setFilter(int categoryId) async {
    if (categoryId == -1 || _categories.containsKey(categoryId)) {
      _filterId = categoryId;
    }

    await getAllItems();

    notifyListeners();
  }

  Future<void> clearUnusedImages() async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    Directory directory = Directory(join(path, 'item_images'));
    if (!directory.existsSync()) {
      return;
    }
    List<WishlistItem> allItems = await _sqlite.getAllItems();
    List<FileSystemEntity> files = directory.listSync();
    List<String> usedImages = allItems.map((item) => item.image).toList();
    for (FileSystemEntity file in files) {
      if (!usedImages.contains(file.path)) {
        // TODO: Test this more and then delete the print
        print('${file.path} marked for deletion');
        file.delete();
      }
    }
  }
}