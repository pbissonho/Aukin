import 'dart:convert';

import 'package:dio/dio.dart';

class RepositorySample {
  RepositorySample(this.dio);

  final Dio dio;

  Future<String> get() async {
    Response response;

    response = await dio.get("/api/sample/read");
    return response.data;
  }

  Future<String> post() async {
    var response = await dio.post("/api/sample/write");
    return response.data;
  }
}
