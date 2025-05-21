import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class UserViewModel extends ChangeNotifier {
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  UserModel? _user;
  bool isEditingName = false;
  bool isEditingPassword = false;

  UserModel? get userModel => _user;
  User? get firebaseUser => _auth.currentUser;

  void loadUser() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = UserModel(
        id: currentUser.uid,
        name: currentUser.displayName ?? '',
        email: currentUser.email ?? '',
        profileImageUrl: currentUser.photoURL,
      );
      nameController.text = currentUser.displayName ?? '';
      passwordController.clear();
      notifyListeners();
    }
  }

  Future<bool> login(String email, String password) async {
    try {
      UserCredential credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      _user = UserModel(
        id: credential.user!.uid,
        name: credential.user!.displayName ?? '',
        email: credential.user!.email ?? '',
        profileImageUrl: credential.user!.photoURL,
      );

      notifyListeners();
      return true;
    } catch (e) {
      print("Login failed: $e");
      return false;
    }
  }

  Future<bool> signUp(String email, String password) async {
    try {
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await credential.user!.updateDisplayName("New User");

      _user = UserModel(
        id: credential.user!.uid,
        name: "New User",
        email: credential.user!.email ?? '',
        profileImageUrl: credential.user!.photoURL,
      );

      notifyListeners();
      return true;
    } catch (e) {
      print("Sign-up failed: $e");
      return false;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }

  void toggleNameEditing() {
    isEditingName = !isEditingName;
    notifyListeners();
  }

  void togglePasswordEditing() {
    isEditingPassword = !isEditingPassword;
    notifyListeners();
  }

  Future<void> updateProfile(BuildContext context) async {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      try {
        if (isEditingName) {
          await currentUser.updateDisplayName(nameController.text);
        }
        if (isEditingPassword && passwordController.text.isNotEmpty) {
          await currentUser.updatePassword(passwordController.text);
        }

        await currentUser.reload();
        loadUser();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile updated")),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  void resetEditState() {
    isEditingName = false;
    isEditingPassword = false;
    notifyListeners();
  }

  @override
  void dispose() {
    nameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
