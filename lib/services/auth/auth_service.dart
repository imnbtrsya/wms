import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Login Function
  Future<String?> login(String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Navigate to home screen after successful login
      Navigator.pushReplacementNamed(context, '/home');
      return null; // success, no error
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // Register Function
  Future<String?> register(String email, String password, BuildContext context) async {
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);

      // Navigate to home screen after successful registration
      Navigator.pushReplacementNamed(context, '/home');
      return null; // success
    } on FirebaseAuthException catch (e) {
      return e.message;
    } catch (e) {
      return 'An unexpected error occurred';
    }
  }

  // Logout Function
  Future<void> logout(BuildContext context) async {
    await _auth.signOut();
    Navigator.pushReplacementNamed(context, '/login');
  }

  // Check if user is logged in
  User? get currentUser => _auth.currentUser;
}
