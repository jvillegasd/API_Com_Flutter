import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';

class UserProvider extends ChangeNotifier {
  User _currentUser;
  bool _isLogged = false;
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool get isLogged => _isLogged;
  User get currentUser => _currentUser;

  authentication() async {
    SharedPreferences prefs = await _prefs;
    bool sharedLogged = prefs.getBool('isLogged') ?? false;
    final String sharedEmail = prefs.getString('email') ?? null;
    final String sharedPassword = prefs.getString('password') ?? null;
    
    if (sharedEmail == null || sharedPassword == null) return;
    if (sharedLogged) {
      _currentUser = User(sharedEmail, sharedPassword);
      _isLogged = true;
      notifyListeners();
    }
  }

  signIn(String email, String password) async {
    SharedPreferences prefs = await _prefs;
    final String sharedEmail = prefs.getString('email') ?? null;
    final String sharedPassword = prefs.getString('password') ?? null;

    if (sharedEmail == null || sharedPassword == null) return;
    if (sharedEmail == email && sharedPassword == password) {
      await prefs.setBool('isLogged', true);

      _currentUser = User(sharedEmail, sharedPassword);
      _isLogged = true;
      notifyListeners();
    }
  }

  signUp(String email, String password) async {
    SharedPreferences prefs = await _prefs;
    final String sharedEmail = prefs.getString('email') ?? null;

    if (sharedEmail != email) {
      await prefs.setString('email', email);
      await prefs.setString('password', password);
      await prefs.setBool('isLogged', true);

      _currentUser = User(email, password);
      _isLogged = true;
      notifyListeners();
    }
  }

  logOut() async {
    SharedPreferences prefs = await _prefs;
    await prefs.setBool('isLogged', false);

    _isLogged = false;
    notifyListeners();
  }
}
