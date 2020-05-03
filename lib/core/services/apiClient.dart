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
      if (error.response != null && error.response.data.containsKey("error")) response = error.response.data;
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
      if (error.response != null && error.response.data.containsKey("error")) response = error.response.data;
      return response;
    }
  }
}