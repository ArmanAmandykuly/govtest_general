import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_core/firebase_core.dart';

class AuthViewModel extends ChangeNotifier {
  final auth = FirebaseAuth.instanceFor(app: Firebase.app());

  String? emailErrorMessage;
  String? passwordErrorMessage;
  String? errorMessage;

  Future<User?> createUserWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final cred = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      auth.authStateChanges();
      notifyListeners();
      return cred.user;
    } catch (e) {
      log("ERROR:$e");
      errorMessage = e.toString();
    }
    notifyListeners();
    return null;
  }

  Future<User?> loginUserWithEmailAndPassword(
    String email,
    String password,
    VoidCallback actionAfter,
  ) async {
    try {
      final cred = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      auth.authStateChanges();
      notifyListeners();
      actionAfter();
      return cred.user;
    } catch (e) {
      log("ERROR: $e");
      errorMessage = e.toString();
      notifyListeners();
    }
    return null;
  }
}
