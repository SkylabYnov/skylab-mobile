import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class AuthService {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final GoogleSignIn _googleSignIn = GoogleSignIn();

    Future <User?> signUp (String email, String password) async {
        try {
            UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                email: email,
                password: password
            );
            return userCredential.user;
        } catch (e) {
            print(e);
            return null;
        }
    }

    Future <User?> signIn (String email, String password) async {
        try {
            UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                email: email,
                password: password
            );
            return userCredential.user;
        } catch (e) {
            print(e);
            return null;
        }
    }

    Future<User?> signInWithGoogle() async {
    try {
        final GoogleSignIn googleSignIn = kIsWeb
            ? GoogleSignIn(clientId: 'YOUR_WEB_CLIENT_ID_HERE')
            : GoogleSignIn(); // Android/iOS

        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
        if (googleUser == null) return null; // User canceled

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
        );

        final userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        return userCredential.user;
    } catch (e) {
        print("Google sign-in error: $e");
        return null;
    }
    }


    Future<void> signOut() async {
        await _auth.signOut();
    }
}