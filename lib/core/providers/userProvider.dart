import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';
import 'package:simple_api_consumer_login/core/services/apiClient.dart';

class UserProvider extends ChangeNotifier {
  User _currentUser;
  bool _isLogged = false;
  bool _rememberUser = false;
  String _token = "";
  String _refreshToken = "";
  String _tokenType = "";
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  ApiClient apiClient = new ApiClient();

  bool get isLogged => _isLogged;
  bool get rememberUser => _rememberUser;
  User get currentUser => _currentUser;
  String get token => _token;

  Future<void> setRememberUser(bool newStatus) async {
    SharedPreferences prefs = await _prefs;
    await prefs.setBool("rememberUser", newStatus);
    _rememberUser = newStatus;
    notifyListeners();
  }

  Future<void> authentication() async {
    SharedPreferences prefs = await _prefs;
    bool sharedLogged = prefs.getBool('isLogged') ?? false;
    final String sharedEmail = prefs.getString('email') ?? null;
    final String sharedPassword = prefs.getString('password') ?? null;
    final String sharedUsername = prefs.getString('username') ?? null;
    final String sharedName = prefs.getString('name') ?? null;
    final String sharedToken = prefs.getString("token") ?? null;
    final String sharedRefreshToken = prefs.getString("refreshToken") ?? null;
    final String sharedTokenType = prefs.getString("tokenType") ?? null;
    bool sharedRememberUser = prefs.getBool("rememberUser") ?? false;

    if (await _somethingIsCached(prefs)) {
      if (sharedLogged && await _checkToken(prefs)) {
        _currentUser =
            User(sharedEmail, sharedPassword, sharedUsername, sharedName);
        _token = sharedToken;
        _refreshToken = sharedRefreshToken;
        _tokenType = sharedTokenType;
        _isLogged = true;
      } else {
        _isLogged = false;
        if (sharedRememberUser) {
          _currentUser =
              User(sharedEmail, sharedPassword, sharedUsername, sharedName);
        } else
          await prefs.clear();
      }
    }
    _rememberUser = sharedRememberUser;
    notifyListeners();
  }

  Future<Map<String, dynamic>> signIn(User newUser) async {
    SharedPreferences prefs = await _prefs;
    final String sharedEmail = prefs.getString('email') ?? null;
    final String sharedPassword = prefs.getString('password') ?? null;

    if (await _somethingIsCached(prefs)) {
      if (sharedEmail == newUser.email && sharedPassword == newUser.password) {
        if (await _checkToken(prefs)) {
          final String sharedName = prefs.getString("name");
          final String sharedUsername = prefs.getString("username");
          final String sharedToken = prefs.getString("token");
          final String sharedRefreshToken = prefs.getString("refreshToken");
          final String sharedTokenType = prefs.getString("tokenType");

          await prefs.setBool("isLogged", true);

          newUser.name = sharedName;
          newUser.username = sharedUsername;
          _isLogged = true;
          _token = sharedToken;
          _refreshToken = sharedRefreshToken;
          _tokenType = sharedTokenType;
          notifyListeners();
          return {"message": "User logged"};
        } else
          return await _signIn(newUser, prefs);
      } else {
        return await _signIn(newUser, prefs);
      }
    } else {
      return await _signIn(newUser, prefs);
    }
  }

  logOut() async {
    SharedPreferences prefs = await _prefs;
    if (_rememberUser) {
      await prefs.setBool('isLogged', false);
    } else
      await prefs.clear();
    _isLogged = false;
    notifyListeners();
  }

  Future<Map<String, dynamic>> signUp(User newUser) async {
    SharedPreferences prefs = await _prefs;
    final String sharedEmail = prefs.getString('email') ?? null;

    if (sharedEmail != newUser.email) {
      Map<String, dynamic> response = await apiClient.signUp(newUser);

      if (!response.containsKey("error")) {
        await prefs.setString('email', newUser.email);
        await prefs.setString('password', newUser.password);
        await prefs.setString('username', newUser.username);
        await prefs.setString('name', newUser.name);
        await prefs.setString('token', response["token"]);
        await prefs.setString('refreshToken', response["refreshToken"]);
        await prefs.setString("tokenType", response["type"]);
        await prefs.setBool('isLogged', true);

        _currentUser = newUser;
        _isLogged = true;
        _token = response["token"];
        _refreshToken = response["refreshToken"];
        _tokenType = response["type"];
        notifyListeners();
        return {"message": "User created"};
      } else
        return {"error": response["error"]};
    } else
      return {"error": "User already cached in local storage"};
  }

  Future<Map<String, dynamic>> _signIn(
      User newUser, SharedPreferences prefs) async {
    Map<String, dynamic> response = await apiClient.signIn(newUser);

    if (!response.containsKey("error")) {
      await prefs.setString('email', newUser.email);
      await prefs.setString('password', newUser.password);
      await prefs.setString('username', response["username"]);
      await prefs.setString('name', response["name"]);
      await prefs.setString('token', response["token"]);
      await prefs.setString('refreshToken', response["refreshToken"]);
      await prefs.setString("tokenType", response["type"]);
      await prefs.setBool('isLogged', true);

      newUser.username = response["username"];
      newUser.name = response["name"];
      _currentUser = newUser;
      _isLogged = true;
      _token = response["token"];
      _refreshToken = response["refreshToken"];
      _tokenType = response["type"];
      notifyListeners();
      return {"message": "User logged"};
    } else
      return {"error": response["error"]};
  }

  Future<bool> _somethingIsCached(SharedPreferences prefs) async {
    final String sharedEmail = prefs.getString('email') ?? null;
    final String sharedPassword = prefs.getString('password') ?? null;
    final String sharedUsername = prefs.getString('username') ?? null;
    final String sharedName = prefs.getString('name') ?? null;
    final String sharedToken = prefs.getString('token') ?? null;

    return sharedEmail != null &&
        sharedPassword != null &&
        sharedUsername != null &&
        sharedName != null &&
        sharedToken != null;
  }

  Future<bool> _checkToken(SharedPreferences prefs) async {
    String token = prefs.getString("token");

    Map<String, dynamic> response = await apiClient.checkToken(token);

    return (!response.containsKey("error")) ? response["valid"] : false;
  }

  Future<Map<String, dynamic>> getCourses() async {
    await this.authentication();
    return await apiClient.getCourses(_currentUser, "${_tokenType} ${_token}");
  }

  Future<Map<String, dynamic>> createCourse() async {
    print("asdasdasdasdasdas");
    await this.authentication();
    return await apiClient.createCourse(
        _currentUser, "${_tokenType} ${_token}");
  }

  Future<Map<String, dynamic>> restartCourses() async {
    await this.authentication();
    return await apiClient.restartCourses(
        _currentUser, "${_tokenType} ${_token}");
  }

  Future<Map<String, dynamic>> getCourseDetails(int courseId) async {
    await this.authentication();
    return await apiClient.getCourseDetails(
        _currentUser, courseId, "${_tokenType} ${_token}");
  }

  Future<Map<String, dynamic>> getStudentDetails(int studentId) async {
    await this.authentication();
    return await apiClient.getStudentDetails(
        _currentUser, studentId, "${_tokenType} ${_token}");
  }

  Future<Map<String, dynamic>> getProfessorDetails(int professorId) async {
    await this.authentication();
    return await apiClient.getProfessorDetails(
        _currentUser, professorId, "${_tokenType} ${_token}");
  }

  Future<Map<String, dynamic>> createStudent(int courseId) async {
    await this.authentication();
    return await apiClient.createStudent(
        _currentUser, courseId, "${_tokenType} ${_token}");
  }
}
