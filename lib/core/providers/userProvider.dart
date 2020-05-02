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
    final String sharedUsername = prefs.getString('username') ?? null;
    final String sharedName = prefs.getString('name') ?? null;
    
    if (sharedEmail == null || sharedPassword == null) return;
    if (sharedLogged) {
      _currentUser = User(sharedEmail, sharedPassword, sharedUsername, sharedName);
      _isLogged = true;
      notifyListeners();
    }
  }

  signIn(User newUser) async {
    SharedPreferences prefs = await _prefs;
    final String sharedEmail = prefs.getString('email') ?? null;
    final String sharedPassword = prefs.getString('password') ?? null;
    final String sharedUsername = prefs.getString('username') ?? null;
    final String sharedName = prefs.getString('name') ?? null;

    if (sharedEmail == null || sharedPassword == null || sharedUsername == null || sharedName == null) return;
    if (sharedEmail == newUser.email && sharedPassword == newUser.password) {
      await prefs.setBool('isLogged', true);
      
      newUser.username = sharedUsername;
      newUser.name = sharedName;
      _currentUser = newUser;
      _isLogged = true;
      notifyListeners();
    }
  }

  signUp(User newUser) async {
    SharedPreferences prefs = await _prefs;
    final String sharedEmail = prefs.getString('email') ?? null;

    if (sharedEmail != newUser.email) {
      await prefs.setString('email', newUser.email);
      await prefs.setString('password', newUser.password);
      await prefs.setString('username', newUser.username);
      await prefs.setString('name', newUser.name);
      await prefs.setBool('isLogged', true);

      _currentUser = newUser;
      _isLogged = true;
      notifyListeners();
    }
  }

  logOut() async {
    SharedPreferences prefs = await _prefs;
    await prefs.clear();

    _isLogged = false;
    notifyListeners();
  }
}
