import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wili/pages/categories.dart';
import 'package:wili/pages/dark_mode_settings.dart';
import 'package:wili/providers/settings_provider.dart';

class SettingsWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _currency = "";

  @override
  void initState() {
    super.initState();
    _currency = Provider.of<SettingsProvider>(context, listen: false).currency;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: <Widget>[
                Consumer<SettingsProvider>(
                  builder: (context, provider, child) => InkWell(
                    child: ListTile(
                      title: const Text("Currency"),
                      subtitle: Text(provider.currency),
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog( // TODO: Dialogs in landscape mode are kinda bad. Look into it
                          title: const Text("Please type in the symbol or name of your currency"),
                          content: Form(
                            key: _formKey,
                            child: TextFormField(
                              autofocus: true,
                              // initialValue: provider.currency,
                              decoration: InputDecoration(
                                hintText: provider.currency,
                              ),
                              validator: (value) {
                                if (value == null || value.trim().length > 5) {
                                  return "Please enter up to five characters";
                                }
                                return null;
                              },
                              onChanged: (value) {
                                _currency = value;
                              },
                            ),
                          ),
                          actions: [
                            TextButton(
                              child: const Text("Cancel"),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: const Text("OK"),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  String currency = _currency.trim();
                                  if (currency.isNotEmpty) {
                                    provider.setCurrency(currency);
                                  }
                                  Navigator.of(context).pop();
                                }
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const Divider(height: 0),
                Consumer<SettingsProvider>(
                  builder: (context, provider, child) => InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: const Text("Change color of purchased items"),
                        trailing: Switch(
                          value: provider.colorPurchased,
                          onChanged: (value) {
                            provider.toggleColoring();
                          },
                        ),
                      ),
                    ),
                    onTap: () {
                      provider.toggleColoring();
                    },
                  ),
                ),
                const Divider(height: 0),
                Consumer<SettingsProvider>(
                  builder: (context, provider, child) => InkWell(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: ListTile(
                        title: const Text("Move purchased items to the bottom"),
                        trailing: Switch(
                          value: provider.moveToBot,
                          onChanged: (value) {
                            provider.toggleMoveToBot();
                          },
                        ),
                      ),
                    ),
                    onTap: () {
                      provider.toggleMoveToBot();
                    },
                  ),
                ),
                const Divider(height: 0),
                InkWell(
                  child: const ListTile(
                    title: Text('Edit categories'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => CategoriesWidget())
                    );
                  },
                ),
                const Divider(height: 0),
                InkWell(
                  child: const ListTile(
                    title: Text('App theme'),
                  ),
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) => const DarkModeSettingsWidget()));
                  },
                ),
                const Divider(height: 0),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 12.0),
            alignment: Alignment.bottomCenter,
            child: const Text("Made with ♥ from Greece"),
          ),
        ],
      ),
    );
  }
}