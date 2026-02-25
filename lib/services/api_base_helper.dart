// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:sisfo_mobile/services/global_config.dart';

class ApiBaseHelper {
  Client http = Client();

  Future<dynamic> get({
    required String url,
    bool needToken = false,
    String token = '',
  }) async {
    var responseJson;
    try {
      final response = await http.get(Uri.parse(config.api + url),
          headers: needToken
              ? {
                  'Content-Type': 'application/json',
                  HttpHeaders.authorizationHeader: 'Bearer $token'
                }
              : null);
      responseJson = [response.statusCode, response.body];
    } on SocketException {
      responseJson = [null, null];
    }

    return responseJson;
  }

  Future<dynamic> post({
    required String url,
    bool needToken = false,
    String token = '',
    required var data,
  }) async {
    var responseJson;
    try {
      final uri = Uri.parse(config.api + url);
      final headers = <String, String>{
        'Content-Type': 'application/json',
        ...(needToken
            ? {HttpHeaders.authorizationHeader: 'Bearer $token'}
            : {}),
      };
      final body = data is Map ? jsonEncode(data) : data;
      final response = await http.post(uri, headers: headers, body: body);
      responseJson = [response.statusCode, response.body];
    } on SocketException {
      responseJson = [null, null];
    } catch (e) {
      responseJson = [null, null];
      assert(() {
        print('ApiBaseHelper.post error: $e');
        return true;
      }());
    }
    return responseJson;
  }

  Future<dynamic> put({
    required String url,
    bool needToken = false,
    String token = '',
    required var data,
  }) async {
    var responseJson;
    try {
      final response = await http.put(Uri.parse(config.api + url),
          body: data,
          headers: needToken
              ? {
                  'Content-Type': 'application/json',
                  HttpHeaders.authorizationHeader: 'Bearer $token'
                }
              : null);
      responseJson = [response.statusCode, response.body];
    } on SocketException {
      responseJson = [null, null];
    }
    return responseJson;
  }
}
