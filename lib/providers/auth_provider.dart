import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:invetory_management1/services/auth_service.dart';
import 'package:provider/provider.dart';

class AuthProvider with ChangeNotifier{ // notify ui components
  final AuthService _authService=AuthService(); //where ever authentication changes
  User? _user;
  User? get user => _user;

  Future<bool> register(String email, String password) async {
    _user = await _authService.register(email, password);
    notifyListeners();
    return _user != null;
  }

  Future<bool> login (String email, String password) async {
    _user = await _authService.login(email, password);
    notifyListeners();
    return _user != null;
  }
  Future<void> logout() async {
    await _authService.logout();
    _user = null;
    notifyListeners();
  }
}