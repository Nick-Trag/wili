import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/services/sqlite_service.dart';

class ItemProvider extends ChangeNotifier {
  final SQLiteService _sqlite = SQLiteService();

  List<WishlistItem> _items = [];

  List<WishlistItem> get items => _items;

  Map<int, String> _categories = {};

  Map<int, String> get categories => _categories;

  WishlistItem? _currentItem;

  WishlistItem? get currentItem => _currentItem;

  ItemProvider() {
    getAllItems();
    getCategories();
  }

  Future<void> getAllItems() async {
    _items = await _sqlite.getAllItems();
    _currentItem = null;
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

  Future<void> updateImage(int id, XFile image) async {
    final String path = (await getApplicationDocumentsDirectory()).path;
    String extension = image.name.split('.').last;
    // File(image).renameSync(join(path, '$id.$extension'));

    // Rename image to id.jpg or something. Also, when deleting an item OR A CASCADING CATEGORY, I need to delete saved images
    // TODO: Activate this when I'm ready: await image.saveTo(path);
  }

  Future<void> clearImage(int id) async {
    // TODO: Delete image and await _sqlite.clearImage(id);
  }

}