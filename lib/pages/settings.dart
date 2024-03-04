import 'package:flutter/material.dart';

class SettingsWidget extends StatelessWidget {
  const SettingsWidget({super.key});

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
                onTap: () {
                  // TODO: Show modal with a TextFormField that makes lets users type in their currency symbol or name
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