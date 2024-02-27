import 'package:flutter/material.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/services/sqlite_service.dart';

class ItemProvider extends ChangeNotifier {
  final SQLiteService _sqlite = SQLiteService();

  List<WishlistItem> _items = [];

  List<WishlistItem> get items => _items;

  Map<int, String> _categories = {};

  Map<int, String> get categories => _categories;

  Future<void> getAllItems() async {
    _items = await _sqlite.getAllItems();

    // notifyListeners();
  }

  Future<void> addItem(WishlistItem item) async {
    await _sqlite.addItem(item);

    notifyListeners();
  }

  Future<void> updateItem(WishlistItem item) async {
    await _sqlite.updateItem(item);

    notifyListeners();
  }

  Future<void> getCategories() async {
    _categories = await _sqlite.getCategories();

    // notifyListeners();
  }

  // Future<Map<String, int>> getCategoriesReversed() async {
  //   return _sqlite.getCategoriesReversed();
  //
  //   // notifyListeners();
  // }

}