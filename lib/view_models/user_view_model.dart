import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user.dart';

class UserViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  UserModel? _user;

  UserModel? get user => _user;

  // Fetch the current user
  void loadUser() {
    final currentUser = _auth.currentUser;
    if (currentUser != null) {
      _user = UserModel(
        id: currentUser.uid,
        name: currentUser.displayName ?? '',
        email: currentUser.email ?? '',
        profileImageUrl: currentUser.photoURL,
      );
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

        _user = UserModel(
        id: credential.user!.uid,
        name: credential.user!.displayName ?? '',
        email: credential.user!.email ?? '',
        profileImageUrl: credential.user!.photoURL,
        );

        notifyListeners();
        return true;
    } catch (e) {
        print("Signup failed: $e");
        return false;
    }
    }

  Future<void> signOut() async {
    await _auth.signOut();
    _user = null;
    notifyListeners();
  }
}
