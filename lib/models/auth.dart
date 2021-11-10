import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Auth with ChangeNotifier {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authstateChanges {
    return auth.authStateChanges();
  }

  Future<void> signup(String? email, String? password) async {
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email!,
        password: password!,
      );
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // print(json.decode(response.body));
  }

  Future<void> login(String? email, String? password) async {
    try {
      UserCredential userCredential = await auth.signInWithEmailAndPassword(
          email: email!, password: password!);
      notifyListeners();
      // _info(userCredential);
      // print(userCredential.user!.uid);
    } catch (error) {
      throw error;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
    notifyListeners();
  }

  Future<void> addUser() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    var count = 0;
    users.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        if (value.docs[i]['Username'] == auth.currentUser!.email ||
            count == 1) {
          count = 1;
          break;
        }
        print("hello");
      }
      if (count == 0) {
        users.add(
          {
            "Username": auth.currentUser!.email,
            "role": "User",
          },
        );
      }
    });
  }

  Future<String?> userRole() async {
    var role;
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    await users.get().then((value) {
      for (int i = 0; i < value.docs.length; i++) {
        // print(value.docs[i]['Username']);
        if (value.docs[i]['Username'] == auth.currentUser!.email) {
          role = value.docs[i]['role'];
          print(role);
        }
      }
    });
    return role;
  }
}
