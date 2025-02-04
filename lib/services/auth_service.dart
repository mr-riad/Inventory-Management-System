import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> register(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } catch (e) {
      print("Registration Error: ${e.toString()}");
      return null;
    }
  }

  Future<User?> login(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      return userCredential.user;
    } catch (e) {
      print("Login Error: ${e.toString()}");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}
