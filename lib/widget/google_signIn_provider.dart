import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleProvider extends ChangeNotifier {
  final googleSignin = GoogleSignIn();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final currentAuth = FirebaseAuth.instance.currentUser;
  CollectionReference _users = FirebaseFirestore.instance.collection('users');
  UserCredential? _userCredential;
  User? userLogIn;
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
      _userCredential = await _auth.signInWithCredential(credential);
      userLogIn = _userCredential!.user;
      if (userLogIn != null) {
        if (_userCredential!.additionalUserInfo!.isNewUser) {
          Map<String, dynamic> data = {
            'username': userLogIn!.displayName,
            'email': userLogIn!.email,
            'uid': userLogIn!.uid,
            'profilePhoto': userLogIn!.photoURL,
          };
          await _firestore.collection('users').doc(userLogIn!.uid).set(data);
        }
      }
    } catch (e) {
      print("ERROR GOOGLE LOGIN: " + e.toString());
    }

    notifyListeners();
  }

  Future logout() async {
    await googleSignin.disconnect();
    FirebaseAuth.instance.signOut();
  }

  Future updateUser(String name, String email) async {
    Map<String, dynamic> dataUpdate = {
      'username': name,
      'email': email,
    };
    await _users.doc(userLogIn!.uid).update(dataUpdate);
  }
}
