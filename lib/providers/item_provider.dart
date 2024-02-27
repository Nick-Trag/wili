import 'package:flutter/material.dart';
import 'package:wili/classes/item.dart';
import 'package:wili/services/sqlite_service.dart';

class ItemProvider extends ChangeNotifier {
  final SQLiteService _sqlite = SQLiteService();

  Future<List<WishlistItem>> getAllItems() async {
    return _sqlite.getAllItems();

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

  Future<Map<int, String>> getCategories() async {
    return _sqlite.getCategories();

    // notifyListeners();
  }

  Future<Map<String, int>> getCategoriesReversed() async {
    return _sqlite.getCategoriesReversed();

    // notifyListeners();
  }

}