import 'package:dio/dio.dart';
import 'package:simple_api_consumer_login/core/models/user.dart';

class ApiClient {
  final _baseUrl = "https://movil-api.herokuapp.com";
  Dio _dio;
  
  ApiClient() {
    _dio = new Dio();
    _dio.options.baseUrl = _baseUrl;
    _dio.options.contentType = Headers.formUrlEncodedContentType;
  }

  Future<Map<String, dynamic>> signUp(User newUser) async {
    Map<String, dynamic> jsonRequest = {
      "email": newUser.email,
      "password": newUser.password,
      "username": newUser.username,
      "name": newUser.name
    };

    Response<Map> response = await _dio.post("/signup", data: jsonRequest);
    return response.data;
  }

  Future<Map<String, dynamic>> signIn(User newUser) async {
    Map<String, dynamic> jsonRequest = {
      "email": newUser.email,
      "password": newUser.password
    };

    Response<Map> response = await _dio.post("/signin", data: jsonRequest);
    return response.data;
  }
}