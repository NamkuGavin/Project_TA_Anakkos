import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:project_anakkos_app/widget/snackbar_widget.dart';

class FirebaseService {
  Future<bool> signInGoogle(BuildContext context) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
        await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        await FirebaseAuth.instance
            .signInWithCredential(credential)
            .then((value) {
          FirebaseFirestore.instance.runTransaction((transaction) async {
            DocumentReference documentReference = FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid);
            DocumentSnapshot snapshot =
                await transaction.get(documentReference);

            if (!snapshot.exists) {
              await documentReference.set({
                'email': googleSignInAccount.email,
                'full_name': googleSignInAccount.displayName,
                'photo_profile': '',
                'created_at': DateTime.now(),
                'updated_at': DateTime.now(),
              });
            } else {
              documentReference.update({
                'updated_at': DateTime.now(),
              });
            }
          });
        });
        return true;
      } on FirebaseAuthException catch (e) {
        return false;
      } on SocketException {
        showSnackBar(context, title: 'Tidak ada koneksi internet');
        return false;
      } on PlatformException {
        return false;
      }
    } else {
      return false;
    }
  }

  Future<bool> editProfileWithImage(
    BuildContext context, {
    required String name,
    required String fileName,
    required String filePath,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDocument =
          FirebaseFirestore.instance.collection('users').doc(uid);

      final path = 'users/$uid/$name';
      final file = File(filePath);
      final reference =
          FirebaseStorage.instance.ref().child(path).putFile(file);

      final snapshot = await reference.whenComplete(() {});
      final url = await snapshot.ref.getDownloadURL();

      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          transaction.update(userDocument, {
            'full_name': name,
            'photo_profile': url,
          });
          return true;
        },
      );
      return true;
    } on PlatformException {
      return false;
    } on SocketException {
      showSnackBar(context, title: 'Tidak ada koneksi internet');
      return false;
    } on FirebaseException {
      return false;
    }
  }

  Future<bool> editProfile(
    BuildContext context, {
    required String name,
  }) async {
    try {
      String uid = FirebaseAuth.instance.currentUser!.uid;

      DocumentReference userDocument =
          FirebaseFirestore.instance.collection('users').doc(uid);

      FirebaseFirestore.instance.runTransaction(
        (transaction) async {
          transaction.update(userDocument, {
            'full_name': name,
          });
          return true;
        },
      );
      return true;
    } on PlatformException {
      return false;
    } on SocketException {
      showSnackBar(context, title: 'Tidak ada koneksi internet');
      return false;
    } on FirebaseException {
      return false;
    }
  }
}
