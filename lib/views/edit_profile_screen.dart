import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/view_models/user_view_model.dart';
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
        padding: const EdgeInsets.all(16),
        child: Form(
          child: Column(
            children: [
              // NAME
              Row(
                children: [
                  Expanded(
                    child: userViewModel.isEditingName
                        ? TextFormField(
                            controller: userViewModel.nameController,
                            decoration: const InputDecoration(labelText: "Name"),
                          )
                        : Text("Name: ${user?.name ?? ''}"),
                  ),
                  TextButton(
                    onPressed: userViewModel.toggleNameEditing,
                    child: Text(userViewModel.isEditingName ? "Cancel" : "Edit"),
                  )
                ],
              ),

              const SizedBox(height: 16),

              // EMAIL
              Row(
                children: [
                  Expanded(child: Text("Email: ${user?.email ?? ''}")),
                  const Text("(Email can't be changed)", style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 16),

              // PASSWORD
              Row(
                children: [
                  Expanded(
                    child: userViewModel.isEditingPassword
                        ? TextFormField(
                            controller: userViewModel.passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: "New Password"),
                          )
                        : const Text("Password: ********"),
                  ),
                  TextButton(
                    onPressed: userViewModel.togglePasswordEditing,
                    child: Text(userViewModel.isEditingPassword ? "Cancel" : "Change"),
                  )
                ],
              ),

              const SizedBox(height: 24),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  userViewModel.updateProfile(context);
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => SettingsScreen()),
                  );
                },
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
