import 'dart:io';

import 'package:dio/dio.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';

class ApiClient {
  final _baseUrl = "https://movil-api.herokuapp.com";
  Dio _dio;
  
  ApiClient() {
    _dio = new Dio();
    _dio.options.baseUrl = _baseUrl;
  }

  Future<Map<String, dynamic>> signUp(User newUser) async {
    Map<String, dynamic> body = {
      "email": newUser.email,
      "password": newUser.password,
      "username": newUser.username,
      "name": newUser.name
    };

    try {
      Response<Map> response = await _dio.post("/signup", data: body);
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has ocurred" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response;
    }
  }

  Future<Map<String, dynamic>> signIn(User newUser) async {
    Map<String, dynamic> body = {
      "email": newUser.email,
      "password": newUser.password
    };

    try {
      Response<Map> response = await _dio.post("/signin", data: body);
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has ocurred" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response;
    }
  }

  Future<Map<String, dynamic>> checkToken(String token) async {
    Map<String, dynamic> body = { "token": token };
    
    try {
      Response<Map> response = await _dio.post("/check/token", data: body);
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has ocurred" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response;
    }
  }

  Future<Map<String, dynamic>> getCourses(User currentUser, String token) async {
    try {
      Map<String, dynamic> headers = { HttpHeaders.authorizationHeader: token };
      Response<List> response = await _dio.get("/${currentUser.username}/courses", options: Options(headers: headers));
      return { "courses": response.data };
    } on DioError catch (error) {
      print(error);
      Map<String, dynamic> response = { "error": "An error has occured" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response;
    }
  }

  Future<Map<String, dynamic>> createCourse(User currentUser, String token) async {
    try {
      Map<String, dynamic> headers = { HttpHeaders.authorizationHeader: token };
      Response<Map> response = await _dio.post("/${currentUser.username}/courses", options: Options(headers: headers));
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has occured" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response;
    }
  }

  Future<Map<String, dynamic>> restartCourses(User currentUser, String token) async {
    try {
      Map<String, dynamic> headers = { HttpHeaders.authorizationHeader: token };
      Response<Map> response = await _dio.get("/${currentUser.username}/restart", options: Options(headers: headers));
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has occured" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response;  
    }
  }

  Future<Map<String, dynamic>> getCourseDetails(User currentUser, int courseId, String token) async {
    try {
      Map<String, dynamic> headers = { HttpHeaders.authorizationHeader: token };
      Response<Map> response = await _dio.get("/${currentUser.username}/courses/${courseId}", options: Options(headers: headers));
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has occured" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response; 
    }
  }

  Future<Map<String, dynamic>> getStudentDetails(User currentUser, int studentId, String token) async {
    try {
      Map<String, dynamic> headers = { HttpHeaders.authorizationHeader: token };
      Response<Map> response = await _dio.get("/${currentUser.username}/students/${studentId}", options: Options(headers: headers));
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has occured" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response; 
    }
  }

  Future<Map<String, dynamic>> getProfessorDetails(User currentUser, int professorId, String token) async {
    try {
      print("/${currentUser.username}/professors/${professorId}");
      Map<String, dynamic> headers = { HttpHeaders.authorizationHeader: token };
      Response<Map> response = await _dio.get("/${currentUser.username}/professors/${professorId}", options: Options(headers: headers));
      return response.data;
    } on DioError catch (error) {
      Map<String, dynamic> response = { "error": "An error has occured" };
      if (error.response != null && error.response.data != null && error.response.data.containsKey("error")) response = error.response.data;
      return response; 
    }
  }
}