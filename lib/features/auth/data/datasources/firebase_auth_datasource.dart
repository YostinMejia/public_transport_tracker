import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthDatasource {
  Stream<User?> authStateChanges() {
    return FirebaseAuth.instance.idTokenChanges();
  }

  Future<void> signOut() {
    return FirebaseAuth.instance.signOut();
  }

  Future<UserCredential> signInAnonymously() {
    return FirebaseAuth.instance.signInAnonymously();
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) {
    return FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<UserCredential> signInEmailAndPassword(String email, String password) {
    return FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  //FIXME: implement a custom claim to assing user rols
  String getRol() {
    return "bus";
  }
}
