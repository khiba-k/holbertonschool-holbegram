import 'dart:typed_data';
// import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:holbegram/models/user.dart';

class AuthMethods {
  final auth.FirebaseAuth _auth = auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String username,
    Uint8List? file,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty && username.isNotEmpty) {
        auth.UserCredential cred = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        User user = User(
          uid: cred.user!.uid,
          email: email,
          username: username,
          bio: '',
          photoUrl: '',
          followers: [],
          following: [],
          posts: [],
          saved: [],
          searchKey: username[0].toUpperCase(),
        );

        await _firestore
            .collection('users')
            .doc(cred.user!.uid)
            .set(user.toJson());

        res = "success";
      } else {
        res = "Please fill all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<String> login({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please fill all the fields";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

  Future<User> getUserDetails() async {
      auth.User currentUser = _auth.currentUser!;

    DocumentSnapshot documentSnapshot = await _firestore
      .collection('users')
      .doc(currentUser.uid)
      .get();

    return User.fromSnap(documentSnapshot);
  }
}
