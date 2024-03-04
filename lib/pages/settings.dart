import 'package:flutter/material.dart';

class SettingsWidget extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables
  SettingsWidget({super.key});

  @override
  State<SettingsWidget> createState() => _SettingsWidgetState();
}

class _SettingsWidgetState extends State<SettingsWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: Settings page
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
              InkWell(
                child: const ListTile(
                  title: Text("Currency"),
                  subtitle: Text("€"),
                ),
                onTap: () async {
                  final String? currency = await showDialog<String>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Please type in the symbol or name of your currency"),
                      content: Form(
                        key: _formKey,
                        child: TextFormField(
                          initialValue: "", // TODO: Currently saved currency
                          validator: (value) {
                            if (value == null || value.isEmpty ||value.length > 5) {
                              return "Please enter up to five characters";
                            }
                            return null;
                          },
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("OK"),
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              // TODO: Save currency to preferences
                              Navigator.of(context).pop();
                            }
                          },
                        ),
                      ],
                    ),
                  );
                },
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