import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/pages/home.dart';
import 'package:wili/providers/item_provider.dart';
import 'package:wili/providers/settings_provider.dart';
import 'package:wili/widgets/lifecycle_watcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (BuildContext context) => ItemProvider()),
        ChangeNotifierProvider(create: (BuildContext context) => SettingsProvider()),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, onSecondary: Colors.lightBlue[50]),
          useMaterial3: true,
          brightness: Brightness.light,
        ),
        darkTheme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark),
          useMaterial3: true,
          brightness: Brightness.dark,
        ),
        home: const LifecycleWatcher(child: HomePage(title: 'Wili Wishlist')),
      ),
    );
  }
}
