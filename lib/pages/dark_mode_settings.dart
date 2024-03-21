import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/providers/settings_provider.dart';

class DarkModeSettingsWidget extends StatelessWidget {
  const DarkModeSettingsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Theme settings"),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
        builder: (context, provider, child) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16.0, 16.0, 0.0, 4.0),
              child: Text("Select a theme for Wili"),
            ),
            InkWell(
              child: ListTile(
                leading: Radio(
                  value: ThemeMode.light,
                  groupValue: provider.themeMode,
                  onChanged: (newMode) {
                    if (newMode != null) {
                      provider.setThemeMode(newMode);
                    }
                  },
                ),
                title: const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.light_mode, semanticLabel: "Light mode"),
                    ),
                    Text("Light mode"),
                  ],
                ),
              ),
              onTap: () {
                provider.setThemeMode(ThemeMode.light);
              },
            ),
            InkWell(
              child: ListTile(
                leading: Radio(
                  value: ThemeMode.dark,
                  groupValue: provider.themeMode,
                  onChanged: (newMode) {
                    if (newMode != null) {
                      provider.setThemeMode(newMode);
                    }
                  },
                ),
                title: const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.dark_mode, semanticLabel: "Dark mode"),
                    ),
                    Text("Dark mode"),
                  ],
                ),
              ),
              onTap: () {
                provider.setThemeMode(ThemeMode.dark);
              },
            ),
            InkWell(
              child: ListTile(
                leading: Radio(
                  value: ThemeMode.system,
                  groupValue: provider.themeMode,
                  onChanged: (newMode) {
                    if (newMode != null) {
                      provider.setThemeMode(newMode);
                    }
                  },
                ),
                title: const Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(right: 8.0),
                      child: Icon(Icons.phone_android, semanticLabel: "System default"),
                    ),
                    Text("System default"),
                  ],
                ),
              ),
              onTap: () {
                provider.setThemeMode(ThemeMode.system);
              },
            ),
          ],
        ),
      ),
    );
  }

}