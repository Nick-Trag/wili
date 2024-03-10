import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    getCurrency();
    initColoring();
  }

  String _currency = "";

  bool _colorPurchased = false;

  bool get colorPurchased => _colorPurchased;

  String get currency => _currency;

  Future<void> getCurrency() async {
    final settings = await SharedPreferences.getInstance();
    _currency = settings.getString('currency') ?? "€";

    notifyListeners();
  }

  Future<void> setCurrency(String newCurrency) async {
    final settings = await SharedPreferences.getInstance();
    settings.setString('currency', newCurrency);
    _currency = newCurrency;

    notifyListeners();
  }

  Future<void> initColoring() async {
    final settings = await SharedPreferences.getInstance();
    _colorPurchased = settings.getBool('colorPurchased') ?? false;
  }

  Future<void> toggleColoring() async {
    final settings = await SharedPreferences.getInstance();
    settings.setBool('colorPurchased', !_colorPurchased);
    _colorPurchased = !_colorPurchased;

    notifyListeners();
  }
}