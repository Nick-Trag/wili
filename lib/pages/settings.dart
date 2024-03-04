import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
            children: <Widget>[
              Consumer<SettingsProvider>(
                builder: (context, provider, child) => InkWell(
                  child: ListTile(
                    title: const Text("Currency"),
                    subtitle: Text(provider.currency),
                  ),
                  onTap: () async {
                    await showDialog<String>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text("Please type in the symbol or name of your currency"),
                        content: Form(
                          key: _formKey,
                          child: TextFormField(
                            initialValue: provider.currency,
                            validator: (value) {
                              if (value == null || value.isEmpty ||value.length > 5) {
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
                            child: const Text("OK"),
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                provider.setCurrency(_currency);
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
              InkWell(
                child: const ListTile(
                  title: Text('Edit categories'),
                ),
                onTap: () {
                  // TODO: Show all categories and let users delete and rename them (always keeping one alive)
                },
              ),
              const Divider(height: 0),
            ],
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