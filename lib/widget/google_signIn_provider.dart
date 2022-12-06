import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInProvider extends ChangeNotifier {
  final googleSignin = GoogleSignIn();
  GoogleSignInAccount? _user;
  GoogleSignInAccount get user {
    return _user!;
  }

  Future googleLogin() async {
    try {
      final googleUser = await googleSignin.signIn();
      if (googleUser == null) {
        return null;
      } else {
        _user = googleUser;
      }

      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
    } catch (e) {
      print("ERROR GOOGLE LOGIN: " + e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignin.disconnect();
    FirebaseAuth.instance.signOut();
  }
}
