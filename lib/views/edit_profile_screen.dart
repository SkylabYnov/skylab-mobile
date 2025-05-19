import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:skylab_mobile/view_models/user_view_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  bool isEditingName = false;
  bool isEditingPassword = false;

  late TextEditingController _nameController;
  late TextEditingController _passwordController;

  @override
  void initState() {
    super.initState();
    final user = FirebaseAuth.instance.currentUser;

    _nameController = TextEditingController(text: user?.displayName ?? '');
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _saveChanges(UserViewModel userViewModel) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        if (isEditingName) {
          await user.updateDisplayName(_nameController.text);
        }
        if (isEditingPassword && _passwordController.text.isNotEmpty) {
          await user.updatePassword(_passwordController.text);
        }

        await user.reload();
        userViewModel.loadUser();

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Profile updated")),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        print("Update failed: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final userViewModel = Provider.of<UserViewModel>(context);
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // NAME
              Row(
                children: [
                  Expanded(
                    child: isEditingName
                        ? TextFormField(
                            controller: _nameController,
                            decoration: const InputDecoration(labelText: "Name"),
                          )
                        : Text("Name: ${user?.displayName ?? ''}"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditingName = !isEditingName;
                      });
                    },
                    child: Text(isEditingName ? "Cancel" : "Edit"),
                  )
                ],
              ),

              const SizedBox(height: 16),

              // EMAIL
              Row(
                children: [
                  Expanded(
                    child: Text("Email: ${user?.email ?? ''}"),
                  ),
                  const TextButton(
                    onPressed: null, 
                    child: Text("Edit"),
                  )
                ],
              ),

              const SizedBox(height: 16),

              // PASSWORD
              Row(
                children: [
                  Expanded(
                    child: isEditingPassword
                        ? TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: const InputDecoration(labelText: "New Password"),
                          )
                        : const Text("Password: ********"),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        isEditingPassword = !isEditingPassword;
                      });
                    },
                    child: Text(isEditingPassword ? "Cancel" : "Change"),
                  )
                ],
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => _saveChanges(userViewModel),
                child: const Text("Save Changes"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
