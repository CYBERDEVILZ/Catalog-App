import 'package:catalog_app/utils/routes.dart';
import 'package:catalog_app/utils/themes.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListTile(
              title: const Text("Dark Mode"),
              trailing: Switch(
                value: context.watch<ThemeProvider>().getTheme,
                onChanged: (boolval) {
                  context.read<ThemeProvider>().setTheme();
                },
                activeColor: Colors.blue[300],
              ),
            ),
            ListTile(
              title: const Text("Profile Settings"),
              trailing: const Icon(Icons.arrow_right),
              onTap: () {
                Navigator.pushNamed(context, Routes.profileSettings);
              },
            ),
          ],
        ),
      ),
    );
  }
}
