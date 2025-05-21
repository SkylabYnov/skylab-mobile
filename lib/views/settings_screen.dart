import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/core/theme/dark_theme.dart';
import 'package:skylab_mobile/core/theme/theme_provider.dart';
import 'package:skylab_mobile/services/auth_service.dart';
import 'package:skylab_mobile/views/login_screen.dart';
import 'package:skylab_mobile/views/edit_profile_screen.dart';
import 'package:skylab_mobile/widgets/buttons/primary_button.dart';

import 'package:skylab_mobile/widgets/buttons/link_text_button.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "Account",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            ),
            const SizedBox(height: 12),
            PrimaryButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
              },
              child: const Text("Edit Profile"),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "Preferences",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            ),
            const SizedBox(height: 12),
            SwitchListTile(
              secondary: const Icon(Icons.dark_mode),
              title: const Text("Dark Mode"),
              value: themeProvider.themeData == darkTheme,
              onChanged: (value) => themeProvider.toggleTheme(),
            ),
            const SizedBox(height: 32),
            const Align(
              alignment: Alignment.centerLeft,

              child: Text(
                "About",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),

            ),
            const SizedBox(height: 12),
            const ListTile(
              leading: Icon(Icons.info_outline),
              title: Text("About Skylab"),
              subtitle: Text("Version 1.0.0\nAn app to control your drone."),
              isThreeLine: true,
            ),
            const SizedBox(height: 30),
            Center(

              child: LinkTextButton(
                text: "Log out",
                onPressed: () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                ),
                textColor: Colors.red,

              ),
            ),
          ],
        ),
      ),
    );
  }
}
