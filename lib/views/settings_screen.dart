import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/core/theme/dark_theme.dart';
import 'package:skylab_mobile/core/theme/theme_provider.dart';
import '../services/auth_service.dart';
import 'package:skylab_mobile/views/login_screen.dart';
import 'package:skylab_mobile/views/edit_profile_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text("Account", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Edit Profile"),
            onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const EditProfileScreen()),
                );
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Sign Out"),
            onTap: () async {
                await AuthService().signOut();
                Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginScreen()),
                );
            },
            ),

          const Divider(height: 32),

          const Text("Preferences", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          SwitchListTile(
            secondary: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            value: themeProvider.themeData == darkTheme,
            onChanged: (value) {
              themeProvider.toggleTheme();
            },
          ),
          const Divider(height: 32),

          const Text("About", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          ListTile(
            leading: const Icon(Icons.info_outline),
            title: const Text("About Skylab"),
            subtitle: const Text("Version 1.0.0\nAn app to control your drone."),
            isThreeLine: true,
          ),
        ],
      ),
    );
  }
}
