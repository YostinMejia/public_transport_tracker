import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:public_transport_tracker/data/datasources/firebase_auth_datasource.dart';

//TODO: the models should be the latest repository implementing others respositories to
// login, signup, and do any operation it needs

class AuthRepository {
  final FirebaseAuthDatasource _firebaseAuthDatasource;

  AuthRepository({required firebaseAuthDatasource})
    : _firebaseAuthDatasource = firebaseAuthDatasource;

  Stream<User?> authStateChanges() {
    return _firebaseAuthDatasource.authStateChanges();
  }

  Future<UserCredential> signInAnonymously() {
    return _firebaseAuthDatasource.signInAnonymously();
  }

   Future<void> signOut() {
    return _firebaseAuthDatasource.signOut();
  }

  Future<UserCredential> createUserWithEmailAndPassword(
    String email,
    String password,
  ) {
    return _firebaseAuthDatasource.createUserWithEmailAndPassword(
      email,
      password,
    );
  }

}
