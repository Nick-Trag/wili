import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider() {
    getCurrency();
    initColoring();
    initMoveToBot();
    initThemeMode();
  }

  String _currency = "";

  bool _colorPurchased = false;

  bool _moveToBot = false;

  ThemeMode _themeMode = ThemeMode.system;

  String get currency => _currency;

  bool get colorPurchased => _colorPurchased;

  bool get moveToBot => _moveToBot;

  ThemeMode get themeMode => _themeMode;

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

  Future<void> initMoveToBot() async {
    final settings = await SharedPreferences.getInstance();
    _moveToBot = settings.getBool('moveToBot') ?? false;
  }

  Future<void> toggleMoveToBot() async {
    final settings = await SharedPreferences.getInstance();
    settings.setBool('moveToBot', !_moveToBot);
    _moveToBot = !_moveToBot;

    notifyListeners();
  }

  Future<void> initThemeMode() async {
    final settings = await SharedPreferences.getInstance();
    int? themeModeIndex = settings.getInt('themeMode');
    _themeMode = themeModeIndex != null ? ThemeMode.values[themeModeIndex] : ThemeMode.system;
  }

  Future<void> setThemeMode(ThemeMode newMode) async {
    final settings = await SharedPreferences.getInstance();
    settings.setInt('themeMode', newMode.index);
    _themeMode = newMode;

    notifyListeners();
  }
}