import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/view_models/user_view_model.dart';
import 'package:skylab_mobile/widgets/buttons/primary_button.dart';
import 'package:skylab_mobile/views/settings_screen.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = userViewModel.userModel;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 20),

            /// --- NAME ---
            const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            userViewModel.isEditingName
                ? Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: userViewModel.nameController,
                          decoration: const InputDecoration(hintText: "Enter new name"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: userViewModel.toggleNameEditing,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(user?.name ?? 'No name'),
                      TextButton(
                        onPressed: userViewModel.toggleNameEditing,
                        child: const Text("Edit"),
                      ),
                    ],
                  ),
            const SizedBox(height: 24),

            /// --- EMAIL ---
            const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(user?.email ?? 'No email'),
            const Text("(Email can't be changed)", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 24),

            /// --- PASSWORD ---
            const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
            userViewModel.isEditingPassword
                ? Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: userViewModel.passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(hintText: "New password"),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: userViewModel.togglePasswordEditing,
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("********"),
                      TextButton(
                        onPressed: userViewModel.togglePasswordEditing,
                        child: const Text("Change"),
                      ),
                    ],
                  ),
            const Spacer(),

            /// --- SAVE BUTTON ---
            PrimaryButton(
              onPressed: () {
                userViewModel.updateProfile(context);
                userViewModel.resetEditState(); // <- RESET edit mode
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                );
              },
              child: const Text("Save Changes"),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
