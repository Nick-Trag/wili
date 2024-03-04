import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  String _currency = "";

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
}