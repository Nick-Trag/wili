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
      child: const MyMaterialApp(),
    );
  }
}

class MyMaterialApp extends StatelessWidget {
  const MyMaterialApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wili',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, onSecondary: Colors.lightBlue[50]),
        useMaterial3: true,
        brightness: Brightness.light,
        // Below code makes sure that animations complete in the background, when entering a new route, and don't show up when popping the route
        // Reference: https://github.com/flutter/flutter/issues/133889#issuecomment-1703807078
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(
              allowEnterRouteSnapshotting: false,
            ),
          },
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlue, brightness: Brightness.dark),
        useMaterial3: true,
        brightness: Brightness.dark,
        // Below code makes sure that animations complete in the background, when entering a new route, and don't show up when popping the route
        // Reference: https://github.com/flutter/flutter/issues/133889#issuecomment-1703807078
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: <TargetPlatform, PageTransitionsBuilder>{
            TargetPlatform.android: ZoomPageTransitionsBuilder(
              allowEnterRouteSnapshotting: false,
            ),
          },
        ),
      ),
      themeMode: Provider.of<SettingsProvider>(context).themeMode,
      home: const LifecycleWatcher(child: HomePage(title: 'Wili Wishlist')),
    );
  }
}
